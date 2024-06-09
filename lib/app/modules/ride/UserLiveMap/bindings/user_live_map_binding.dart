import 'package:get/get.dart';

import '../controllers/user_live_map_controller.dart';

class UserLiveMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserLiveMapController>(
      () => UserLiveMapController(),
    );
  }
}
