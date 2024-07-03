// // To parse this JSON data, do
// //
// //     final hadithBookDataModel = hadithBookDataModelFromJson(jsonString);
//
import 'dart:convert';

HadithBookDataModel hadithBookDataModelFromJson(String str) => HadithBookDataModel.fromJson(json.decode(str));

String hadithBookDataModelToJson(HadithBookDataModel data) => json.encode(data.toJson());

class HadithBookDataModel {
  Metadata ? metadata;
  List<Hadith> ? hadiths;

  HadithBookDataModel({
      this.metadata,
      this.hadiths,
  });

  factory HadithBookDataModel.fromJson(Map<String, dynamic> json) {
    return HadithBookDataModel(
      metadata: Metadata.fromJson(json["metadata"]),
      hadiths: List<Hadith>.from(json["hadiths"].map((x) => Hadith.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "metadata": metadata!.toJson(),
    "hadiths": List<dynamic>.from(hadiths!.map((x) => x.toJson())),
  };
}

class Hadith {
  var hadithnumber;
  var arabicnumber;
  String text;
  List<Grade> grades;
  Reference reference;

  Hadith({
    required this.hadithnumber,
    required this.arabicnumber,
    required this.text,
    required this.grades,
    required this.reference,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) => Hadith(
    hadithnumber: json["hadithnumber"],
    arabicnumber: json["arabicnumber"],
    text: json["text"],
    grades: List<Grade>.from(json["grades"].map((x) => Grade.fromJson(x))),
    reference: Reference.fromJson(json["reference"]),
  );

  Map<String, dynamic> toJson() => {
    "hadithnumber": hadithnumber,
    "arabicnumber": arabicnumber,
    "text": text,
    "grades": List<dynamic>.from(grades.map((x) => x.toJson())),
    "reference": reference.toJson(),
  };
}

class Grade {
  Name name;
  String grade;

  Grade({
    required this.name,
    required this.grade,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    name: nameValues.map[json["name"]]!,
    grade: json["grade"],
  );

  Map<String, dynamic> toJson() => {
    "name": nameValues.reverse[name],
    "grade": grade,
  };
}

enum Name {
  AL_ALBANI,
  MUHAMMAD_MUHYI_AL_DIN_ABDUL_HAMID,
  SHUAIB_AL_ARNAUT,
  ZUBAIR_ALI_ZAI
}

final nameValues = EnumValues({
  "Al-Albani": Name.AL_ALBANI,
  "Muhammad Muhyi Al-Din Abdul Hamid": Name.MUHAMMAD_MUHYI_AL_DIN_ABDUL_HAMID,
  "Shuaib Al Arnaut": Name.SHUAIB_AL_ARNAUT,
  "Zubair Ali Zai": Name.ZUBAIR_ALI_ZAI
});

class Reference {
  var book;
  var hadith;

  Reference({
    required this.book,
    required this.hadith,
  });

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
    book: json["book"],
    hadith: json["hadith"],
  );

  Map<String, dynamic> toJson() => {
    "book": book,
    "hadith": hadith,
  };
}

class Metadata {
  String name;
  Map<String, String> sections;
  Map<String, SectionDetail> sectionDetails;

  Metadata({
    required this.name,
    required this.sections,
    required this.sectionDetails,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    name: json["name"],
    sections: Map.from(json["sections"]).map((k, v) => MapEntry<String, String>(k, v)),
    sectionDetails: Map.from(json["section_details"]).map((k, v) => MapEntry<String, SectionDetail>(k, SectionDetail.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "sections": Map.from(sections).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "section_details": Map.from(sectionDetails).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class SectionDetail {
  var hadithnumberFirst;
  var hadithnumberLast;
  var arabicnumberFirst;
  var arabicnumberLast;

  SectionDetail({
    required this.hadithnumberFirst,
    required this.hadithnumberLast,
    required this.arabicnumberFirst,
    required this.arabicnumberLast,
  });

  factory SectionDetail.fromJson(Map<String, dynamic> json) => SectionDetail(
    hadithnumberFirst: json["hadithnumber_first"],
    hadithnumberLast: json["hadithnumber_last"],
    arabicnumberFirst: json["arabicnumber_first"],
    arabicnumberLast: json["arabicnumber_last"],
  );

  Map<String, dynamic> toJson() => {
    "hadithnumber_first": hadithnumberFirst,
    "hadithnumber_last": hadithnumberLast,
    "arabicnumber_first": arabicnumberFirst,
    "arabicnumber_last": arabicnumberLast,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

/////////

// To parse this JSON data, do
//
//     final hadithBookDataModel = hadithBookDataModelFromJson(jsonString);

// import 'dart:convert';
//
// HadithBookDataModel hadithBookDataModelFromJson(String str) => HadithBookDataModel.fromJson(json.decode(str));
//
// String hadithBookDataModelToJson(HadithBookDataModel data) => json.encode(data.toJson());
//
// class HadithBookDataModel {
//   Metadata ? metadata;
//   List<Hadith> ? hadiths;
//
//   HadithBookDataModel({
//      this.metadata,
//      this.hadiths,
//   });
//
//   factory HadithBookDataModel.fromJson(Map<String, dynamic> json) => HadithBookDataModel(
//     metadata: Metadata.fromJson(json["metadata"]),
//     hadiths: List<Hadith>.from(json["hadiths"].map((x) => Hadith.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "metadata": metadata?.toJson(),
//     "hadiths": List<dynamic>.from(hadiths!.map((x) => x.toJson())),
//   };
// }
//
// class Hadith {
//   double hadithnumber;
//   double arabicnumber;
//   String text;
//   List<GradeElement> grades;
//   Reference reference;
//
//   Hadith({
//     required this.hadithnumber,
//     required this.arabicnumber,
//     required this.text,
//     required this.grades,
//     required this.reference,
//   });
//
//   factory Hadith.fromJson(Map<String, dynamic> json) => Hadith(
//     hadithnumber: json["hadithnumber"]?.toDouble(),
//     arabicnumber: json["arabicnumber"]?.toDouble(),
//     text: json["text"],
//     grades: List<GradeElement>.from(json["grades"].map((x) => GradeElement.fromJson(x))),
//     reference: Reference.fromJson(json["reference"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "hadithnumber": hadithnumber,
//     "arabicnumber": arabicnumber,
//     "text": text,
//     "grades": List<dynamic>.from(grades.map((x) => x.toJson())),
//     "reference": reference.toJson(),
//   };
// }
//
// class GradeElement {
//   Name name;
//   GradeEnum grade;
//
//   GradeElement({
//     required this.name,
//     required this.grade,
//   });
//
//   factory GradeElement.fromJson(Map<String, dynamic> json) => GradeElement(
//     name: nameValues.map[json["name"]]!,
//     grade: gradeEnumValues.map[json["grade"]]!,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": nameValues.reverse[name],
//     "grade": gradeEnumValues.reverse[grade],
//   };
// }
//
// enum GradeEnum {
//   BATIL,
//   DAIF,
//   DAIF_ISNAAD,
//   DAIF_MUNKAR,
//   HASAN,
//   HASAN_ISNAAD,
//   HASAN_LIGHAIRIHI,
//   HASAN_SAHIH,
//   ISNAAD_HASAN,
//   ISNAAD_MALOOL,
//   ISNAAD_SAHIH,
//   ISNAAD_SAHIH_AGREED_UPON,
//   ISNAAD_SAHIH_SAHIH_BUKHARI,
//   ISNAAD_SAHIH_SAHIH_MUSLIM,
//   MAWDU,
//   MUNKAR,
//   MUNKAR_DAIF,
//   MURSAL,
//   SAHIH,
//   SAHIH_AGREED_UPON,
//   SAHIH_BUKHARI,
//   SAHIH_BUKHARI_AND_MUSLIM,
//   SAHIH_HADITH,
//   SAHIH_ISNAAD,
//   SAHIH_ISNAAD_HASAN_BUKHARI_AND_MUSLIM,
//   SAHIH_LIGHAIRIHI,
//   SAHIH_MATN,
//   SAHIH_MUQUF,
//   SAHIH_MUSLIM,
//   SAHIH_MUTAWATIR,
//   SANAD_DAIF,
//   SHADH,
//   VERY_DAIF,
//   VERY_DAIF_ISNAAD
// }
//
// final gradeEnumValues = EnumValues({
//   "Batil": GradeEnum.BATIL,
//   "Daif": GradeEnum.DAIF,
//   "Daif Isnaad": GradeEnum.DAIF_ISNAAD,
//   "Daif Munkar": GradeEnum.DAIF_MUNKAR,
//   "Hasan": GradeEnum.HASAN,
//   "Hasan Isnaad": GradeEnum.HASAN_ISNAAD,
//   "Hasan Lighairihi": GradeEnum.HASAN_LIGHAIRIHI,
//   "Hasan Sahih": GradeEnum.HASAN_SAHIH,
//   "Isnaad Hasan": GradeEnum.ISNAAD_HASAN,
//   "Isnaad Malool": GradeEnum.ISNAAD_MALOOL,
//   "Isnaad Sahih": GradeEnum.ISNAAD_SAHIH,
//   "Isnaad Sahih Agreed Upon": GradeEnum.ISNAAD_SAHIH_AGREED_UPON,
//   "Isnaad Sahih Sahih Bukhari": GradeEnum.ISNAAD_SAHIH_SAHIH_BUKHARI,
//   "Isnaad Sahih Sahih Muslim": GradeEnum.ISNAAD_SAHIH_SAHIH_MUSLIM,
//   "Mawdu": GradeEnum.MAWDU,
//   "Munkar": GradeEnum.MUNKAR,
//   "Munkar Daif": GradeEnum.MUNKAR_DAIF,
//   "Mursal": GradeEnum.MURSAL,
//   "Sahih": GradeEnum.SAHIH,
//   "Sahih - Agreed Upon": GradeEnum.SAHIH_AGREED_UPON,
//   "Sahih Bukhari": GradeEnum.SAHIH_BUKHARI,
//   "Sahih - Bukhari And Muslim": GradeEnum.SAHIH_BUKHARI_AND_MUSLIM,
//   "Sahih Hadith": GradeEnum.SAHIH_HADITH,
//   "Sahih Isnaad": GradeEnum.SAHIH_ISNAAD,
//   "Sahih - Isnaad Hasan Bukhari And Muslim": GradeEnum.SAHIH_ISNAAD_HASAN_BUKHARI_AND_MUSLIM,
//   "Sahih Lighairihi": GradeEnum.SAHIH_LIGHAIRIHI,
//   "Sahih Matn": GradeEnum.SAHIH_MATN,
//   "Sahih Muquf": GradeEnum.SAHIH_MUQUF,
//   "Sahih Muslim": GradeEnum.SAHIH_MUSLIM,
//   "Sahih Mutawatir": GradeEnum.SAHIH_MUTAWATIR,
//   "Sanad Daif": GradeEnum.SANAD_DAIF,
//   "Shadh": GradeEnum.SHADH,
//   "Very Daif": GradeEnum.VERY_DAIF,
//   "Very Daif Isnaad": GradeEnum.VERY_DAIF_ISNAAD
// });
//
// enum Name {
//   AL_ALBANI,
//   MUHAMMAD_FOUAD_ABD_AL_BAQI,
//   SHUAIB_AL_ARNAUT,
//   ZUBAIR_ALI_ZAI
// }
//
// final nameValues = EnumValues({
//   "Al-Albani": Name.AL_ALBANI,
//   "Muhammad Fouad Abd al-Baqi": Name.MUHAMMAD_FOUAD_ABD_AL_BAQI,
//   "Shuaib Al Arnaut": Name.SHUAIB_AL_ARNAUT,
//   "Zubair Ali Zai": Name.ZUBAIR_ALI_ZAI
// });
//
// class Reference {
//   int book;
//   int hadith;
//
//   Reference({
//     required this.book,
//     required this.hadith,
//   });
//
//   factory Reference.fromJson(Map<String, dynamic> json) => Reference(
//     book: json["book"],
//     hadith: json["hadith"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "book": book,
//     "hadith": hadith,
//   };
// }
//
// class Metadata {
//   String name;
//   Map<String, String> sections;
//   Map<String, SectionDetail> sectionDetails;
//
//   Metadata({
//     required this.name,
//     required this.sections,
//     required this.sectionDetails,
//   });
//
//   factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
//     name: json["name"],
//     sections: Map.from(json["sections"]).map((k, v) => MapEntry<String, String>(k, v)),
//     sectionDetails: Map.from(json["section_details"]).map((k, v) => MapEntry<String, SectionDetail>(k, SectionDetail.fromJson(v))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "sections": Map.from(sections).map((k, v) => MapEntry<String, dynamic>(k, v)),
//     "section_details": Map.from(sectionDetails).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//   };
// }
//
// class SectionDetail {
//   int hadithnumberFirst;
//   int hadithnumberLast;
//   int arabicnumberFirst;
//   int arabicnumberLast;
//
//   SectionDetail({
//     required this.hadithnumberFirst,
//     required this.hadithnumberLast,
//     required this.arabicnumberFirst,
//     required this.arabicnumberLast,
//   });
//
//   factory SectionDetail.fromJson(Map<String, dynamic> json) => SectionDetail(
//     hadithnumberFirst: json["hadithnumber_first"],
//     hadithnumberLast: json["hadithnumber_last"],
//     arabicnumberFirst: json["arabicnumber_first"],
//     arabicnumberLast: json["arabicnumber_last"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "hadithnumber_first": hadithnumberFirst,
//     "hadithnumber_last": hadithnumberLast,
//     "arabicnumber_first": arabicnumberFirst,
//     "arabicnumber_last": arabicnumberLast,
//   };
// }
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

