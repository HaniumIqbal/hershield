import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:hershield/app/modules/home/controllers/home_controller.dart';
import 'package:hershield/app/modules/home/views/home_view.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/constant/strings.dart';
import 'package:hershield/widget/custom_text.dart';

import '../controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Exit'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).canPop(); // User does not want to exit
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User wants to exit
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: MyColor.pinkTextColor,
            centerTitle: true,
            title: const Center(
              child: CustomText(
                text: "Admin Dashboard",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.logOutAdmin();
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                ),
                color: Colors.white,
              )
            ],
          ),
          backgroundColor: MyColor.lightPinkColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 28,
                ),
                const SizedBox(
                  height: 28,
                ),
                Column(
                  children: <Widget>[
                    AdminHomeWidget(
                      title: 'Update Ambulance Hotline',
                      iconPath: ambulance,
                      onTap: () {
                        Get.toNamed(Routes.UPDATE_FEATURE_DATA,
                            arguments: controller.homeModel.value[0]);
                      },
                    ),
                    AdminHomeWidget(
                      title: 'Update Aurat Foundation',
                      iconPath: auratPath,
                      onTap: () {
                        Get.toNamed(Routes.UPDATE_FEATURE_DATA,
                            arguments: controller.homeModel.value[1]);
                      },
                    ),
                    AdminHomeWidget(
                      title: 'Update Police Helpline',
                      iconPath: car,
                      onTap: () {
                        Get.toNamed(Routes.UPDATE_FEATURE_DATA,
                            arguments: controller.homeModel.value[2]);
                      },
                    ),
                    AdminHomeWidget(
                      title: 'Delete Chat',
                      iconPath: groupChatIconPath,
                      onTap: () {
                        Get.toNamed(Routes.UPDATE_CHAT_DATA);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminHomeWidget extends StatelessWidget {
  const AdminHomeWidget({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });
  final String title, iconPath;
  final Callback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            color: MyColor.cardColor, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(8),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: CustomText(
                maxLine: 2,
                text: title,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Flexible(
                flex: 1, child: Image.asset(iconPath, fit: BoxFit.contain)),
          ],
        ),
      ),
    );
  }
}
