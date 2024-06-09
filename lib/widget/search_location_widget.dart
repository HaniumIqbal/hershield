import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../app/constant.dart';
import '../app/modules/ride/controllers/ride_controller.dart';
import '../constant/colors.dart';

class SearchLocationWidget extends StatelessWidget {
  const SearchLocationWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.editingController, required this.onGetLatLong,
  });

  final String hint;
  final TextEditingController editingController;

  final RideController controller;
  final Function(Prediction) onGetLatLong;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: GooglePlaceAutoCompleteTextField(
        textStyle: const TextStyle(color: Colors.black),
        boxDecoration: BoxDecoration(
            color: MyColor.inputFieldColor,
            borderRadius: BorderRadius.circular(8)),
        textEditingController: editingController,
        googleAPIKey: API_KEY,
        inputDecoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        debounceTime: 800,
        countries: ["pk"],

        // optional by default null is set
        isLatLngRequired: true,
        // if you required coordinates from place detail
        getPlaceDetailWithLatLng: onGetLatLong,
        // this callback is called when isLatLngRequired is true
        itemClick: (Prediction prediction) {
          editingController.text = prediction.description!;
          editingController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length));
        },

        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(
                  width: 7,
                ),
                Expanded(child: Text(prediction.description ?? ""))
              ],
            ),
          );
        },
        seperatedBuilder: const Divider(),
        isCrossBtnShown: true,
        containerHorizontalPadding: 10,
      ),
    );
  }
}