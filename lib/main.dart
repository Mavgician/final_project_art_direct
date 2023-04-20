import 'package:final_project_art_direct/home/home.dart';
import 'package:final_project_art_direct/login/login.dart';
import 'package:flutter/material.dart';

void main() {
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
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.black
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
          floatingLabelStyle: TextStyle(color: Colors.blue),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Colors.white
        ),
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        textTheme: TextTheme(
          bodyLarge: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          bodySmall: TextStyle(color: Colors.white.withOpacity(0.5)),
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ArtDirect', style: TextStyle(fontWeight: FontWeight.w900),),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search,), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'Add a Post'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Inbox')
        ]),
        body: const Center(
          child: Home(),
        ),
      ),
    );
  }
}