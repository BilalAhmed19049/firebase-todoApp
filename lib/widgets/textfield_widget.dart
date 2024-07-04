import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {super.key,
      //  this.title,
      this.controller,
      this.maxlines,
      this.suffixIcon,
      this.readOnly = false,
      required this.hintText});

  //final String? title;
  final String hintText;
  TextEditingController? controller;
  final int? maxlines;
  final bool readOnly;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Text(
        //   title!,
        // ),
        TextField(
          style: TextStyle(color: CColors.white),
          readOnly: readOnly,
          controller: controller,
          maxLines: maxlines,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                color: CColors.white.withOpacity(0.6),
                fontWeight: FontWeight.normal),
            suffixIcon: suffixIcon,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CColors.secondary),
            ),
          ),
          onChanged: (value) {},
        )
      ],
    );
  }
}
