import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/firebase/backend_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Authentication using firebase

class AuthService {
  // Initialize firebase authentication as an instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  Future<String?> getCurrentUID() async {
    return _firebaseAuth.currentUser?.uid;
  }

  // Checks if account is in the database. If it's available it returns true and vice versa.
  Future<bool> checkAccount(account) async {
    if (await docCheckExist('users/$account')) { return true; }
    else { return false; }
  }

  // Sign in method that calls firebase's google auth
  signInGoogle() async {

    // Authentication request
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();

    if (googleUser != null) {
      // Authentication details from initial request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential/account for app
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      // Return user credential to Firebase authentication to sign in properly with google
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    return null;
  }

  signInEmailPassword(String emailAddress, String password, context) async {

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 0;
      } else if (e.code == 'user-disabled') {
        return 1;
      } else if (e.code == 'user-not-found') {
        return 2;
      } else if (e.code == 'wrong-password') {
        return 3;
      }
    } catch (err) {
      return 4;
    }
  }

  // Sign in method for email
  signUp(emailAddress, password, [passwordConfirmation, userHandle, displayName, context]) async {
    try {
      final dynamic userHandleMatchList =
        (await _firebaseFirestore.collection('users').where('handle', isEqualTo: userHandle).get()).docs;

      if (userHandleMatchList.length > 0) {
        return 2;
      } else if (userHandle.isEmpty) {
        return null;
      }

      if (password == passwordConfirmation) {
        final firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );

        final Map<String, dynamic> userMap = {
          'following': [],
          'followers': [],
          'likes': [],
          'posts': [],
          'handle': userHandle,
          'nickname': displayName,
          'profile picture': '/account template/no-profile.png',
          'biography': 'Hi I am new, please be nice to me!'
        };

        _firebaseFirestore.collection('users').doc('${firebaseUser.user?.uid}').set(userMap);

        if (context != null) {
          Navigator.pop(context);
        }
      }

      return null;

    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        return 0;
      } else if (err.code == 'email-already-in-use') {
        final credential = EmailAuthProvider.credential(email: emailAddress, password: password);

        final userCredential = await _firebaseAuth.currentUser?.linkWithCredential(credential);

        if (userCredential == null) return 10;

        final Map<String, dynamic> userMap = {
          'following': [],
          'followers': [],
          'likes': [],
          'posts': [],
          'handle': userHandle,
          'nickname': displayName,
          'profile picture': '/account template/no-profile.png',
          'biography': 'Hi I am new, please be nice to me!'
        };

        _firebaseFirestore.collection('users').doc('${userCredential.user?.uid}').set(userMap);

        signOut();
        _firebaseAuth.signInWithEmailAndPassword(email: emailAddress, password: password);
        
        return 1;
      }
    } catch (err) {
      return 3;
    }
  }

  // Sign out method
  signOut() async {
    try {
      // Sign out from application.
      _firebaseAuth.signOut();

      // Disconnect current user instance to force account selection on sign in if google provider is used.
     await _googleSignIn.disconnect();
    } catch (e) {
      
      // Sign out from application.
      _firebaseAuth.signOut();
    }
    
  }
}