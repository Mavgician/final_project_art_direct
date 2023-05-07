import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/home/comment_page.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:flutter/material.dart';

import 'package:final_project_art_direct/firebase/backend_helpers.dart';

import 'package:final_project_art_direct/home/component_widgets.dart';

import 'package:final_project_art_direct/miscellaneous/themes.dart';

import 'package:timeago/timeago.dart' as timeago;


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<Widget> _pages = const [
    HomePage(),
    Icon(
      Icons.search,
      size: 150,
    ),
    Icon(
      Icons.image,
      size: 150,
    ),
    Icon(
      Icons.notifications,
      size: 150,
    ),
    Icon(
      Icons.mail,
      size: 150,
    ),
  ];

  int _selectedIndex = 0;
  
  void onItemPress(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtDirect',
      theme: homeTheme,
      home: Scaffold(
        appBar: topBar(),
        bottomNavigationBar: BotNav(currentIndex: _selectedIndex, onTap: onItemPress,),
        endDrawer: sideDrawer(context),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        )
        
      )
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scrollController = ScrollController();

  bool isEnd = false;

  List _postMainList = [];
  late QuerySnapshot postCollectionState;

  void updateList(collectionRef) {
    fetchPost(collectionRef)
    .then((value) {
      if (value.isEmpty) {
        setState(() { isEnd = true; });
      } else {
        setState(() {
          for (final data in value) {
            _postMainList.add(data);
          }
        });
      }
    });
  }

  void getNextPosts() {
    if (postCollectionState.docs.isEmpty) {
    } else {
      var lastVisible = postCollectionState.docs[postCollectionState.docs.length - 1];
      var postCollection = FirebaseFirestore.instance.collection('posts').startAfterDocument(lastVisible).limit(2);
      updateList(postCollection);
    }
  }

  Future<void> getPosts() async {
    var postCollection = FirebaseFirestore.instance.collection('posts').limit(5);
    setState(() { _postMainList = []; });
    setState(() { isEnd = false; });
    updateList(postCollection);
  }
  
  Future<List> fetchPost(Query postCollection) async {
    List postList = [];
    QuerySnapshot posts = await postCollection.get();

    postCollectionState = posts;

    for (final post in posts.docs) {
      Map<String, dynamic> convertedPost = {};
      
      convertedPost.addAll(post.data() as Map<String, dynamic>);

      DocumentSnapshot authorObject = await post.get('author').get();
      List<dynamic> mediaList = post.get('postMedia');

      List<String> urlMediaList = [];

      String profilePictureURL = await firebaseStorageToURL(authorObject['profile picture']);
      for (final media in mediaList) {
        urlMediaList.add(await firebaseStorageToURL(media));
      }

      List<String> author = [authorObject['handle'], authorObject['nickname']];

      convertedPost['author'] = author;
      convertedPost['author picture'] = profilePictureURL;
      convertedPost['postMedia'] = urlMediaList;

      postList.add(convertedPost);
    }
    
    return postList;
  }

  @override
  void initState() {
    super.initState();
    getPosts();

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          getNextPosts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getPosts,
      child: LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _postMainList.length + 1,
          itemBuilder: (context, index) {
            if ((index == _postMainList.length) && !isEnd) {
              if (index == 0) {
                return SizedBox (
                  height: constraints.maxHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            } else if ((index == _postMainList.length) && isEnd) {
              return Container(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 17, 17, 17)
                  ),
                  child: const Center(
                    child: Text('no more posts to show :('),
                  ),
                );
            } else {
              return IndividualPost(
                media: _postMainList[index]['postMedia'],
                author: _postMainList[index]['author'],
                authorPicture: _postMainList[index]['author picture'],
                description: _postMainList[index]['description'],
                discussion: _postMainList[index]['discussion'],
                popularity: _postMainList[index]['popularity'],
                creation: _postMainList[index]['creation'],
                id: _postMainList[index]['id'],
              );
            }
          }
        ),
      )
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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.authorPicture),
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
                IconButton(onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) {
                        return CommentPage(
                          comment: widget.discussion,
                          postID: widget.id,
                          focusOnNavigate: true,
                        );
                      } 
                    )
                  );
                }, icon: const Icon(Icons.message_outlined)),
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
                  (
                    widget.description.length == 0 ? // Ternary for checking description length. If description exists add spacing, if not remove spacing.
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
                  StreamBuilder(
                    stream: commentStream(FirebaseFirestore.instance.collection('posts').doc(widget.id).snapshots()),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('View Comments (0)', style: Theme.of(context).textTheme.bodyLarge,)
                        );
                      } else {
                        return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return CommentPage(
                                  comment: snapshot.data,
                                  postID: widget.id,
                                );
                              }),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text('View Comments (${snapshot.data.length})', style: Theme.of(context).textTheme.bodyLarge,)
                        );
                      }
                    } 
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