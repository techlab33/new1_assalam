//
//
// import 'dart:convert';
//
// AllHadithDataModel allHadithDataModelFromJson(String str) => AllHadithDataModel.fromJson(json.decode(str));
//
// String allHadithDataModelToJson(AllHadithDataModel data) => json.encode(data.toJson());
//
// class AllHadithDataModel {
//   String ? message;
//   List<Book> ? books;
//
//   AllHadithDataModel({
//      this.message,
//      this.books,
//   });
//
//   factory AllHadithDataModel.fromJson(Map<String, dynamic> json) => AllHadithDataModel(
//     message: json["message"],
//     books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "books": List<dynamic>.from(books!.map((x) => x.toJson())),
//   };
// }
//
// class Book {
//   int id;
//   String hadisName;
//   String fileApi;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   Book({
//     required this.id,
//     required this.hadisName,
//     required this.fileApi,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Book.fromJson(Map<String, dynamic> json) => Book(
//     id: json["id"],
//     hadisName: json["hadis_name"],
//     fileApi: json["file_api"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "hadis_name": hadisName,
//     "file_api": fileApi,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//   };
// }


// To parse this JSON data, do
//
//     final allHadithDataModel = allHadithDataModelFromJson(jsonString);

import 'dart:convert';

AllHadithDataModel allHadithDataModelFromJson(String str) => AllHadithDataModel.fromJson(json.decode(str));

String allHadithDataModelToJson(AllHadithDataModel data) => json.encode(data.toJson());

class AllHadithDataModel {
  String ? message;
  List<Book> ? books;

  AllHadithDataModel({
     this.message,
     this.books,
  });

  factory AllHadithDataModel.fromJson(Map<String, dynamic> json) => AllHadithDataModel(
    message: json["message"],
    books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "books": List<dynamic>.from(books!.map((x) => x.toJson())),
  };
}

class Book {
  int id;
  String hadisName;
  String fileApi;
  String status;
  dynamic createdAt;
  dynamic updatedAt;

  Book({
    required this.id,
    required this.hadisName,
    required this.fileApi,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    hadisName: json["hadis_name"],
    fileApi: json["file_api"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "hadis_name": hadisName,
    "file_api": fileApi,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

