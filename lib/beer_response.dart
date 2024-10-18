// To parse this JSON data, do
//
//     final beerResponse = beerResponseFromJson(jsonString);

import 'dart:convert';

List<BeerResponse> beerResponseFromJson(String str) => List<BeerResponse>.from(
    json.decode(str).map((x) => BeerResponse.fromJson(x)));

String beerResponseToJson(List<BeerResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BeerResponse {
  String price;
  String name;
  Rating rating;
  String image;
  int id;

  BeerResponse({
    required this.price,
    required this.name,
    required this.rating,
    required this.image,
    required this.id,
  });

  factory BeerResponse.fromJson(Map<String, dynamic> json) => BeerResponse(
        price: json["price"],
        name: json["name"],
        rating: Rating.fromJson(json["rating"]),
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "name": name,
        "rating": rating.toJson(),
        "image": image,
        "id": id,
      };
}

class Rating {
  double average;
  int reviews;

  Rating({
    required this.average,
    required this.reviews,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        average: json["average"]?.toDouble(),
        reviews: json["reviews"],
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "reviews": reviews,
      };
}
