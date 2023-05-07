import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:final_project_art_direct/miscellaneous/auth_service.dart';
import 'package:final_project_art_direct/user/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:final_project_art_direct/miscellaneous/buttons.dart';

import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/responsiveSizes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late String loginData = '', loginType;

  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        theme: loginTheme,
        home: Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                alignment: AlignmentDirectional.topCenter,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: NetworkImage('https://picsum.photos/1920/1080'),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              SingleChildScrollView (
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 125),
                      child: Container(
                        height: 620,
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 30, 37, 55),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40)
                          ),
                        ),
                        child: Column(
                          children: [
                            addVerticalSpace(145,),
                            Text('Sign in to ArtDirect', style: TextStyle(fontSize: responsiveHeaderSize(context), fontWeight: FontWeight.w900, color: Colors.white),),
                            addVerticalSpace(20,),
                            SocialLoginButton(
                              iconDirectory: 'assets/icons/socmed/google.svg',
                              text: 'Login with Google',
                              onTap: () async {
                                AuthService().signInGoogle();
                              },
                            ),
                            addVerticalSpace(30,),
                            const HorSpacerWithOptText(text: "OR"),
                            addVerticalSpace(30,),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration( labelText: 'Phone, Email Address, or User handle', ),
                                    style: const TextStyle( color: Colors.white ),
                                    onChanged: (value) => setState(() => { loginData = value }),
                                    validator: (value) => value!.isEmpty ? 'Please enter Phone, Email Address, or User handle!' : null,
                                  ),
                                  addVerticalSpace(20,),
                                  NavigationButton(
                                    text: 'Next',
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                                    },
                                  ),
                                ],
                              )
                            ),
                            addVerticalSpace(20,),
                            NavigationButton(
                              text: 'Forgot Password?',
                              isOutline: true,
                              onTap: () {
                                
                              },
                            ),
                            addVerticalSpace(20,),
                            
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: Colors.white,
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}