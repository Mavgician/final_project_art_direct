import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';


// Some Functions and widgets that return information based on usecase.
class Post {
  CollectionReference postRef = FirebaseFirestore.instance.collection('posts');

  dynamic getPostList() {
    return postRef.get()
      .then((querySnap) {
          return querySnap.docs.map((doc) => doc.data()).toList();
        }
      );
  }

  dynamic getPostLength() {
    return postRef.get()
      .then((querySnap) {
        int initVal = 0;
        querySnap.docs.forEach((element) => initVal += 1);
        return initVal;
      }
    );
  }
}

Future<String> getImageUrl(ref) async {
  return FirebaseStorage.instance.ref(ref).getDownloadURL().toString();
}