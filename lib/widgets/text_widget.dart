import 'package:flutter/cupertino.dart';

class TextWidget extends StatelessWidget {
  TextWidget(
      {super.key,
      this.size,
      required this.text,
      this.fontWeight,
      required this.color});

  final double? size;
  final String text;
  final FontWeight? fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        color: color,
      ),
    );
  }
}
