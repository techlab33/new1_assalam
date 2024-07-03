// import 'package:assalam/data/models/profile/user_profile_data_model.dart';
// import 'package:assalam/data/services/profile/get_user_profile_data.dart';
// import 'package:get/get.dart';
//
// class UserProfileController extends GetxController {
//   Rx<UserProfileDataModel?> _userProfileData = Rx<UserProfileDataModel?>(null);
//   RxBool _isLoading = RxBool(false);
//   RxString _error = RxString('');
//
//   UserProfileDataModel? get userProfileData => _userProfileData.value;
//   bool get isLoading => _isLoading.value;
//   String get error => _error.value;
//
//   var fetchProfileData = UserProfileGetData();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserProfileData();
//   }
//
//   Future<void> fetchUserProfileData() async {
//     _isLoading.value = true;
//     _error.value = '';
//
//     try {
//       _userProfileData.value = await fetchProfileData.fetchUserProfileData();
//     } catch (e) {
//       _error.value = e.toString();
//     } finally {
//       _isLoading.value = false;
//     }
//   }
// }

import 'package:assalam/data/models/profile/user_profile_data_model.dart';
import 'package:assalam/data/services/profile/get_user_profile_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  Rx<UserProfileDataModel?> _userProfileData = Rx<UserProfileDataModel?>(null);
  RxBool _isLoading = RxBool(false);
  RxString _error = RxString('');

  UserProfileDataModel? get userProfileData => _userProfileData.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;

  var fetchProfileData = UserProfileGetData();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfileData();
  }

  Future<void> fetchUserProfileData() async {
    _isLoading.value = true;
    _error.value = '';

    try {
      _userProfileData.value = await fetchProfileData.fetchUserProfileData();
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Method to update the profile image
  Future<void> updateUserProfileImage(String newImageUrl) async {
    if (_userProfileData.value != null && _userProfileData.value!.user != null) {
      // Evict the old image from the cache
      CachedNetworkImage.evictFromCache(_userProfileData.value!.user!.image!);

      // Update the profile data with the new image URL
      _userProfileData.update((val) {
        if (val != null && val.user != null) {
          val.user!.image = newImageUrl;
        }
      });

      // Notify listeners to rebuild the widget
      update();
    }
  }
}

