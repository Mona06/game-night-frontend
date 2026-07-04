import 'package:device_calendar/device_calendar.dart' as device_calendar;
import 'package:party_planner/src/ui/widgets/snackbar.dart';

import '../models/event.dart';

class CalendarService {
  final device_calendar.DeviceCalendarPlugin _deviceCalendarPlugin =
      device_calendar.DeviceCalendarPlugin();

  device_calendar.Calendar? _selectedCalendar;

  Future<void> addEvent(EventCreate event) async {
    await _addToDeviceCalendar(event);
  }

  Future<void> _addToDeviceCalendar(EventCreate event) async {
    await _retrieveCalendar();

    var newEvent = device_calendar.Event(
      _selectedCalendar!.id,
      title: event.title,
      description: event.description,
      start: device_calendar.TZDateTime.local(
        event.startDateTime!.year,
        event.startDateTime!.month,
        event.startDateTime!.day,
        event.startDateTime!.hour,
        event.startDateTime!.minute,
      ),
      end: device_calendar.TZDateTime.local(
        event.endDateTime!.year,
        event.endDateTime!.month,
        event.endDateTime!.day,
        event.endDateTime!.hour,
        event.endDateTime!.minute,
      ),
      location: '${event.country}${event.city}',
      eventId: null,
    );

    var result = await _deviceCalendarPlugin.createOrUpdateEvent(newEvent);

    if (result!.isSuccess && result.data != null) {
      print(result.data!);
      AppSnackBar.show(
        message: 'Event successfully added to device calendar',
        type: SnackBarType.success,
      );
    } else {
      print('Failed to add/update event');
    }
  }

  Future<void> removeEvent(String eventId) async {
    await _deleteFromDeviceCalendar(eventId);
  }

  Future<void> _deleteFromDeviceCalendar(String eventId) async {
    if (_selectedCalendar != null) {
      var result = await _deviceCalendarPlugin.deleteEvent(
        _selectedCalendar!.id,
        eventId,
      );
      if (result.isSuccess && result.data!) {
        print('Event deleted from device calendar');
      } else {
        print('Failed to delete event from device calendar');
      }
    }
  }

  Future<void> _retrieveCalendar() async {
    if (_selectedCalendar == null) {
      var calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendarsResult.isSuccess && calendarsResult.data != null) {
        _selectedCalendar = calendarsResult.data!.firstWhere(
          (calendar) =>
              calendar.isDefault == true && calendar.isReadOnly == false,
          orElse: () => calendarsResult.data!.first,
        );
      }

      if (_selectedCalendar == null) {
        print('No writable calendar found.');
      }
    }
  }
}
