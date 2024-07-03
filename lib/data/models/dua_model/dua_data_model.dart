//
// import 'dart:convert';
//
// DuaDataModel duaDataModelFromJson(String str) => DuaDataModel.fromJson(json.decode(str));
//
// String duaDataModelToJson(DuaDataModel data) => json.encode(data.toJson());
//
// class DuaDataModel {
//   String ? message;
//   List<AllCategory> ? allCategories;
//
//   DuaDataModel({
//      this.message,
//      this.allCategories,
//   });
//
//   factory DuaDataModel.fromJson(Map<String, dynamic> json) => DuaDataModel(
//     message: json["message"],
//     allCategories: List<AllCategory>.from(json["All Categories"].map((x) => AllCategory.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "All Categories": List<dynamic>.from(allCategories!.map((x) => x.toJson())),
//   };
// }
//
// class AllCategory {
//   int id;
//   String categoryName;
//   dynamic image;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int totalSubCategories;
//   List<SubCategory> subCategories;
//
//   AllCategory({
//     required this.id,
//     required this.categoryName,
//     required this.image,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.totalSubCategories,
//     required this.subCategories,
//   });
//
//   factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
//     id: json["id"],
//     categoryName: json["category_name"],
//     image: json["image"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     totalSubCategories: json["total_sub_categories"],
//     subCategories: List<SubCategory>.from(json["sub_categories"].map((x) => SubCategory.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "category_name": categoryName,
//     "image": image,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "total_sub_categories": totalSubCategories,
//     "sub_categories": List<dynamic>.from(subCategories.map((x) => x.toJson())),
//   };
// }
//
// class SubCategory {
//   int id;
//   String categoryId;
//   String subCategoryName;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<Doa> doas;
//
//   SubCategory({
//     required this.id,
//     required this.categoryId,
//     required this.subCategoryName,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.doas,
//   });
//
//   factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
//     id: json["id"],
//     categoryId: json["category_id"],
//     subCategoryName: json["sub_category_name"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     doas: List<Doa>.from(json["doas"].map((x) => Doa.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "category_id": categoryId,
//     "sub_category_name": subCategoryName,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "doas": List<dynamic>.from(doas.map((x) => x.toJson())),
//   };
// }
//
// class Doa {
//   int id;
//   String doaSubCategoryId;
//   String doa;
//   String doaTranslate;
//   String doaDescription;
//   Reference reference;
//   String audioLink;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String isFavorite;
//   String isChecked;
//   Note note;
//
//   Doa({
//     required this.id,
//     required this.doaSubCategoryId,
//     required this.doa,
//     required this.doaTranslate,
//     required this.doaDescription,
//     required this.reference,
//     required this.audioLink,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.isFavorite,
//     required this.isChecked,
//     required this.note,
//   });
//
//   factory Doa.fromJson(Map<String, dynamic> json) => Doa(
//     id: json["id"],
//     doaSubCategoryId: json["doa_sub_category_id"],
//     doa: json["doa"],
//     doaTranslate: json["doa_translate"],
//     doaDescription: json["doa_description"],
//     reference: referenceValues.map[json["reference"]]!,
//     audioLink: json["audio_link"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     isFavorite: json["is_favorite"],
//     isChecked: json["is_checked"],
//     note: noteValues.map[json["note"]]!,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "doa_sub_category_id": doaSubCategoryId,
//     "doa": doa,
//     "doa_translate": doaTranslate,
//     "doa_description": doaDescription,
//     "reference": referenceValues.reverse[reference],
//     "audio_link": audioLink,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "is_favorite": isFavorite,
//     "is_checked": isChecked,
//     "note": noteValues.reverse[note],
//   };
// }
//
// enum Note {
//   EMPTY,
//   THIS_DOA_NEEDS_TO_BE_REVISITED,
//   THIS_IS_A_CHECKED_DOA,
//   THIS_IS_A_FAVORITE_DOA
// }
//
// final noteValues = EnumValues({
//   "": Note.EMPTY,
//   "This doa needs to be revisited.": Note.THIS_DOA_NEEDS_TO_BE_REVISITED,
//   "This is a checked doa.": Note.THIS_IS_A_CHECKED_DOA,
//   "This is a favorite doa.": Note.THIS_IS_A_FAVORITE_DOA
// });
//
// enum Reference {
//   THE_316,
//   THE_3193,
//   THE_3194,
//   THE_39,
//   THE_5114
// }
//
// final referenceValues = EnumValues({
//   "– 3:16 –": Reference.THE_316,
//   "– 3:193 –\n\n            ": Reference.THE_3193,
//   "– 3:194 –\n\n            ": Reference.THE_3194,
//   "– 3:9 –\n\n            ": Reference.THE_39,
//   "– 5:114 –\n\n            ": Reference.THE_5114
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }


//
//
// import 'dart:convert';
//
// DuaDataModel duaDataModelFromJson(String str) => DuaDataModel.fromJson(json.decode(str));
//
// String duaDataModelToJson(DuaDataModel data) => json.encode(data.toJson());
//
// class DuaDataModel {
//   String ? message;
//   List<AllCategory> ? allCategories;
//
//   DuaDataModel({
//     this.message,
//      this.allCategories,
//   });
//
//   factory DuaDataModel.fromJson(Map<String, dynamic> json) => DuaDataModel(
//     message: json["message"],
//     allCategories: List<AllCategory>.from(json["All Categories"].map((x) => AllCategory.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "All Categories": List<dynamic>.from(allCategories!.map((x) => x.toJson())),
//   };
// }
//
// class AllCategory {
//   int id;
//   String categoryName;
//   String? image;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int totalSubCategories;
//   List<SubCategory> subCategories;
//
//   AllCategory({
//     required this.id,
//     required this.categoryName,
//     required this.image,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.totalSubCategories,
//     required this.subCategories,
//   });
//
//   factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
//     id: json["id"],
//     categoryName: json["category_name"],
//     image: json["image"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     totalSubCategories: json["total_sub_categories"],
//     subCategories: List<SubCategory>.from(json["sub_categories"].map((x) => SubCategory.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "category_name": categoryName,
//     "image": image,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "total_sub_categories": totalSubCategories,
//     "sub_categories": List<dynamic>.from(subCategories.map((x) => x.toJson())),
//   };
// }
//
// class SubCategory {
//   int id;
//   String categoryId;
//   String subCategoryName;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<Doa> doas;
//
//   SubCategory({
//     required this.id,
//     required this.categoryId,
//     required this.subCategoryName,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.doas,
//   });
//
//   factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
//     id: json["id"],
//     categoryId: json["category_id"],
//     subCategoryName: json["sub_category_name"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     doas: List<Doa>.from(json["doas"].map((x) => Doa.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "category_id": categoryId,
//     "sub_category_name": subCategoryName,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "doas": List<dynamic>.from(doas.map((x) => x.toJson())),
//   };
// }
//
// class Doa {
//   int id;
//   String doaSubCategoryId;
//   String doa;
//   String doaTranslate;
//   String doaDescription;
//   String reference;
//   String? audioLink;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   bool isFavorite;
//   bool isChecked;
//   dynamic note;
//
//   Doa({
//     required this.id,
//     required this.doaSubCategoryId,
//     required this.doa,
//     required this.doaTranslate,
//     required this.doaDescription,
//     required this.reference,
//     required this.audioLink,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.isFavorite,
//     required this.isChecked,
//     required this.note,
//   });
//
//   factory Doa.fromJson(Map<String, dynamic> json) => Doa(
//     id: json["id"],
//     doaSubCategoryId: json["doa_sub_category_id"],
//     doa: json["doa"],
//     doaTranslate: json["doa_translate"],
//     doaDescription: json["doa_description"],
//     reference: json["reference"],
//     audioLink: json["audio_link"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     isFavorite: json["is_favorite"],
//     isChecked: json["is_checked"],
//     note: json["note"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "doa_sub_category_id": doaSubCategoryId,
//     "doa": doa,
//     "doa_translate": doaTranslate,
//     "doa_description": doaDescription,
//     "reference": reference,
//     "audio_link": audioLink,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "is_favorite": isFavorite,
//     "is_checked": isChecked,
//     "note": note,
//   };
// }



// To parse this JSON data, do
//
//     final duaDataModel = duaDataModelFromJson(jsonString);

import 'dart:convert';

DuaDataModel duaDataModelFromJson(String str) => DuaDataModel.fromJson(json.decode(str));

String duaDataModelToJson(DuaDataModel data) => json.encode(data.toJson());

class DuaDataModel {
  String? message;
  List<AllCategory>? allCategories;

  DuaDataModel({
    this.message,
    this.allCategories,
  });

  factory DuaDataModel.fromJson(Map<String, dynamic> json) {
    return DuaDataModel(
      message: json["message"],
      allCategories: (json["All Categories"] as List<dynamic>?)
          ?.map((categoryJson) => AllCategory.fromJson(categoryJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "All Categories": allCategories?.map((category) => category.toJson()).toList(),
  };
}

class AllCategory {
  int id;
  String categoryName;
  dynamic image;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int totalSubCategories;
  List<SubCategory> subCategories;

  AllCategory({
    required this.id,
    required this.categoryName,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.totalSubCategories,
    required this.subCategories,
  });

  factory AllCategory.fromJson(Map<String, dynamic> json) {
    return AllCategory(
      id: json["id"],
      categoryName: json["category_name"],
      image: json["image"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      totalSubCategories: json["total_sub_categories"],
      subCategories: (json["sub_categories"] as List<dynamic>?)
          !.map((subCategoryJson) => SubCategory.fromJson(subCategoryJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_name": categoryName,
    "image": image,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "total_sub_categories": totalSubCategories,
    "sub_categories": subCategories.map((subCategory) => subCategory.toJson()).toList(),
  };
}

class SubCategory {
  int id;
  String categoryId;
  String subCategoryName;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  List<Doa> doas;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.subCategoryName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.doas,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json["id"],
      categoryId: json["category_id"],
      subCategoryName: json["sub_category_name"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      doas: (json["doas"] as List<dynamic>?)
          !.map((doaJson) => Doa.fromJson(doaJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "sub_category_name": subCategoryName,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "doas": doas.map((doa) => doa.toJson()).toList(),
  };
}

class Doa {
  int id;
  String doaSubCategoryId;
  String doa;
  String doaTranslate;
  String doaDescription;
  Reference reference;
  String audioLink;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic isFavorite;
  dynamic isChecked;
  dynamic note;

  Doa({
    required this.id,
    required this.doaSubCategoryId,
    required this.doa,
    required this.doaTranslate,
    required this.doaDescription,
    required this.reference,
    required this.audioLink,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.isChecked,
    required this.note,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json["id"],
      doaSubCategoryId: json["doa_sub_category_id"],
      doa: json["doa"],
      doaTranslate: json["doa_translate"],
      doaDescription: json["doa_description"],
      reference: referenceValues.map[json["reference"]]!,
      audioLink: json["audio_link"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      isFavorite: json["is_favorite"],
      isChecked: json["is_checked"],
      note: json["note"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "doa_sub_category_id": doaSubCategoryId,
    "doa": doa,
    "doa_translate": doaTranslate,
    "doa_description": doaDescription,
    "reference": referenceValues.reverse[reference],
    "audio_link": audioLink,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_favorite": isFavorite,
    "is_checked": isChecked,
    "note": note,
  };
}

enum Reference {
  THE_316,
  THE_3193,
  THE_3194,
  THE_39,
  THE_5114
}

final referenceValues = EnumValues({
  "– 3:16 –": Reference.THE_316,
  "– 3:193 –\n\n            ": Reference.THE_3193,
  "– 3:194 –\n\n            ": Reference.THE_3194,
  "– 3:9 –\n\n            ": Reference.THE_39,
  "– 5:114 –\n\n            ": Reference.THE_5114
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// Now the model is adjusted to handle potential null values for properties.


