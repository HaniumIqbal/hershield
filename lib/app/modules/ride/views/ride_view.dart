import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hershield/app/constant.dart';
import 'package:hershield/app/modules/ride/views/tabs/BookRideView.dart';
import 'package:hershield/app/modules/ride/views/tabs/InProgressRideView.dart';
import 'package:hershield/constant/colors.dart';

import '../controllers/ride_controller.dart';

class RideView extends GetView<RideController> {
  const RideView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.onInit();
    controller.getCurrentLocation();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: MyColor.inputFieldColor,
          centerTitle: true,
          automaticallyImplyLeading: true,
          bottom: TabBar(
            indicatorColor: MyColor.pinkTextColor,
            labelColor: MyColor.pinkTextColor,
            tabs: const [
              Tab(icon: Icon(Icons.taxi_alert),text: "Book Ride",),
              Tab(icon: Icon(Icons.travel_explore),text: "In-Progress Ride",),
            ],
          ),
          title: const Text('Carpooling'),
        ),
        body: const TabBarView(
          children: [
            BookRideView(),
            InProgressRideView(),

          ],
        ),
      ),
    );


  }


// double calculateDistance(lat1, lon1, lat2, lon2){
//   var p = 0.017453292519943295;
//   var c = cos;
//   var a = 0.5 - c((lat2 - lat1) * p)/2 +
//       c(lat1 * p) * c(lat2 * p) *
//           (1 - c((lon2 - lon1) * p))/2;
//   return 12742 * asin(sqrt(a));
// }
}


