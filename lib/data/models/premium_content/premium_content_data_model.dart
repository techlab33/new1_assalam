// // To parse this JSON data, do
// //
// //     final premiumContentDataModel = premiumContentDataModelFromJson(jsonString);
//
// import 'dart:convert';
//
// PremiumContentDataModel premiumContentDataModelFromJson(String str) => PremiumContentDataModel.fromJson(json.decode(str));
//
// String premiumContentDataModelToJson(PremiumContentDataModel data) => json.encode(data.toJson());
//
// class PremiumContentDataModel {
//   List<AllCategory> ? allCategories;
//
//   PremiumContentDataModel({
//      this.allCategories,
//   });
//
//   factory PremiumContentDataModel.fromJson(Map<String, dynamic> json) => PremiumContentDataModel(
//     allCategories: List<AllCategory>.from(json["allCategories"].map((x) => AllCategory.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "allCategories": List<dynamic>.from(allCategories!.map((x) => x.toJson())),
//   };
// }
//
// class AllCategory {
//   int ? categoryId;
//   String ? categoryName;
//   String ? status;
//   List<Subcategory> ? subcategories;
//
//   AllCategory({
//     this.categoryId,
//     this.categoryName,
//     this.status,
//     this.subcategories,
//   });
//
//   factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
//     categoryId: json["category_id"],
//     categoryName: json["category_name"],
//     status: json["status"],
//     subcategories: List<Subcategory>.from(json["subcategories"].map((x) => Subcategory.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "category_id": categoryId,
//     "category_name": categoryName,
//     "status": status,
//     "subcategories": List<dynamic>.from(subcategories!.map((x) => x.toJson())),
//   };
// }
//
// class Subcategory {
//   int subcategoryId;
//   String subcategoryName;
//   String status;
//   String image;
//   List<Content> contents;
//
//   Subcategory({
//     required this.subcategoryId,
//     required this.subcategoryName,
//     required this.status,
//     required this.image,
//     required this.contents,
//   });
//
//   factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
//     subcategoryId: json["subcategory_id"],
//     subcategoryName: json["subcategory_name"],
//     status: json["status"],
//     image: json["image"],
//     contents: List<Content>.from(json["contents"].map((x) => Content.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "subcategory_id": subcategoryId,
//     "subcategory_name": subcategoryName,
//     "status": status,
//     "image": image,
//     "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
//   };
// }
//
// class Content {
//   int contentId;
//   String ? name;
//   String? description;
//   String ? mediaType;
//   String ? audioType;
//   dynamic audioFile;
//   String ? audioLink;
//   String ? videoType;
//   String ? videoFile;
//   String ? videoLink;
//   String ? status;
//   dynamic image;
//
//   Content({
//     required this.contentId,
//     this.name,
//      this.description,
//      this.mediaType,
//      this.audioType,
//     required this.audioFile,
//      this.audioLink,
//      this.videoType,
//      this.videoFile,
//      this.videoLink,
//      this.status,
//     required this.image,
//   });
//
//   factory Content.fromJson(Map<String, dynamic> json) => Content(
//     contentId: json["content_id"],
//     name: json["name"],
//     description: json["description"],
//     mediaType: json["media_type"],
//     audioType: json["audio_type"],
//     audioFile: json["audio_file"],
//     audioLink: json["audio_link"],
//     videoType: json["video_type"],
//     videoFile: json["video_file"],
//     videoLink: json["video_link"],
//     status: json["status"],
//     image: json["image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "content_id": contentId,
//     "name": name,
//     "description": description,
//     "media_type": mediaType,
//     "audio_type": audioType,
//     "audio_file": audioFile,
//     "audio_link": audioLink,
//     "video_type": videoType,
//     "video_file": videoFile,
//     "video_link": videoLink,
//     "status": status,
//     "image": image,
//   };
// }


// To parse this JSON data, do
//
//     final premiumContentDataModel = premiumContentDataModelFromJson(jsonString);

import 'dart:convert';

PremiumContentDataModel premiumContentDataModelFromJson(String str) => PremiumContentDataModel.fromJson(json.decode(str));

String premiumContentDataModelToJson(PremiumContentDataModel data) => json.encode(data.toJson());

class PremiumContentDataModel {
  List<AllCategory> ? allCategories;

  PremiumContentDataModel({
    this.allCategories,
  });

  factory PremiumContentDataModel.fromJson(Map<String, dynamic> json) => PremiumContentDataModel(
    allCategories: List<AllCategory>.from(json["allCategories"].map((x) => AllCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "allCategories": List<dynamic>.from(allCategories!.map((x) => x.toJson())),
  };
}

class AllCategory {
  int ? categoryId;
  String ? categoryName;
  String ? status;
  List<Subcategory> ? subcategories;

  AllCategory({
    this.categoryId,
    this.categoryName,
    this.status,
    this.subcategories,
  });

  factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    status: json["status"],
    subcategories: List<Subcategory>.from(json["subcategories"].map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
    "status": status,
    "subcategories": List<dynamic>.from(subcategories!.map((x) => x.toJson())),
  };
}

class Subcategory {
  int categoryId;
  int subcategoryId;
  String subcategoryName;
  String status;
  String image;
  List<Content> contents;

  Subcategory({
    required this.categoryId,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.status,
    required this.image,
    required this.contents,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    subcategoryName: json["subcategory_name"],
    status: json["status"],
    image: json["image"],
    contents: List<Content>.from(json["contents"].map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "subcategory_name": subcategoryName,
    "status": status,
    "image": image,
    "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
  };
}

class Content {
  int subcategoryId;
  int contentId;
  String name;
  String? description;
  String mediaType;
  String audioType;
  dynamic audioFile;
  dynamic audioLink;
  String videoType;
  String videoFile;
  String videoLink;
  String status;
  dynamic image;

  Content({
    required this.subcategoryId,
    required this.contentId,
    required this.name,
    required this.description,
    required this.mediaType,
    required this.audioType,
    required this.audioFile,
    required this.audioLink,
    required this.videoType,
    required this.videoFile,
    required this.videoLink,
    required this.status,
    required this.image,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    subcategoryId: json["subcategory_id"],
    contentId: json["content_id"],
    name: json["name"],
    description: json["description"],
    mediaType: json["media_type"],
    audioType: json["audio_type"],
    audioFile: json["audio_file"],
    audioLink: json["audio_link"],
    videoType: json["video_type"],
    videoFile: json["video_file"],
    videoLink: json["video_link"],
    status: json["status"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "subcategory_id": subcategoryId,
    "content_id": contentId,
    "name": name,
    "description": description,
    "media_type": mediaType,
    "audio_type": audioType,
    "audio_file": audioFile,
    "audio_link": audioLink,
    "video_type": videoType,
    "video_file": videoFile,
    "video_link": videoLink,
    "status": status,
    "image": image,
  };
}
