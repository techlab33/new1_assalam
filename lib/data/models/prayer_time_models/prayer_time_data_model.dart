

import 'dart:convert';

PrayerTimeDataModel prayerTimeDataModelFromJson(String str) => PrayerTimeDataModel.fromJson(json.decode(str));

String prayerTimeDataModelToJson(PrayerTimeDataModel data) => json.encode(data.toJson());

class PrayerTimeDataModel {
  Data ? data;
  String ? status;
  int ? code;

  PrayerTimeDataModel({
     this.data,
     this.status,
     this.code,
  });

  factory PrayerTimeDataModel.fromJson(Map<String, dynamic> json) => PrayerTimeDataModel(
    data: Data.fromJson(json["data"]),
    status: json["status"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
    "status": status,
    "code": code,
  };
}

class Data {
  Timings timings;

  Data({
    required this.timings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    timings: Timings.fromJson(json["timings"]),
  );

  Map<String, dynamic> toJson() => {
    "timings": timings.toJson(),
  };
}

class Timings {
  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String sunset;
  String maghrib;
  String isha;
  String imsak;
  String midnight;
  String firstthird;
  String lastthird;
  String dhuha;

  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstthird,
    required this.lastthird,
    required this.dhuha,
  });

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
    fajr: json["Fajr"],
    sunrise: json["Sunrise"],
    dhuhr: json["Dhuhr"],
    asr: json["Asr"],
    sunset: json["Sunset"],
    maghrib: json["Maghrib"],
    isha: json["Isha"],
    imsak: json["Imsak"],
    midnight: json["Midnight"],
    firstthird: json["Firstthird"],
    lastthird: json["Lastthird"],
    dhuha: json["Dhuha"],
  );

  Map<String, dynamic> toJson() => {
    "Fajr": fajr,
    "Sunrise": sunrise,
    "Dhuhr": dhuhr,
    "Asr": asr,
    "Sunset": sunset,
    "Maghrib": maghrib,
    "Isha": isha,
    "Imsak": imsak,
    "Midnight": midnight,
    "Firstthird": firstthird,
    "Lastthird": lastthird,
    "Dhuha": dhuha,
  };
}
