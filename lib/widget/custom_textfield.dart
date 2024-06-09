import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textEditingController,
    required this.hint,
    this.isPrefix = false,
    this.obSecure = false,
    this.textInputType = TextInputType.text,
    this.validate,
    this.errorText, this.onChange, this.maxLine,
  });

  final TextEditingController textEditingController;
  // final String? Function(String?)? validate;
  final String hint;
  final bool? isPrefix;
  final bool? obSecure;
  final TextInputType? textInputType;
  final String? Function(String?)? validate;
  final Function(String?)? onChange;
  final String? errorText;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onChanged: onChange,
      maxLines: maxLine ?? 1,

      keyboardType: textInputType!,
      obscureText: obSecure!,
      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600),
      cursorColor: MyColor.pinkTextColor,
      validator: validate,
      decoration: InputDecoration(
        errorText: errorText,

        prefixIconConstraints: const BoxConstraints(
          maxWidth: 40,
          maxHeight: 40,
        ),
        prefixIcon: isPrefix!
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset("assets/images/flag.png"),
              )
            : null,
        isDense: true,
        fillColor: MyColor.inputFieldColor,
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        hintStyle:
            GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600,),
        filled: true,
      ),
    );
  }
}
