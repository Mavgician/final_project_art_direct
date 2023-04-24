import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/home/home.dart';
import 'package:final_project_art_direct/user/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Authentication using firebase

class AuthService {

  // Initialize firebase database as an instance
  FirebaseFirestore dataBase = FirebaseFirestore.instance;

  // Initialize firebase authentication as an instance
  FirebaseAuth auth = FirebaseAuth.instance;

  // Method that checks if user is currently logged into app. If true continue to home, else continue to login.
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return const Home();
        } else {
          return const Login();
        }
      },
    );
  }

  // Sign in method that calls firebase's google auth
  signInGoogle() async {

    var currUser = dataBase.collection('users').doc(auth.currentUser!.uid);

    // Authentication request
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();

    // Authentication details from initial request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential/account for app
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    /* currUser.get()
      .then((document) => {
        if (!document.exists) {
          Navigator.push
        }
      }); */

    // Return user credential to Firebase authentication to sign in properly with google
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sign out method
  signOut() { FirebaseAuth.instance.signOut(); }
}