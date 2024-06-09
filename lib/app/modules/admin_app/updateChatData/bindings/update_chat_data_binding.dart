import 'package:get/get.dart';

import '../controllers/update_chat_data_controller.dart';

class UpdateChatDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateChatDataController>(
      () => UpdateChatDataController(),
    );
  }
}
