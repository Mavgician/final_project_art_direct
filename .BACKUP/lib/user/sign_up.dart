import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/miscellaneous/auth_service.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:final_project_art_direct/user/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                    TextFormField(
                      initialValue: FirebaseAuth.instance.currentUser?.email,
                      decoration: const InputDecoration( labelText: 'Email', ),
                      style: const TextStyle( color: Colors.white ),
                      enabled: FirebaseAuth.instance.currentUser?.email == null ? true : false,
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      initialValue: '@',
                      decoration: const InputDecoration( labelText: 'Handle', ),
                      style: const TextStyle( color: Colors.white ),
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration( labelText: 'Password', ),
                      style: const TextStyle( color: Colors.white ),
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration( labelText: 'Confirm Password', ),
                      style: const TextStyle( color: Colors.white ),
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
                        AuthService().signOut();
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
