import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


// Some Functions and widgets that help give information based on usecase.
class PostFromFirebase {
  CollectionReference postRef = FirebaseFirestore.instance.collection('posts');

  Future<List> getPostList() {
    return postRef.get()
      .then((querySnap) {
          return querySnap.docs.map((doc) => doc.data()).toList();
        }
      );
  }

  Future<int> getPostLength() async {
    return await getPostList().then((value) => value.length);
  }
}

class UserFromFirebase {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  Future<List> getUserList() {
    return userRef.get()
      .then((querySnap) {
        return querySnap.docs.map((doc) => doc.data()).toList();
      }
    );
  }

  Future<int> getUserLength() async {
    return await getUserList().then((value) => value.length);
  }

  Future<dynamic> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser == null ? 
      'user-is-not-available' : 
      userRef.doc(FirebaseAuth.instance.currentUser!.uid).get()
        .then((querySnap) {
            return querySnap.data();
          }
        );
  }
}

// Home content data stream for posts
Stream<dynamic> homeContentStream(Stream<QuerySnapshot> source) async* {

  // Initialize post list and current post count outside of loop to prevent re-initializing.
  List<Map<String, dynamic>> postList = [];
  int currentPostCount = 0;

  // Wait for when source is subscribed into then iterate over data per snapshot in source
  await for (final QuerySnapshot data in source) {

    // Initialize dynamic variable [docs] from data.docs for easier manipulation.
    dynamic docs = data.docs;

    // Data conversion.
    for (int i = currentPostCount; i < docs.length; i++) { 

      // Tell current post count to be the same as index.
      currentPostCount = i;

      // Initialize a map for building our data structure.
      Map<String, dynamic> postContent = {};

      // Push data into map [postContent] from post data in firebase.
      postContent.addAll(docs[i].data() as Map<String, dynamic>); 

      // Getting document references and media location from firebase.
      DocumentSnapshot authorObject = await docs[i].get('author').get();
      List<dynamic> mediaList = await docs[i].get('postMedia');

      // Initializing nn array for our media list.
      List<String> urlMediaList = [];

      // Conversion of media to URL.
      String profilePictureURL = await FirebaseStorage.instance.ref(authorObject['profile picture']).getDownloadURL();
      for (final item in mediaList) {
        urlMediaList.add(await FirebaseStorage.instance.ref(item).getDownloadURL());
      }

      // Pushing to an array author name and handle.
      List<String> authorIdentity = [authorObject['handle'], authorObject['nickname']];

      // Updating and adding keys from our map to their converted values.
      postContent['author'] = authorIdentity;
      postContent['author picture'] = profilePictureURL;
      postContent['postMedia'] = urlMediaList;

      // Pushing to array the completed postContent structure [Map]
      postList.add(postContent);

      // Yield post list to use for home content.
      yield postList;
    }
  }
}

// Home content data stream for posts
Stream<dynamic> commentStream(Stream<DocumentSnapshot<Map<String, dynamic>>> source) async* {

  // Initialize discussion list and current discussion count outside of loop to prevent re-initializing.
  List<Map<String, dynamic>> discussionList = [];
  int currentDicussionCount = 0;

  // Wait for when source is subscribed into then iterate over data per snapshot in source
  await for (final data in source) {

    dynamic comments = data.data()?['discussion'];

    for (int i = currentDicussionCount; i < comments.length; i++) {
      currentDicussionCount = i;

      Map<String, dynamic> commentFinal = {};
      DocumentSnapshot commentRaw = await comments[i].get();
      
      commentFinal.addAll(commentRaw.data() as Map<String, dynamic>);

      DocumentSnapshot authorObject = await commentRaw['author'].get();

      String profilePictureURL = await FirebaseStorage.instance.ref(authorObject['profile picture']).getDownloadURL();
      List<String> authorIdentity = [authorObject['handle'], authorObject['nickname']];

      commentFinal['author'] = authorIdentity;
      commentFinal['author picture'] = profilePictureURL;

      discussionList.add(commentFinal);

      yield discussionList;
    }
  }
}

getImage(ref) {
  return FutureBuilder(
    future: FirebaseStorage.instance.ref(ref).getDownloadURL(),
    builder: (context, AsyncSnapshot snapshot) => 
      snapshot.hasData ? 
        Image.network(snapshot.data, fit: BoxFit.cover,) : 
        const CircularProgressIndicator()
  );
}

Future<dynamic> getDocument(DocumentReference ref) {
  return ref.get()
    .then((docSnap) {
      return docSnap.data();
    }
  );
}

Future<bool> docCheckExist(String ref) async {
  try {
    return FirebaseFirestore.instance.doc(ref).get()
    .then((document) => document.exists);
  } catch (err) {
    return false;
  }
}

void addComment(comment, uid, postReference) {
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference commentCollection = db.collection('post comments');

  Map<String, dynamic> commentData = {
    'author': FirebaseFirestore.instance.doc('users/$uid'),
    'creation': Timestamp.now(),
    'message': comment,
    'popularity': 1,
    'origin': FirebaseFirestore.instance.doc('posts/$postReference')
  };

  commentCollection.add(commentData)
  .then((docRef) {
    db.doc('posts/$postReference').update(
      {'discussion': FieldValue.arrayUnion([docRef])}
    );
  });  
}

void createAccount(uid) {
  
}