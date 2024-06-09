import 'package:get/get.dart';

import '../controllers/police_help_line_controller.dart';

class PoliceHelpLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoliceHelpLineController>(
      () => PoliceHelpLineController(),
    );
  }
}
