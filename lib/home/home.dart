import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/home/comment_page.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:final_project_art_direct/firebase/backend_helpers.dart';

import 'package:final_project_art_direct/home/component_widgets.dart';

import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:timeago/timeago.dart' as timeago;


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO Deprecate home stream to give way for lazy loading and state management

  // Initialize Post from backend_helpers to access functions that get data from firebase. In this case collection of post.
  Stream<dynamic> postsStream = homeContentStream(FirebaseFirestore.instance.collection('posts').snapshots());

  // Function for data refresh.
  Future<void> refresh() async {
    fetchPost(FirebaseFirestore.instance.collection('posts'));
    setState(() {
      postsStream = homeContentStream(FirebaseFirestore.instance.collection('posts').snapshots());
    });
  }  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtDirect',
      theme: homeTheme,
      home: Scaffold(
        appBar: topBar(),
        bottomNavigationBar: const BotNav(),
        endDrawer: sideDrawer(context),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: StreamBuilder(
            stream: postsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) { return const Center(child: CircularProgressIndicator(),); }
              else {
                return PostMain(posts: snapshot.data, postsLength: snapshot.data!.length);
              }
            },
          )
        )
      )
    );
  }

  List postList = [];
  late QuerySnapshot postCollectionState;

  fetchPost(Query postCollection) {
    postCollection.get().then((value) {
      postCollectionState = value;
      for (final post in value.docs) {
        print(post['author']);
      }
    });
  }

  /* Future<void> getPost() {
    
  } */

}

class PostMain extends StatelessWidget {
  const PostMain(
    {
      super.key,
      required this.posts,
      required this.postsLength,
    }
  );

  final dynamic posts;
  final int postsLength;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: postsLength,
      itemBuilder: (context, index) {
        return IndividualPost(
          media: posts[index]['postMedia'],
          author: posts[index]['author'],
          authorPicture: posts[index]['author picture'],
          description: posts[index]['description'],
          discussion: posts[index]['discussion'],
          popularity: posts[index]['popularity'],
          creation: posts[index]['creation'],
          id: posts[index]['id'],
        );
      }
    );
  }
}

class IndividualPost extends StatefulWidget {
  const IndividualPost(
    {
      super.key,
      required this.media,
      required this.author,
      required this.authorPicture,
      required this.description,
      required this.discussion,
      required this.popularity,
      required this.creation,
      required this.id,
    }
  );

  final dynamic media, author, authorPicture, description, discussion, popularity, creation, id;

  @override
  State<IndividualPost> createState() => _IndividualPostState();
}

class _IndividualPostState extends State<IndividualPost> {

  int currentPopularity = 0;
  bool liked = false;

  likeState() {
    if (liked) { return const Icon(Icons.thumb_up) ; }
    else if (!liked) { return const Icon(Icons.thumb_up_alt_outlined) ; }
  }

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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: Column(
        children: [
          Image.network(widget.media[0]),
          addVerticalSpace(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipOval(
                    child: Image.network(widget.authorPicture),
                  ),
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.author[1], style: Theme.of(context).textTheme.bodyMedium),
                      Text(widget.author[0], style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                ),
                IconButton(
                  onPressed: addLikes,
                  icon: likeState()
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.message_outlined)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              ],
            )
          ),
          addVerticalSpace(20),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ( widget.description.length == 0 ? // Ternary for checking description length. If description exists add spacing, if not remove spacing.
                      addVerticalSpace(0) :
                      Column(
                        children: [
                          Text(widget.description, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis, maxLines: 4,),
                          addVerticalSpace(20)
                        ],
                      )
                  ),
                  Text('$currentPopularity Likes', style: Theme.of(context).textTheme.bodyLarge,),
                  addVerticalSpace(20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                          CommentPage(
                            comment: widget.discussion,
                            commentLength: widget.discussion.length,
                            postID: widget.id,
                          )
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text('View Comments (${widget.discussion.length})', style: Theme.of(context).textTheme.bodyLarge,),
                  ),
                  Text(timeago.format(widget.creation.toDate()), style: Theme.of(context).textTheme.bodySmall,)
                ],
              ),
            ),
          ),
          addVerticalSpace(50),
        ],
      ),
    );
  }
}


