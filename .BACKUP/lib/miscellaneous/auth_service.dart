import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/firebase/backend_helpers.dart';
import 'package:final_project_art_direct/home/home.dart';
import 'package:final_project_art_direct/user/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:final_project_art_direct/user/sign_up.dart';

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
        print(snapshot.data);
        if (snapshot.hasData) {
          return FutureBuilder(
            future: checkAccount(auth.currentUser!.uid),
            builder: (context, AsyncSnapshot snapshotInner) {
              if (snapshotInner.hasData) {
                if (!snapshotInner.data) { return const SignUp(); }
                else { return const Home(); }
              } else { return const Center(child: CircularProgressIndicator()); }
            }
          );
        } else {
          return const Login();
        }
      },
    );
  }

  // Checks if account is in the database. If it's available it returns true and vice versa.
  checkAccount(account) async {
    if (await docCheckExist('users/$account')) { return true; }
    else { return false; }
  }

  // Sign in method that calls firebase's google auth
  signInGoogle() async {

    // Authentication request
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();

    // Authentication details from initial request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential/account for app
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    
    // Return user credential to Firebase authentication to sign in properly with google
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sign out method
  signOut() { 
    // If an error occurs that means there is no current user logged in so we do nothing when we catch the error.
    try {
      // Disconnect current user instance to force account selection on sign in if google provider is used.
      GoogleSignIn().disconnect();

      // Sign out from application.
      auth.signOut();
    } finally { }
  }
}