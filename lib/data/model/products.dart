// To parse this JSON data, do
//
//     final allProductLists = allProductListsFromJson(jsonString);

import 'dart:convert';

AllProductLists allProductListsFromJson(String str) => AllProductLists.fromJson(json.decode(str));

String allProductListsToJson(AllProductLists data) => json.encode(data.toJson());

class AllProductLists {
  bool error;
  String message;
  List<Datum> data;
  int code;
  List<dynamic> query;

  AllProductLists({
    required this.error,
    required this.message,
    required this.data,
    required this.code,
    required this.query,
  });

  factory AllProductLists.fromJson(Map<String, dynamic> json) => AllProductLists(
    error: json["error"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    code: json["code"],
    query: List<dynamic>.from(json["query"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "code": code,
    "query": List<dynamic>.from(query.map((x) => x)),
  };
}

class Datum {
  int id;
  String name;
  List<Item> items;

  Datum({
    required this.id,
    required this.name,
    required this.items,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  int id;
  String name;
  String slug;
  String description;
  int price;
  String image;
  dynamic watermarkImage;
  double latitude;
  double longitude;
  String address;
  String contact;
  int showOnlyToPremium;
  String status;
  String rejectedReason;
  dynamic videoLink;
  String city;
  String state;
  String country;
  dynamic areaId;
  int userId;
  int categoryId;
  String allCategoryIds;
  int clicks;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Item({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.watermarkImage,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.contact,
    required this.showOnlyToPremium,
    required this.status,
    required this.rejectedReason,
    required this.videoLink,
    required this.city,
    required this.state,
    required this.country,
    required this.areaId,
    required this.userId,
    required this.categoryId,
    required this.allCategoryIds,
    required this.clicks,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    price: json["price"],
    image: json["image"],
    watermarkImage: json["watermark_image"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    address: json["address"],
    contact: json["contact"],
    showOnlyToPremium: json["show_only_to_premium"],
    status: json["status"],
    rejectedReason: json["rejected_reason"],
    videoLink: json["video_link"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    areaId: json["area_id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    allCategoryIds: json["all_category_ids"],
    clicks: json["clicks"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "price": price,
    "image": image,
    "watermark_image": watermarkImage,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "contact": contact,
    "show_only_to_premium": showOnlyToPremium,
    "status": status,
    "rejected_reason": rejectedReason,
    "video_link": videoLink,
    "city": city,
    "state": state,
    "country": country,
    "area_id": areaId,
    "user_id": userId,
    "category_id": categoryId,
    "all_category_ids": allCategoryIds,
    "clicks": clicks,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
