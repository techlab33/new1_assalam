//
// //     final userProfileDataModel = userProfileDataModelFromJson(jsonString);
// import 'dart:convert';
//
// UserProfileDataModel userProfileDataModelFromJson(String str) =>
//     UserProfileDataModel.fromJson(json.decode(str));
//
// String userProfileDataModelToJson(UserProfileDataModel data) =>
//     json.encode(data.toJson());
//
// class UserProfileDataModel {
//   User? user;
//   String? playstoreLink;
//   String? appstoreLink;
//   String? message;
//
//   UserProfileDataModel({
//     this.user,
//     this.playstoreLink,
//     this.appstoreLink,
//     this.message,
//   });
//
//   factory UserProfileDataModel.fromJson(Map<String, dynamic> json) =>
//       UserProfileDataModel(
//         user: json["user"] != null ? User.fromJson(json["user"]) : null,
//         playstoreLink: json["playstore_link"],
//         appstoreLink: json["appstore_link"],
//         message: json["message"],
//       );
//
//   Map<String, dynamic> toJson() => {
//     "user": user != null ? user!.toJson() : null,
//     "playstore_link": playstoreLink,
//     "appstore_link": appstoreLink,
//     "message": message,
//   };
// }
//
// class User {
//   int id;
//   String? name;
//   String? email;
//   String? role;
//   DateTime? emailVerifiedAt;
//   String? status;
//   List<SubscriptionType>? subscriptionType;
//   String? subPremium;
//   String? subVip;
//   String? subLive;
//   DateTime? subPremiumStart;
//   DateTime? subPremiumEnd;
//   DateTime? subVipStart;
//   DateTime? subVipEnd;
//   dynamic subLiveStart;
//   dynamic subLiveEnd;
//   dynamic mobile;
//   dynamic address;
//   dynamic bankAccountNumber;
//   dynamic bankName;
//   String? referId;
//   dynamic referFrom;
//   dynamic referLevel;
//   String? level1Premium;
//   String? level2Premium;
//   String? level3Premium;
//   String? level1Vip;
//   String? level2Vip;
//   String? level3Vip;
//   String? level4Vip;
//   String ? totalLiveRefer;
//   dynamic ? liveLevel3;
//   dynamic referLink;
//   String? totalRefer;
//   String? totalPremiumRefer;
//   dynamic subscriptionStartDate;
//   dynamic subscriptionEndDate;
//   String? subscriptionStatus;
//   dynamic paymentMethod;
//   dynamic image;
//   String? balance;
//   dynamic deletedAt;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   User({
//     required this.id,
//     this.name,
//     this.email,
//     this.role,
//     this.emailVerifiedAt,
//     this.status,
//     this.subscriptionType,
//     this.subPremium,
//     this.subVip,
//     this.subLive,
//     this.subPremiumStart,
//     this.subPremiumEnd,
//     this.subVipStart,
//     this.subVipEnd,
//     this.subLiveStart,
//     required this.subLiveEnd,
//     required this.mobile,
//     required this.address,
//     required this.bankAccountNumber,
//     required this.bankName,
//     this.referId,
//     required this.referFrom,
//     required this.referLevel,
//     this.level1Premium,
//     this.level2Premium,
//     this.level3Premium,
//     this.level1Vip,
//     this.level2Vip,
//     this.level3Vip,
//     this.level4Vip,
//     this.totalLiveRefer,
//     this.liveLevel3,
//     required this.referLink,
//     this.totalRefer,
//     this.totalPremiumRefer,
//     required this.subscriptionStartDate,
//     required this.subscriptionEndDate,
//     this.subscriptionStatus,
//     required this.paymentMethod,
//     required this.image,
//     this.balance,
//     required this.deletedAt,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     name: json["name"] ?? "",
//     email: json["email"],
//     role: json["role"],
//     emailVerifiedAt: json["email_verified_at"] != null
//         ? DateTime.parse(json["email_verified_at"])
//         : null,
//     status: json["status"],
//     subscriptionType: json["subscription_type"] != null
//         ? List<SubscriptionType>.from(json["subscription_type"]
//         .map((x) => SubscriptionType.fromJson(x)))
//         : null,
//     subPremium: json["sub_premium"],
//     subVip: json["sub_vip"],
//     subLive: json["sub_live"],
//     subPremiumStart: json["sub_premium_start"] != null
//         ? DateTime.parse(json["sub_premium_start"])
//         : null,
//     subPremiumEnd: json["sub_premium_end"] != null
//         ? DateTime.parse(json["sub_premium_end"])
//         : null,
//     subVipStart: json["sub_vip_start"] != null
//         ? DateTime.parse(json["sub_vip_start"])
//         : null,
//     subVipEnd: json["sub_vip_end"] != null
//         ? DateTime.parse(json["sub_vip_end"])
//         : null,
//     subLiveStart: json["sub_live_start"],
//     subLiveEnd: json["sub_live_end"],
//     mobile: json["mobile"],
//     address: json["address"],
//     bankAccountNumber: json["bank_account_number"],
//     bankName: json["bank_name"],
//     referId: json["refer_id"],
//     referFrom: json["refer_from"],
//     referLevel: json["refer_level"],
//     level1Premium: json["level_1_premium"],
//     level2Premium: json["level_2_premium"],
//     level3Premium: json["level_3_premium"],
//     level1Vip: json["level_1_vip"],
//     level2Vip: json["level_2_vip"],
//     level3Vip: json["level_3_vip"],
//     level4Vip: json["level_4_vip"],
//     totalLiveRefer: json["total_live_refer"],
//     liveLevel3: json['live_level_3'],
//     referLink: json["refer_link"],
//     totalRefer: json["total_refer"],
//     totalPremiumRefer: json["total_premium_refer"],
//     subscriptionStartDate: json["subscription_start_date"],
//     subscriptionEndDate: json["subscription_end_date"],
//     subscriptionStatus: json["subscription_status"],
//     paymentMethod: json["payment_method"],
//     image: json["image"],
//     balance: json["balance"],
//     deletedAt: json["deleted_at"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//   "id": id,
//   "name": name,
//   "email": email,
//   "role": role,
//   "email_verified_at": emailVerifiedAt?.toIso8601String(),
//   "status": status,
//   "subscription_type": subscriptionType != null
//   ? List<dynamic>.from(subscriptionType!.map((x) => x.toJson()))
//       : null,
//   "sub_premium": subPremium,
//   "sub_vip": subVip,
//   "sub_live": subLive,
//   "sub_premium_start": subPremiumStart?.toIso8601String(),
//     "sub_premium_end": subPremiumEnd?.toIso8601String(),
//     "sub_vip_start": subVipStart?.toIso8601String(),
//     "sub_vip_end": subVipEnd?.toIso8601String(),
//     "sub_live_start": subLiveStart,
//     "sub_live_end": subLiveEnd,
//     "mobile": mobile,
//     "address": address,
//     "bank_account_number": bankAccountNumber,
//     "bank_name": bankName,
//     "refer_id": referId,
//     "refer_from": referFrom,
//     "refer_level": referLevel,
//     "level_1_premium": level1Premium,
//     "level_2_premium": level2Premium,
//     "level_3_premium": level3Premium,
//     "level_1_vip": level1Vip,
//     "level_2_vip": level2Vip,
//     "level_3_vip": level3Vip,
//     "level_4_vip": level4Vip,
//     "total_live_refer": totalLiveRefer,
//     "live_level_3": liveLevel3,
//     "refer_link": referLink,
//     "total_refer": totalRefer,
//     "total_premium_refer": totalPremiumRefer,
//     "subscription_start_date": subscriptionStartDate,
//     "subscription_end_date": subscriptionEndDate,
//     "subscription_status": subscriptionStatus,
//     "payment_method": paymentMethod,
//     "image": image,
//     "balance": balance,
//     "deleted_at": deletedAt,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//   };
// }
//
// class SubscriptionType {
//   int id;
//   String? name;
//   String? price;
//   dynamic membershipLevelManageId;
//   dynamic description;
//   String? status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<Level> levels;
//   List<Feature> features;
//
//   SubscriptionType({
//     required this.id,
//     this.name,
//     this.price,
//     required this.membershipLevelManageId,
//     required this.description,
//     this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.levels,
//     required this.features,
//   });
//
//   factory SubscriptionType.fromJson(Map<String, dynamic> json) =>
//       SubscriptionType(
//         id: json["id"],
//         name: json["name"],
//         price: json["price"],
//         membershipLevelManageId: json["membership_level_manage_id"],
//         description: json["description"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         levels: List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
//         features: List<Feature>.from(
//             json["features"].map((x) => Feature.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "price": price,
//     "membership_level_manage_id": membershipLevelManageId,
//     "description": description,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "levels": List<dynamic>.from(levels.map((x) => x.toJson())),
//     "features": List<dynamic>.from(features.map((x) => x.toJson())),
//   };
// }
//
// class Feature {
//   int id;
//   String name;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   FeaturePivot pivot;
//
//   Feature({
//     required this.id,
//     required this.name,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.pivot,
//   });
//
//   factory Feature.fromJson(Map<String, dynamic> json) => Feature(
//     id: json["id"],
//     name: json["name"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     pivot: FeaturePivot.fromJson(json["pivot"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "pivot": pivot.toJson(),
//   };
// }
//
// class FeaturePivot {
//   String membershipPackageManageId;
//   String featureManageId;
//   String id;
//
//   FeaturePivot({
//     required this.membershipPackageManageId,
//     required this.featureManageId,
//     required this.id,
//   });
//
//   factory FeaturePivot.fromJson(Map<String, dynamic> json) => FeaturePivot(
//     membershipPackageManageId: json["membership_package_manage_id"],
//     featureManageId: json["feature_manage_id"],
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "membership_package_manage_id": membershipPackageManageId,
//     "feature_manage_id": featureManageId,
//     "id": id,
//   };
// }
//
// class Level {
//   int id;
//   String name;
//   String limitMin;
//   String limitMax;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   LevelPivot pivot;
//
//   Level({
//     required this.id,
//     required this.name,
//     required this.limitMin,
//     required this.limitMax,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.pivot,
//   });
//
//   factory Level.fromJson(Map<String, dynamic> json) => Level(
//     id: json["id"],
//     name: json["name"],
//     limitMin: json["limit_min"],
//     limitMax: json["limit_max"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     pivot: LevelPivot.fromJson(json["pivot"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "limit_min": limitMin,
//     "limit_max": limitMax,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "pivot": pivot.toJson(),
//   };
// }
//
// class LevelPivot {
//   String membershipPackageManageId;
//   String membershipLevelManageId;
//   String id;
//
//   LevelPivot({
//     required this.membershipPackageManageId,
//     required this.membershipLevelManageId,
//     required this.id,
//   });
//
//   factory LevelPivot.fromJson(Map<String, dynamic> json) => LevelPivot(
//     membershipPackageManageId: json["membership_package_manage_id"],
//     membershipLevelManageId: json["membership_level_manage_id"],
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "membership_package_manage_id": membershipPackageManageId,
//     "membership_level_manage_id": membershipLevelManageId,
//     "id": id,
//   };
// }

// --------> <--------
// To parse this JSON data, do
//
//     final userProfileDataModel = userProfileDataModelFromJson(jsonString);

import 'dart:convert';

UserProfileDataModel userProfileDataModelFromJson(String str) => UserProfileDataModel.fromJson(json.decode(str));

String userProfileDataModelToJson(UserProfileDataModel data) => json.encode(data.toJson());

class UserProfileDataModel {
  User ? user;
  String ? playstoreLink;
  String ? appstoreLink;
  String ? referLinkPremium;
  String ? referLinkVip;
  String ? referLinkLive;
  String ? message;

  UserProfileDataModel({
    this.user,
    this.playstoreLink,
    this.appstoreLink,
    this.referLinkPremium,
    this.referLinkVip,
    this.referLinkLive,
    this.message,
  });

  factory UserProfileDataModel.fromJson(Map<String, dynamic> json) => UserProfileDataModel(
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
    playstoreLink: json["playstore_link"],
    appstoreLink: json["appstore_link"],
    referLinkPremium: json["refer_link_premium"],
    referLinkVip: json["refer_link_vip"],
    referLinkLive: json["refer_link_live"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "playstore_link": playstoreLink,
    "appstore_link": appstoreLink,
    "refer_link_premium": referLinkPremium,
    "refer_link_vip": referLinkVip,
    "refer_link_live": referLinkLive,
    "message": message,
  };
}

class User {
  int id;
  String ? name;
  String? email;
  String? username;
  String? role;
  DateTime? emailVerifiedAt;
  String? status;
  List<SubscriptionType>? subscriptionType;
  String? subPremium;
  String? subVip;
  String? subLive;
  DateTime? subPremiumStart;
  DateTime? subPremiumEnd;
  DateTime? subVipStart;
  DateTime? subVipEnd;
  DateTime? subLiveStart;
  String? level1Premium;
  String? level2Premium;
  String? level3Premium;
  String? level1Vip;
  String? level2Vip;
  String? level3Vip;
  String? level4Vip;
  String? level1Live;
  String? levelSaving;
  String? mobile;
  String? address;
  String? bankAccountNumber;
  String? bankName;
  String? referId;
  String? referFrom;
  String? referLink;
  String? referIdPremium;
  String? referIdVip;
  String? referIdLive;
  String? referTotalPremium;
  String? referTotalVip;
  String? referTotalLive;
  String? referTotalSubscribePremium;
  String? referTotalSubscribeVip;
  String? referTotalSubscribeLive;
  String? referFromPremium;
  String? referFromVip;
  String? referFromLive;
  String? paymentMethod;
  String? image;
  String? balance;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    this.name,
    this.email,
    this.username,
    this.role,
    this.emailVerifiedAt,
    this.status,
    this.subscriptionType,
    this.subPremium,
    this.subVip,
    this.subLive,
    this.subPremiumStart,
    this.subPremiumEnd,
    this.subVipStart,
    this.subVipEnd,
    this.subLiveStart,
    this.level1Premium,
    this.level2Premium,
    this.level3Premium,
    this.level1Vip,
    this.level2Vip,
    this.level3Vip,
    this.level4Vip,
    this.level1Live,
    this.levelSaving,
    this.mobile,
    this.address,
    this.bankAccountNumber,
    this.bankName,
    this.referId,
    this.referFrom,
    this.referLink,
    this.referIdPremium,
    this.referIdVip,
    this.referIdLive,
    this.referTotalPremium,
    this.referTotalVip,
    this.referTotalLive,
    this.referTotalSubscribePremium,
    this.referTotalSubscribeVip,
    this.referTotalSubscribeLive,
    this.referFromPremium,
    this.referFromVip,
    this.referFromLive,
    this.paymentMethod,
    this.image,
    this.balance,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    username: json["username"],
    role: json["role"],
    emailVerifiedAt: json["email_verified_at"] != null ? DateTime.parse(json["email_verified_at"]) : null,
    status: json["status"],
    subscriptionType: json["subscription_type"] != null
        ? List<SubscriptionType>.from(json["subscription_type"].map((x) => SubscriptionType.fromJson(x)))
        : null,
    subPremium: json["sub_premium"],
    subVip: json["sub_vip"],
    subLive: json["sub_live"],
    subPremiumStart: json["sub_premium_start"] != null ? DateTime.parse(json["sub_premium_start"]) : null,
    subPremiumEnd: json["sub_premium_end"] != null ? DateTime.parse(json["sub_premium_end"]) : null,
    subVipStart: json["sub_vip_start"] != null ? DateTime.parse(json["sub_vip_start"]) : null,
    subVipEnd: json["sub_vip_end"] != null ? DateTime.parse(json["sub_vip_end"]) : null,
    subLiveStart: json["sub_live_start"] != null ? DateTime.parse(json["sub_live_start"]) : null,
    level1Premium: json["level_1_premium"],
    level2Premium: json["level_2_premium"],
    level3Premium: json["level_3_premium"],
    level1Vip: json["level_1_vip"],
    level2Vip: json["level_2_vip"],
    level3Vip: json["level_3_vip"],
    level4Vip: json["level_4_vip"],
    level1Live: json["level_1_live"],
    levelSaving: json["level_saving"],
    mobile: json["mobile"],
    address: json["address"],
    bankAccountNumber: json["bank_account_number"],
    bankName: json["bank_name"],
    referId: json["refer_id"],
    referFrom: json["refer_from"],
    referLink: json["refer_link"],
    referIdPremium: json["refer_id_premium"],
    referIdVip: json["refer_id_vip"],
    referIdLive: json["refer_id_live"],
    referTotalPremium: json["refer_total_premium"],
    referTotalVip: json["refer_total_vip"],
    referTotalLive: json["refer_total_live"],
    referTotalSubscribePremium: json["refer_total_subscribe_premium"],
    referTotalSubscribeVip: json["refer_total_subscribe_vip"],
    referTotalSubscribeLive: json["refer_total_subscribe_live"],
    referFromPremium: json["refer_from_premium"],
    referFromVip: json["refer_from_vip"],
    referFromLive: json["refer_from_live"],
    paymentMethod: json["payment_method"],
    image: json["image"],
    balance: json["balance"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "username": username,
    "role": role,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "status": status,
    "subscription_type": subscriptionType != null ? List<dynamic>.from(subscriptionType!.map((x) => x.toJson())) : null,
    "sub_premium": subPremium,
    "sub_vip": subVip,
    "sub_live": subLive,
    "sub_premium_start": subPremiumStart?.toIso8601String(),
    "sub_premium_end": subPremiumEnd?.toIso8601String(),
    "sub_vip_start": subVipStart?.toIso8601String(),
    "sub_vip_end": subVipEnd?.toIso8601String(),
    "sub_live_start": subLiveStart?.toIso8601String(),
    "level_1_premium": level1Premium,
    "level_2_premium": level2Premium,
    "level_3_premium": level3Premium,
    "level_1_vip": level1Vip,
    "level_2_vip": level2Vip,
    "level_3_vip": level3Vip,
    "level_4_vip": level4Vip,
    "level_1_live": level1Live,
    "level_saving": levelSaving,
    "mobile": mobile,
    "address": address,
    "bank_account_number": bankAccountNumber,
    "bank_name": bankName,
    "refer_id": referId,
    "refer_from": referFrom,
    "refer_link": referLink,
    "refer_id_premium": referIdPremium,
    "refer_id_vip": referIdVip,
    "refer_id_live": referIdLive,
    "refer_total_premium": referTotalPremium,
    "refer_total_vip": referTotalVip,
    "refer_total_live": referTotalLive,
    "refer_total_subscribe_premium": referTotalSubscribePremium,
    "refer_total_subscribe_vip": referTotalSubscribeVip,
    "refer_total_subscribe_live": referTotalSubscribeLive,
    "refer_from_premium": referFromPremium,
    "refer_from_vip": referFromVip,
    "refer_from_live": referFromLive,
    "payment_method": paymentMethod,
    "image": image,
    "balance": balance,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class SubscriptionType {
  int id;
  String name;
  String price;
  dynamic membershipLevelManageId;
  dynamic description;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  List<Level> levels;
  List<Feature> features;

  SubscriptionType({
    required this.id,
    required this.name,
    required this.price,
    this.membershipLevelManageId,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.levels,
    required this.features,
  });

  factory SubscriptionType.fromJson(Map<String, dynamic> json) => SubscriptionType(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    membershipLevelManageId: json["membership_level_manage_id"],
    description: json["description"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    levels: List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "membership_level_manage_id": membershipLevelManageId,
    "description": description,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "levels": List<dynamic>.from(levels.map((x) => x.toJson())),
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
  };
}

class Feature {
  int id;
  String name;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  FeaturePivot pivot;

  Feature({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pivot: FeaturePivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "pivot": pivot.toJson(),
  };
}

class FeaturePivot {
  String membershipPackageManageId;
  String featureManageId;
  String id;

  FeaturePivot({
    required this.membershipPackageManageId,
    required this.featureManageId,
    required this.id,
  });

  factory FeaturePivot.fromJson(Map<String, dynamic> json) => FeaturePivot(
    membershipPackageManageId: json["membership_package_manage_id"],
    featureManageId: json["feature_manage_id"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "membership_package_manage_id": membershipPackageManageId,
    "feature_manage_id": featureManageId,
    "id": id,
  };
}

class Level {
  int id;
  String name;
  String limitMin;
  String limitMax;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  LevelPivot pivot;

  Level({
    required this.id,
    required this.name,
    required this.limitMin,
    required this.limitMax,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: json["id"],
    name: json["name"],
    limitMin: json["limit_min"],
    limitMax: json["limit_max"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pivot: LevelPivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "limit_min": limitMin,
    "limit_max": limitMax,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "pivot": pivot.toJson(),
  };
}

class LevelPivot {
  String membershipPackageManageId;
  String membershipLevelManageId;
  String id;

  LevelPivot({
    required this.membershipPackageManageId,
    required this.membershipLevelManageId,
    required this.id,
  });

  factory LevelPivot.fromJson(Map<String, dynamic> json) => LevelPivot(
    membershipPackageManageId: json["membership_package_manage_id"],
    membershipLevelManageId: json["membership_level_manage_id"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "membership_package_manage_id": membershipPackageManageId,
    "membership_level_manage_id": membershipLevelManageId,
    "id": id,
  };
}


