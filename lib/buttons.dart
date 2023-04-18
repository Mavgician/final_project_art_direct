import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.iconDirectory,
    required this.textButton,
    required this.onTap,
    this.color = Colors.white
  });

  final String textButton, iconDirectory;
  final Color color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(90),
        color: color,
        child: InkWell(
          child: SizedBox(
            height: 50,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconDirectory),
                const SizedBox(width: 10,),
                Text(textButton, style: const TextStyle(fontWeight: FontWeight.bold),)
              ],
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
    this.isOutline = false,
    this.color = Colors.white
  });

  final String textButton;
  final bool isOutline;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: isOutline ? 0 : 8.0,
        borderRadius: BorderRadius.circular(90),
        color: isOutline ? Colors.transparent : color,
        child: InkWell(
          child: Container(
            height: 35,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              border: Border.all(color: color)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(textButton, style: TextStyle(fontWeight: FontWeight.bold, color: isOutline ? color : null),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}