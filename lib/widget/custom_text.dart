import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      this.fontSize = 14,
      this.fontWeight,
      required this.color,
      this.isUnderline = false,
      this.maxLine = 1});

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color color;
  final bool? isUnderline;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      minFontSize: 10,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(
          letterSpacing: -0.2,
          fontSize: fontSize,
          decoration:
              isUnderline! ? TextDecoration.underline : TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color),
    );
  }
}
