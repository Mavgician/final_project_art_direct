import 'package:flutter/material.dart';

// Some helper widgets to increase code readability and ease of use.

// Spacer widgets
Widget addVerticalSpace(double height) {
  return SizedBox( height: height,);
}

Widget addHorizontalSpace(double width) {
  return SizedBox(width: width,);
}

// Application header and slogan widget
Widget appNameSloganHeader(theme) {
  return Column(
    children: [
      Text('ArtDirect', style: theme,),
      const Text('Direct your art with magnificence')
    ],
  );
}

// Class that returns a horizontal spacer that has a horizontal line. If text is available horizontal line is divided with the text in the middle.
class HorSpacerWithOptText extends StatelessWidget {
  const HorSpacerWithOptText(
    {
      super.key,
      this.text = '',
      this.textColor = Colors.white,
      this.color = const Color.fromARGB(125, 255, 255, 255),
    }
  );

  final Color color, textColor;
  final String text;

  @override
  Widget build(BuildContext context) {

    double horizontalSpace = text.isEmpty ? 0 : 20.0;

    return Row(
      children: [
        Expanded(child: Container(height: 1, decoration: BoxDecoration(color: color),)),
        addHorizontalSpace(horizontalSpace,),
        Text(text, style: TextStyle(fontWeight: FontWeight.w900, color: textColor),),
        addHorizontalSpace(horizontalSpace,),
        Expanded(child: Container(height: 1, decoration: BoxDecoration(color: color),)),
      ],
    );
  }
}