import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/widget/custom_text.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.title,
    required this.onTab,
  });

  final String title;
  final Callback onTab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: MaterialButton(
          onPressed: onTab,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          color: MyColor.cardColor,
          child: CustomText(
            text: title,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
