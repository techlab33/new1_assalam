class FamousHadithDataModel {
  String? message;
  List<Hadise>? hadises;

  FamousHadithDataModel({
    this.message,
    this.hadises,
  });

  factory FamousHadithDataModel.fromJson(Map<String, dynamic> json) => FamousHadithDataModel(
    message: json["message"],
    hadises: json["hadises"] != null
        ? List<Hadise>.from(json["hadises"].map((x) => Hadise.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "hadises": hadises != null
        ? List<dynamic>.from(hadises!.map((x) => x.toJson()))
        : null,
  };
}

class Hadise {
  int id;
  String hadis;
  String hadisTranslate;
  String hadisDescription;
  String reference;
  String audioLink;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  bool isChecked;
  String note;

  Hadise({
    required this.id,
    required this.hadis,
    required this.hadisTranslate,
    required this.hadisDescription,
    required this.reference,
    required this.audioLink,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.isChecked,
    required this.note,
  });

  factory Hadise.fromJson(Map<String, dynamic> json) => Hadise(
    id: json["id"],
    hadis: json["hadis"] ?? "",
    hadisTranslate: json["hadis_translate"] ?? "",
    hadisDescription: json["hadis_description"] ?? "",
    reference: json["reference"] ?? "",
    audioLink: json["audio_link"] ?? "",
    status: json["status"] ?? "",
    createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
    isFavorite: json["is_favorite"] is bool ? json["is_favorite"] : json["is_favorite"] == "true",
    isChecked: json["is_checked"] is bool ? json["is_checked"] : json["is_checked"] == "true",
    note: json["note"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "hadis": hadis,
    "hadis_translate": hadisTranslate,
    "hadis_description": hadisDescription,
    "reference": reference,
    "audio_link": audioLink,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_favorite": isFavorite,
    "is_checked": isChecked,
    "note": note,
  };
}
