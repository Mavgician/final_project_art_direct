import 'package:final_project_art_direct/login/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtDirect',
      theme: ThemeData(
        textTheme: const TextTheme(
          subtitle1: TextStyle(color: Colors.white)
        )
      ),
      home: const Scaffold(
        body: Center(
          child: Login(),
        ),
      ),
    );
  }
}
