import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Widgets for different types of buttons used in the app

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.iconDirectory,
    required this.text,
    required this.onTap,
    this.color = Colors.white,
    this.textColor = Colors.black
  });

  final String text, iconDirectory;
  final Color color, textColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Material(
          elevation: 8.0,
          color: color,
          child: Ink(
            height: 50,
            width: 300,
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(iconDirectory),
                  addHorizontalSpace(10),
                  Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: textColor),)
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isOutline = false,
    this.color = Colors.white,
    this.textColor = Colors.black
  });

  final String text;
  final bool isOutline;
  final Color color, textColor;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Material(
          elevation: isOutline ? 0 : 8.0,
          color: isOutline ? Colors.transparent : color,
          child: Ink(
              height: 35,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(color: color)
              ),
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isOutline ? color : textColor),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}