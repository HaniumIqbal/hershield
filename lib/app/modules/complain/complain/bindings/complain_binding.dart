import 'package:get/get.dart';

import '../controllers/complain_controller.dart';

class ComplainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplainController>(
      () => ComplainController(),
    );
  }
}
