import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'miscellaneous/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtDirect',
      home: AuthService().handleAuthState() /* Home() */ /* Login() */
    );
  }
}