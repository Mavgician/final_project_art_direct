import 'package:final_project_art_direct/miscellaneous/auth_provider.dart';
import 'package:final_project_art_direct/user/login.dart';
import 'package:final_project_art_direct/user/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';
import 'miscellaneous/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: const MaterialApp(
        title: 'ArtDirect',
        home: HomeController() /* Home() */ /* Login() */
      ), 
    );
  }
}

class HomeController extends StatelessWidget {
  const HomeController({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService? auth = Provider.of(context)?.auth;

    return StreamBuilder(
      stream: auth?.onAuthStateChanged,
      builder: (context, AsyncSnapshot snapshot) {
        
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;

          if (signedIn) {
            return FutureBuilder(
              future: AuthService().checkAccount(snapshot.data.uid),
              builder: (context, AsyncSnapshot accountExists) {
                if (accountExists.hasData) {
                  if (accountExists.data) {
                    return const Home();
                  } else {
                    return SignUp(loginData: snapshot.data.email, loginType: 'email',);
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
            );
          } else {
            return const Login();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}