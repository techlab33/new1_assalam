
import 'dart:convert';

ReferenceDataModel referenceDataModelFromJson(String str) => ReferenceDataModel.fromJson(json.decode(str));

String referenceDataModelToJson(ReferenceDataModel data) => json.encode(data.toJson());

class ReferenceDataModel {
  String? message;
  Users? premiumUsers;
  Users? vipUsers;
  LiveUsers? liveUsers;

  ReferenceDataModel({
    this.message,
    this.premiumUsers,
    this.vipUsers,
    this.liveUsers,
  });

  factory ReferenceDataModel.fromJson(Map<String, dynamic> json) => ReferenceDataModel(
    message: json["message"],
    premiumUsers: json["premium_users"] != null ? Users.fromJson(json["premium_users"]) : null,
    vipUsers: json["vip_users"] != null ? Users.fromJson(json["vip_users"]) : null,
    liveUsers: json["live_users"] != null ? LiveUsers.fromJson(json["live_users"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "premium_users": premiumUsers?.toJson(),
    "vip_users": vipUsers?.toJson(),
    "live_users": liveUsers?.toJson(),
  };
}

class LiveUsers {
  int totalRefer;
  int totalSubscriberRefer;
  List<UserList> userList;

  LiveUsers({
    required this.totalRefer,
    required this.totalSubscriberRefer,
    required this.userList,
  });

  factory LiveUsers.fromJson(Map<String, dynamic> json) => LiveUsers(
    totalRefer: json["total_refer"],
    totalSubscriberRefer: json["total_subscriber_refer"],
    userList: List<UserList>.from(json["user_list"].map((x) => UserList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_refer": totalRefer,
    "total_subscriber_refer": totalSubscriberRefer,
    "user_list": List<dynamic>.from(userList.map((x) => x.toJson())),
  };
}

class Users {
  int totalRefer;
  int totalSubscriberRefer;
  List<UserList> userList;

  Users({
    required this.totalRefer,
    required this.totalSubscriberRefer,
    required this.userList,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    totalRefer: json["total_refer"],
    totalSubscriberRefer: json["total_subscriber_refer"],
    userList: List<UserList>.from(json["user_list"].map((x) => UserList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_refer": totalRefer,
    "total_subscriber_refer": totalSubscriberRefer,
    "user_list": List<dynamic>.from(userList.map((x) => x.toJson())),
  };
}

class UserList {
  String name;
  String username;
  String subscriptionType;
  String price;

  UserList({
    required this.name,
    required this.username,
    required this.subscriptionType,
    required this.price,
  });

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
    name: json["name"],
    username: json["username"],
    subscriptionType: json["subscription_type"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "username": username,
    "subscription_type": subscriptionType,
    "price": price,
  };
}