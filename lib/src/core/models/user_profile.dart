class ProfileCreate {
  final String? phoneNumber;
  final String? discordTag;
  final String? shortBio;
  final List<String>? languages;
  final String? birthday;
  final String? city;
  final String? country;

  ProfileCreate({
    this.phoneNumber,
    this.discordTag,
    this.shortBio,
    this.languages,
    this.birthday,
    this.city,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'discord_tag': discordTag,
      'short_bio': shortBio,
      'languages': languages,
      'birthday': birthday,
      'city': city,
      'country': country,
    };
  }
}

class ProfileRead {
  final String? phoneNumber;
  final String? discordTag;
  final String? shortBio;
  final List<String>? languages;
  final DateTime? birthday;
  final String? city;
  final String? country;
  final int id;
  final int userId;

  ProfileRead({
    this.phoneNumber,
    this.discordTag,
    this.shortBio,
    this.languages,
    this.birthday,
    this.city,
    this.country,
    required this.id,
    required this.userId,
  });

  bool get isEmpty => birthday == null && country == null && true;

  factory ProfileRead.fromJson(Map<String, dynamic> json) {
    return ProfileRead(
      phoneNumber: json['phone_number'],
      discordTag: json['discord_tag'],
      shortBio: json['short_bio'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      city: json['city'],
      country: json['country'],
      id: json['id'],
      userId: json['user_id'],
    );
  }
}

class ProfileUpdate {
  final String? phoneNumber;
  final String? discordTag;
  final String? shortBio;
  final List<String>? languages;
  final String? birthday;
  final String? city;
  final String? country;

  ProfileUpdate({
    this.phoneNumber,
    this.discordTag,
    this.shortBio,
    this.languages,
    this.birthday,
    this.city,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'discord_tag': discordTag,
      'short_bio': shortBio,
      'languages': languages,
      'birthday': birthday,
      'city': city,
      'country': country,
    };
  }
}
