class Extras {
  final String title;
  final String price;
  final String backgroundColor;
  final String imageUrl;
  final int id;
  final int idGroup;

  Extras(
      {this.imageUrl,
      this.title,
      this.backgroundColor,
      this.price,
      this.id,
      this.idGroup});

  Map<String, dynamic> toJson() {
    return {
      "image": imageUrl,
      "title": title,
      "backgroundColor": backgroundColor,
      "price": price,
      "id": id,
      "idGroup": idGroup
    };
  }

  static Extras fromJson(dynamic json) {
    return Extras(
        imageUrl: json['image'],
        title: json['title'],
        backgroundColor: json['backgroundColor'],
        price: json['price'],
        id: json['id'],
        idGroup: json['idGroup']);
  }
}
