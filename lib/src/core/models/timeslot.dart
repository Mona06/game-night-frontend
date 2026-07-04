class TimeslotItem {
  final String id;
  final DateTime dateTime;
  final int votes;

  TimeslotItem({
    required this.id,
    required this.dateTime,
    required this.votes,
  });

  factory TimeslotItem.fromJson(Map<String, dynamic> json) {
    return TimeslotItem(
      id: json['id'] as String,
      dateTime: json['dateTime'],
      votes: json['votes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime,
      'votes': votes,
    };
  }
}
