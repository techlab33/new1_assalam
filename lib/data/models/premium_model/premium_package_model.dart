//
//
// class Package {
//   final int id;
//   final String name;
//   final String price;
//   final String membershipLevelManageId;
//   final String description;
//   final String status;
//   final String createdAt;
//   final String updatedAt;
//   final Level level;
//   final List<Feature> features;
//
//   Package({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.membershipLevelManageId,
//     required this.description,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.level,
//     required this.features,
//   });
//
//   factory Package.fromJson(Map<String, dynamic> json) {
//     final level = Level.fromJson(json['level']);
//     final features = (json['features'] as List)
//         .map((featureJson) => Feature.fromJson(featureJson))
//         .toList();
//     return Package(
//       id: json['id'],
//       name: json['name'],
//       price: json['price'],
//       membershipLevelManageId: json['membership_level_manage_id'],
//       description: json['description'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       level: level,
//       features: features,
//     );
//   }
// }
//
// class Level {
//   final int id;
//   final String name;
//   final String limit;
//   final String status;
//   final String createdAt;
//   final String updatedAt;
//
//   Level({
//     required this.id,
//     required this.name,
//     required this.limit,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Level.fromJson(Map<String, dynamic> json) {
//     return Level(
//       id: json['id'],
//       name: json['name'],
//       limit: json['limit'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }
// }
//
// class Feature {
//   final int id;
//   final String name;
//   final String status;
//   final String createdAt;
//   final String updatedAt;
//   final Pivot pivot;
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
//   factory Feature.fromJson(Map<String, dynamic> json) {
//     final pivot = Pivot.fromJson(json['pivot']);
//     return Feature(
//       id: json['id'],
//       name: json['name'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       pivot: pivot,
//     );
//   }
// }
//
// class Pivot {
//   final String membershipPackageManageId;
//   final String featureManageId;
//   final String id;
//
//   Pivot({
//     required this.membershipPackageManageId,
//     required this.featureManageId,
//     required this.id,
//   });
//
//   factory Pivot.fromJson(Map<String, dynamic> json) {
//     return Pivot(
//       membershipPackageManageId: json['membership_package_manage_id'],
//       featureManageId: json['feature_manage_id'],
//       id: json['id'],
//     );
//   }
// }


class Package {
  final int id;
  final String name;
  final String price;
  final String membershipLevelManageId;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Level level;
  final List<Feature> features;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.membershipLevelManageId,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.level,
    required this.features,
  });

  factory Package.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Invalid JSON data');
    }

    final level = Level.fromJson(json['level'] ?? {});
    final features = (json['features'] as List<dynamic>?)
        ?.map((featureJson) => Feature.fromJson(featureJson))
        .toList() ?? [];

    return Package(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      membershipLevelManageId: json['membership_level_manage_id'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      level: level,
      features: features,
    );
  }
}

class Level {
  final int id;
  final String name;
  final String limit;
  final String status;
  final String createdAt;
  final String updatedAt;

  Level({
    required this.id,
    required this.name,
    required this.limit,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Level.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Invalid JSON data');
    }

    return Level(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      limit: json['limit'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class Feature {
  final int id;
  final String name;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Pivot pivot;

  Feature({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Feature.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Invalid JSON data');
    }

    final pivot = Pivot.fromJson(json['pivot'] ?? {});

    return Feature(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pivot: pivot,
    );
  }
}

class Pivot {
  final String membershipPackageManageId;
  final String featureManageId;
  final String id;

  Pivot({
    required this.membershipPackageManageId,
    required this.featureManageId,
    required this.id,
  });

  factory Pivot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Invalid JSON data');
    }

    return Pivot(
      membershipPackageManageId: json['membership_package_manage_id'] ?? '',
      featureManageId: json['feature_manage_id'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
