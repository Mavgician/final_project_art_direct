import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/firebase/backend_helpers.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'component_widgets.dart';

import 'package:timeago/timeago.dart' as timeago;


class CommentPage extends StatefulWidget {
  const CommentPage(
    {
      super.key,
      required this.comment,
      required this.commentLength,
      required this.postID,
    }
  );

  final dynamic comment, postID;
  final int commentLength;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  String commentData = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtDirect',
      theme: commentPageTheme,
      home: Scaffold(
        appBar: topBar(title: 'Comments', context: context),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container (
            height: 100,
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Comment',
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  onPressed: () {
                    addComment(commentData, FirebaseAuth.instance.currentUser!.uid, widget.postID);
                  },
                  icon: const Icon(Icons.send, color: Colors.white,)
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white
                  )
                ),
              ),
              style: const TextStyle( color: Colors.white ),
              onChanged: (value) => setState(() => { commentData = value }),
              validator: (value) => value!.isEmpty ? 'Please enter Phone, Email Address, or User handle!' : null,
            ),
          )
        ),
        body: StreamBuilder(
          stream: commentStream(FirebaseFirestore.instance.collection('posts').doc(widget.postID).snapshots()),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData || snapshot.data == 'changeDetected') {
              return const Center(child: CircularProgressIndicator(),);
            } else {
              return ListView.builder(
                controller: ScrollController(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipOval(
                                child: Image.network(snapshot.data[index]['author picture']),
                              )
                            ),
                            addHorizontalSpace(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data[index]['author'][1], style: Theme.of(context).textTheme.bodyLarge),
                                Text(snapshot.data[index]['author'][0], style: Theme.of(context).textTheme.bodySmall),
                                addVerticalSpace(10),
                                Text(timeago.format(snapshot.data[index]['creation'].toDate()), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                        addVerticalSpace(20),
                        Text(snapshot.data[index]['message'], style: Theme.of(context).textTheme.bodyMedium),
                        addVerticalSpace(20),
                        Row(
                          children: [
                            CommentPopularity(popularity: snapshot.data[index]['popularity']),
                            TextButton(
                              onPressed: () {
                                addComment('test button for adding comment', FirebaseAuth.instance.currentUser!.uid, widget.postID);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              child: Text('Share', style: Theme.of(context).textTheme.bodyLarge,)
                            )
                          ],
                        )
                      ]
                    ),
                  );
                }
              );
            }
          }
        )
      )
    );
  }
}

class CommentPopularity extends StatefulWidget {
  const CommentPopularity(
    {
      super.key,
      required this.popularity
    }
  );

  final int popularity;

  @override
  State<CommentPopularity> createState() => CommentPopularityState();
}

class CommentPopularityState extends State<CommentPopularity> {

  int currentPopularity = 0;
  bool liked = false;

  void addLikes() {
    setState(() {
      if (liked) {
        liked = false;
        currentPopularity -= 1;
      }
      else if (!liked) {
        liked = true;
        currentPopularity += 1;
      }
    });
  }

  @override
  void initState() {
    currentPopularity = widget.popularity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: addLikes,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text('Like ($currentPopularity)', style: Theme.of(context).textTheme.bodyLarge,)
    );
  }
}