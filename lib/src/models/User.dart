class User {
  final int id;
  final String name;
  final String surname;
  final String imageUrl;
  final String phone;
  final String email;

  User(
      {this.id,
      this.name,
      this.surname,
      this.imageUrl,
      this.phone,
      this.email});

  Map<String, String> toJson() {
    return {
      "name": name,
      "surname": surname,
      "imageUrl": imageUrl,
      "phone": phone,
      "id": id.toString(),
      "email": email
    };
  }

  static User fromJson(dynamic json) {
    return User(
        name: json['name'],
        surname: json['surname'],
        imageUrl: json['imageUrl'],
        phone: json['phone'],
        id: int.parse(json['id']),
        email: json['email']);
  }
}
