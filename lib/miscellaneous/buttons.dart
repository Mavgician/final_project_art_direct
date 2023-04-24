import 'package:final_project_art_direct/user/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Widgets for different types of buttons used in the app

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.iconDirectory,
    required this.textButton,
    required this.onTap,
    this.color = Colors.white,
    this.textColor = Colors.black
  });

  final String textButton, iconDirectory;
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
                  const SizedBox(width: 10,),
                  Text(textButton, style: TextStyle(fontWeight: FontWeight.bold, color: textColor),)
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
    required this.textButton,
    required this.onTap,
    this.isOutline = false,
    this.color = Colors.white,
    this.textColor = Colors.black
  });

  final String textButton;
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
                  Text(textButton, style: TextStyle(fontWeight: FontWeight.bold, color: isOutline ? color : textColor),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IconButton extends StatefulWidget {
  const IconButton({
    super.key,
    required this.icon
  });

  final Icon icon;

  @override
  State<IconButton> createState() => IconButtonState();
}

class IconButtonState extends State<IconButton> {

  @override

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}