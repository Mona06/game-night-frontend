import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

String createICalEvent({
  String? title,
  String? description,
  required DateTime startDate,
  required DateTime endDate,
  String? location,
}) {
  List<String> icsLines = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'BEGIN:VEVENT',
    if (title != null) 'SUMMARY:$title',
    'DTSTART:${startDate.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '')}Z',
    'DTEND:${endDate.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '')}Z',
    if (location != null) 'LOCATION:$location',
    if (description != null)
      'DESCRIPTION:${description.replaceAll('\n', '\\n')}',
    'END:VEVENT',
    'END:VCALENDAR',
  ];

  return icsLines.join('\r\n');
}

Future<void> shareICalEvent(String content) async {
  try {
    Directory tempDir = await getTemporaryDirectory();
    var filePath = '${tempDir.path}/event.ics';
    File icsFile = File(filePath);

    await icsFile.writeAsString(content);
    Share.shareXFiles([XFile(filePath)], text: 'Join my event!');
  } catch (e) {
    print('Error sharing event: $e');
  }
}
