class LocationItem {
  final String address;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;

  LocationItem({
    required this.address,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
  });

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      address: json['address'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  LocationItem copyWith({
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return LocationItem(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
