import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:party_planner/src/ui/widgets/dialog.dart';

import '../../../../../core/models/event.dart';

import '../../../../../ui/widgets/snackbar.dart';
import '../../../../widgets/typography/btn.dart';
import '../../../../widgets/typography/text_field.dart';
import '../../../../../core/models/location.dart';
import '../../cubit/create_event_cubit.dart';
import '../../cubit/create_event_state.dart';

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  LocationSectionState createState() => LocationSectionState();
}

class LocationSectionState extends State<LocationSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateEventCubit, CreateEventState>(
      listener: (context, state) {
        if (state.address != _controller.text) {
          _controller.text = state.address ?? '';
        }
      },
      builder: (BuildContext context, CreateEventState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Text(
              'Location',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            GradientTextField(
              icon: Icon(Icons.search),
              labelText: 'Location',
              controller: _controller,
              onChanged: (value) => context
                  .read<CreateEventCubit>()
                  .updateLocation(value, '', ''),
            ),
            SizedBox(height: 16),
            Center(
              child: SolidPrimaryBtn(
                text: Text(
                  'Search',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white),
                ),
                onPressed: () => showLocationConfirmation(context),
                //_searchLocation(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showLocationConfirmation(BuildContext context) async {
    final cubit = context.read<CreateEventCubit>();
    if (cubit.state.attendanceFormat == AttendanceFormat.online) {
      return;
    }
    final foundLocation = await _searchLocation(context);

    if (foundLocation != null) {
      final location = LocationDetails(address: foundLocation.address);

      final config = ConfirmationDialogFactory.createLocationConfirmation(
        location: location,
        onConfirm: () => cubit.updateLocation(
          foundLocation.address,
          foundLocation.city,
          foundLocation.country,
        ),
        onCancel: () => cubit.updateLocation(
          '',
          '',
          '',
        ),
      );

      if (context.mounted) {
        await DialogService.showConfirmationDialog(context, config);
      }
    }
  }

  Future<LocationItem?> _searchLocation(BuildContext context) async {
    final cubit = context.read<CreateEventCubit>();
    final searchQuery = cubit.state.address ?? '';

    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(searchQuery);

      if (locations.isNotEmpty) {
        geocoding.Location geoLocation = locations.first;

        List<geocoding.Placemark> placemarks =
            await geocoding.placemarkFromCoordinates(
          geoLocation.latitude,
          geoLocation.longitude,
        );

        if (placemarks.isNotEmpty) {
          geocoding.Placemark place = placemarks.first;

          var location = LocationItem(
            address: searchQuery,
            latitude: geoLocation.latitude,
            longitude: geoLocation.longitude,
            city: place.locality ?? '',
            country: place.country ?? '',
          );
          AppSnackBar.show(
            message: 'Location found',
            type: SnackBarType.success,
          );
          return location;
        }
      } else {
        AppSnackBar.show(
          message: 'No location found for the given address',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      AppSnackBar.show(
        message: 'Error $e',
        type: SnackBarType.error,
      );
    }
    return null;
  }
}
