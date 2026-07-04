// import 'package:calendar_date_picker2/calendar_date_picker2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart'
//     as bdaya;
// import 'package:intl/intl.dart';
// import 'package:party_planner/src/ui/features/calendar/cubit/calendar_cubit.dart';
// import '../../../../../widgets/event_card.dart';
// import '../../../../../models/event.dart';
// import '../cubit/calendar_state.dart';
//
// class CalendarView extends StatelessWidget {
//   final String userId = '2';
//
//   void _showDatePicker(BuildContext context, CalendarState state) {
//     bdaya.DatePickerBdaya.showDatePicker(
//       context,
//       currentTime: state.selectedDate ?? DateTime.now(),
//       minTime: DateTime.now(),
//       maxTime: DateTime.now().add(const Duration(days: 365)),
//       onConfirm: (date) {
//         context.read<CalendarCubit>().updateDate(date);
//       },
//       theme: bdaya.DatePickerThemeBdaya(
//         headerColor: Theme.of(context).primaryColor,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         itemStyle: TextStyle(
//           color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
//         ),
//         doneStyle: TextStyle(
//           color: Theme.of(context).primaryColor,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       locale: bdaya.LocaleType.en,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CalendarCubit(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Calendar'),
//         ),
//         body: BlocBuilder<CalendarCubit, CalendarState>(
//           builder: (context, state) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Card(
//                     margin: const EdgeInsets.all(8.0),
//                     elevation: 5.0,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                       side: BorderSide(),
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 DateFormat('MMMM yyyy').format(
//                                   state.selectedDate ?? DateTime.now(),
//                                 ),
//                                 style: Theme.of(context).textTheme.titleLarge,
//                               ),
//                             ],
//                           ),
//                         ),
//                         CalendarDatePicker2(
//                           config: CalendarDatePicker2Config(
//                             calendarType: CalendarDatePicker2Type.single,
//                             selectedDayHighlightColor:
//                                 Theme.of(context).primaryColor,
//                           ),
//                           value: [state.selectedDate],
//                           onValueChanged: (dates) {
//                             if (dates.isNotEmpty && dates[0] != null) {
//                               context
//                                   .read<CalendarCubit>()
//                                   .updateDate(dates[0]);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   _buildEventsList(context, state),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEventsList(BuildContext context, CalendarState state) {
//     final events = EventItem.events;
//     return ListView.builder(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: events.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () => openRSVPModal(context, events[index]),
//           child: EventCard(
//             event: events[index],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> openRSVPModal(BuildContext context, EventItem event) async {
//     // Implement your RSVP modal here
//   }
// }
