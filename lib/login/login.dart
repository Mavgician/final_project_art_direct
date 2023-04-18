import 'package:flutter/material.dart';
import 'package:final_project_art_direct/buttons.dart';

class HorizontalSpacerWithText extends StatelessWidget {
  const HorizontalSpacerWithText(
    {
      super.key,
      required this.text,
      this.textColor = Colors.white,
      this.color = const Color.fromARGB(125, 255, 255, 255),
    }
  );

  final Color color, textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, decoration: BoxDecoration(color: color),)),
        const SizedBox(width: 20,),
        Text(text, style: TextStyle(fontWeight: FontWeight.w900, color: textColor), ),
        const SizedBox(width: 20,),
        Expanded(child: Container(height: 1, decoration: BoxDecoration(color: color),)),
      ],
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String email = '';

  Widget buildEmail() => TextField(
    decoration: const InputDecoration(
      labelText: 'email',
      labelStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
      )
    ),
    style: const TextStyle(
      color: Colors.white
    ),
    onChanged: (value) => setState(() => { email = value }),
  );
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
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
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 30, 37, 55),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 145,),
                        const Text('Sign in to ArtDirect', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),),
                        const SizedBox(height: 20,),
                        SocialLoginButton(
                          iconDirectory: 'assets/icons/socmed/google.svg',
                          textButton: 'Login with Google',
                          onTap: () => {
                              
                          },
                        ),
                        const SizedBox(height: 10,),
                        SocialLoginButton(
                          iconDirectory: 'assets/icons/socmed/facebook.svg', 
                          textButton: 'Login with Facebook',
                          onTap: () => {
                              
                          }
                        ),
                        const SizedBox(height: 30,),
                        const HorizontalSpacerWithText(text: "OR"),
                        const SizedBox(height: 30,),
                        buildEmail(),
                        const SizedBox(height: 20,),
                        const NavigationButton(
                          textButton: 'Next',
                        ),
                        const SizedBox(height: 20,),
                        const NavigationButton(
                          textButton: 'Forgot Password?',
                          isOutline: true,
                        ),
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
    );
  }
}