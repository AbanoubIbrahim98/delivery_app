class Address {
  final int id;
  final String address;
  final double latitude;
  final double longitude;
  bool isDefault;

  Address(
      {this.id, this.address, this.latitude, this.longitude, this.isDefault});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "isDefault": isDefault
    };
  }

  static Address fromJson(dynamic json) {
    return Address(
      id: json['id'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['isDefault'],
    );
  }
}
