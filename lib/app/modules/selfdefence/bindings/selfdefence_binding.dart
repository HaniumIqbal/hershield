import 'package:get/get.dart';

import '../controllers/selfdefence_controller.dart';

class SelfdefenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelfdefenceController>(
      () => SelfdefenceController(),
    );
  }
}
