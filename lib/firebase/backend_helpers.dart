import 'package:cloud_firestore/cloud_firestore.dart';


// Some Functions and widgets that return information based on usecase.

dynamic getPostList() {
  return FirebaseFirestore.instance.collection('posts').get()
    .then((querySnap) { 
      return querySnap.docs.map((doc) => doc.data()).toList();
    } );
}