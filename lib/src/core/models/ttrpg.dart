class TTRPGCreate {
  final String name;

  TTRPGCreate({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class TTRPGRead {
  final String name;
  final int id;

  TTRPGRead({
    required this.name,
    required this.id,
  });

  factory TTRPGRead.fromJson(Map<String, dynamic> json) {
    return TTRPGRead(
      name: json['name'],
      id: json['id'],
    );
  }
}

class TTRPGUpdate {
  final String name;

  TTRPGUpdate({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
