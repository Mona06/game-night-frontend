class UserCreate {
  final String username;
  final String email;
  final String? displayName;
  final String password;

  UserCreate({
    required this.password,
    this.displayName,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'displayname': displayName,
      'password': password,
    };
  }
}

class UserPublic {
  final String email;
  final String username;
  final String? displayName;
  final int id;

  UserPublic({
    required this.email,
    required this.username,
    this.displayName,
    required this.id,
  });

  factory UserPublic.fromJson(Map<String, dynamic> json) {
    return UserPublic(
      email: json['email'],
      username: json['username'],
      displayName: json['displayname'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'displayname': displayName,
      'id': id,
    };
  }
}

class UserUpdate {
  final String? displayName;
  final String? password;

  UserUpdate({
    this.displayName,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (displayName != null) json['displayname'] = displayName;
    if (password != null) json['password'] = password;
    return json;
  }
}
