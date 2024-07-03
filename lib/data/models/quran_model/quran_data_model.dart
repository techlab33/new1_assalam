// // To parse this JSON data, do
// //
// //     final quranDataModel = quranDataModelFromJson(jsonString);
//
// import 'dart:convert';
//
// QuranDataModel quranDataModelFromJson(String str) => QuranDataModel.fromJson(json.decode(str));
//
// String quranDataModelToJson(QuranDataModel data) => json.encode(data.toJson());
//
// class QuranDataModel {
//   Data ? data;
//
//   QuranDataModel({
//     this.data,
//   });
//
//   factory QuranDataModel.fromJson(Map<String, dynamic> json) => QuranDataModel(
//     data: Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data!.toJson(),
//   };
// }
//
// class Data {
//   List<Surah> surahs;
//
//   Data({
//     required this.surahs,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     surahs: List<Surah>.from(json["surahs"].map((x) => Surah.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "surahs": List<dynamic>.from(surahs.map((x) => x.toJson())),
//   };
// }
//
// class Surah {
//   int number;
//   String name;
//   String englishName;
//   String englishNameTranslation;
//   RevelationType revelationType;
//   List<Ayah> ayahs;
//
//   Surah({
//     required this.number,
//     required this.name,
//     required this.englishName,
//     required this.englishNameTranslation,
//     required this.revelationType,
//     required this.ayahs,
//   });
//
//   factory Surah.fromJson(Map<String, dynamic> json) => Surah(
//     number: json["number"],
//     name: json["name"],
//     englishName: json["englishName"],
//     englishNameTranslation: json["englishNameTranslation"],
//     revelationType: revelationTypeValues.map[json["revelationType"]]!,
//     ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "number": number,
//     "name": name,
//     "englishName": englishName,
//     "englishNameTranslation": englishNameTranslation,
//     "revelationType": revelationTypeValues.reverse[revelationType],
//     "ayahs": List<dynamic>.from(ayahs.map((x) => x.toJson())),
//   };
// }
//
// class Ayah {
//   int number;
//   String text;
//   String englishTexTranslation;
//   String audio;
//   List<String> audioSecondary;
//   int numberInSurah;
//   int juz;
//   int manzil;
//   int page;
//   int ruku;
//   int hizbQuarter;
//   dynamic sajda;
//
//   Ayah({
//     required this.number,
//     required this.text,
//     required this.englishTexTranslation,
//     required this.audio,
//     required this.audioSecondary,
//     required this.numberInSurah,
//     required this.juz,
//     required this.manzil,
//     required this.page,
//     required this.ruku,
//     required this.hizbQuarter,
//     required this.sajda,
//   });
//
//   factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
//     number: json["number"],
//     text: json["text"],
//     englishTexTranslation: json["englishTexTranslation"],
//     audio: json["audio"],
//     audioSecondary: List<String>.from(json["audioSecondary"].map((x) => x)),
//     numberInSurah: json["numberInSurah"],
//     juz: json["juz"],
//     manzil: json["manzil"],
//     page: json["page"],
//     ruku: json["ruku"],
//     hizbQuarter: json["hizbQuarter"],
//     sajda: json["sajda"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "number": number,
//     "text": text,
//     "englishTexTranslation": englishTexTranslation,
//     "audio": audio,
//     "audioSecondary": List<dynamic>.from(audioSecondary.map((x) => x)),
//     "numberInSurah": numberInSurah,
//     "juz": juz,
//     "manzil": manzil,
//     "page": page,
//     "ruku": ruku,
//     "hizbQuarter": hizbQuarter,
//     "sajda": sajda,
//   };
// }
//
// class SajdaClass {
//   int id;
//   bool recommended;
//   bool obligatory;
//
//   SajdaClass({
//     required this.id,
//     required this.recommended,
//     required this.obligatory,
//   });
//
//   factory SajdaClass.fromJson(Map<String, dynamic> json) => SajdaClass(
//     id: json["id"],
//     recommended: json["recommended"],
//     obligatory: json["obligatory"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "recommended": recommended,
//     "obligatory": obligatory,
//   };
// }
//
// enum RevelationType {
//   MECCAN,
//   MEDINAN
// }
//
// final revelationTypeValues = EnumValues({
//   "Meccan": RevelationType.MECCAN,
//   "Medinan": RevelationType.MEDINAN
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



// To parse this JSON data, do
//
//     final quranDataModel = quranDataModelFromJson(jsonString);

import 'dart:convert';

QuranDataModel quranDataModelFromJson(String str) => QuranDataModel.fromJson(json.decode(str));

String quranDataModelToJson(QuranDataModel data) => json.encode(data.toJson());

class QuranDataModel {
  Data ? data;

  QuranDataModel({
     this.data,
  });

  factory QuranDataModel.fromJson(Map<String, dynamic> json) => QuranDataModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  List<Surah> surahs;

  Data({
    required this.surahs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    surahs: List<Surah>.from(json["surahs"].map((x) => Surah.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "surahs": List<dynamic>.from(surahs.map((x) => x.toJson())),
  };
}

class Surah {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  RevelationType revelationType;
  List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
    number: json["number"],
    name: json["name"],
    englishName: json["englishName"],
    englishNameTranslation: json["englishNameTranslation"],
    revelationType: revelationTypeValues.map[json["revelationType"]]!,
    ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "name": name,
    "englishName": englishName,
    "englishNameTranslation": englishNameTranslation,
    "revelationType": revelationTypeValues.reverse[revelationType],
    "ayahs": List<dynamic>.from(ayahs.map((x) => x.toJson())),
  };
}

class Ayah {
  int number;
  String text;
  String englishTexTranslation;
  String audio;
  List<String> audioSecondary;
  int numberInSurah;
  int juz;
  int manzil;
  int page;
  int ruku;
  int hizbQuarter;
  dynamic sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.englishTexTranslation,
    required this.audio,
    required this.audioSecondary,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
    number: json["number"],
    text: json["text"],
    englishTexTranslation: json["englishTexTranslation"],
    audio: json["audio"],
    audioSecondary: List<String>.from(json["audioSecondary"].map((x) => x)),
    numberInSurah: json["numberInSurah"],
    juz: json["juz"],
    manzil: json["manzil"],
    page: json["page"],
    ruku: json["ruku"],
    hizbQuarter: json["hizbQuarter"],
    sajda: json["sajda"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "text": text,
    "englishTexTranslation": englishTexTranslation,
    "audio": audio,
    "audioSecondary": List<dynamic>.from(audioSecondary.map((x) => x)),
    "numberInSurah": numberInSurah,
    "juz": juz,
    "manzil": manzil,
    "page": page,
    "ruku": ruku,
    "hizbQuarter": hizbQuarter,
    "sajda": sajda,
  };
}

class SajdaClass {
  int id;
  bool recommended;
  bool obligatory;

  SajdaClass({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });

  factory SajdaClass.fromJson(Map<String, dynamic> json) => SajdaClass(
    id: json["id"],
    recommended: json["recommended"],
    obligatory: json["obligatory"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "recommended": recommended,
    "obligatory": obligatory,
  };
}

enum RevelationType {
  MECCAN,
  MEDINAN
}

final revelationTypeValues = EnumValues({
  "Meccan": RevelationType.MECCAN,
  "Medinan": RevelationType.MEDINAN
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
