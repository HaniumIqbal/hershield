import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/home/controllers/home_controller.dart';
import 'package:hershield/constant/colors.dart';

class BottomNavView extends GetView<HomeController> {
  BottomNavView({Key? key}) : super(key: key);
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        return NavigationBarTheme(
          data: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w300))),
          child: NavigationBar(
            shadowColor: Colors.red,
            animationDuration: const Duration(seconds: 1),
            surfaceTintColor: Colors.red,
            backgroundColor: MyColor.pinkTextColor,
            onDestinationSelected: (index) {
              controller.currentIndex.value = index;
            },
            indicatorColor: MyColor.cardColor,
            selectedIndex: controller.currentIndex.value,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
                label: "Profile",
              ),
              NavigationDestination(
                  icon: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  label: "Home"),
              NavigationDestination(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: "Setting",
              )
            ],
          ),
        );
      }),
      body: Obx(() {
        return SizedBox(
            child: controller.screen[controller.currentIndex.value]);
      }),
    );
  }
}
