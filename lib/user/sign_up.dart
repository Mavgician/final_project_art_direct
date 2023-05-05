import 'package:final_project_art_direct/miscellaneous/auth_service.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:final_project_art_direct/user/login.dart';
import 'package:flutter/material.dart';

import 'package:final_project_art_direct/miscellaneous/buttons.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: loginTheme,
      home: Scaffold(
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  children: [
                    const Text(
                      'Get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    addVerticalSpace(10),
                    const Text(
                      'Create your ArtDirect account to share your beautiful artworks.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,)
                    ),
                    addVerticalSpace(40),
                    SocialLoginButton(
                      iconDirectory: 'assets/icons/socmed/google.svg',
                      text: 'Sign up with Google',
                      onTap: () => {}
                    ),
                    addVerticalSpace(40),
                    const TextField(
                      decoration: InputDecoration( labelText: 'Email', ),
                    ),
                    addVerticalSpace(20),
                    const TextField(
                      decoration: InputDecoration( labelText: 'Username', ),
                    ),
                    addVerticalSpace(20),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration( labelText: 'Password', ),
                    ),
                    addVerticalSpace(20),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration( labelText: 'Confirm Password', ),
                    ),
                    addVerticalSpace(40),
                    NavigationButton(
                      text: 'Get Started!',
                      onTap: () {}),
                    addVerticalSpace(20),
                    NavigationButton(
                      text: 'Back',
                      isOutline: true,
                      onTap: () {
                        Navigator.of(context)
                          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()), (Route route) => false);
                      },
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
