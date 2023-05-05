import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/firebase/backend_helpers.dart';
import 'package:final_project_art_direct/miscellaneous/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../miscellaneous/helper_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> postTitle = ['test'];
  List<String> postDescription = ['This is a description of the current post'];
  List<String> postAuthorName = ['John Doe'];
  List<String> postAuthorHandlle = ['@johnny_doe'];
  List<String> postAuthorPicture = ['https://picsum.photos/1920/1080?random=1'];
  List<String> postImageLink = ['https://firebasestorage.googleapis.com/v0/b/artidirect-305ac.appspot.com/o/user%2FWoOJifrP3CeZngW7wlSNArtcmMq2%2Fimages%2FRed.png?alt=media&token=67e0f8d2-5fae-496a-9896-a7d6f1916e1a'];
  List<int> postLikes = [32];
  List<int> postComments = [23];

  int count = 0;

  Future getCount() async {
    Post().getPostLength().then(
      (val) {
        setState(() {
          count = val;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    Post posts = Post();



    return MaterialApp(
      title: 'ArtDirect',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.black
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
        endDrawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 30, 37, 55),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Text('test'),
              ),
              const HorSpacerWithOptText(),
              SocialLoginButton(
                iconDirectory: 'assets/icons/navigation/add_post.svg',
                textButton: 'test',
                onTap: () {
                  FirebaseFirestore.instance.collection('posts').add(
                    <String, dynamic> {
                      'title': 'A funny thing',
                      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. At volutpat diam ut venenatis. Consectetur adipiscing elit pellentesque habitant. At urna condimentum mattis pellentesque id nibh tortor. Ac tincidunt vitae semper quis lectus nulla at volutpat diam. Est pellentesque elit ullamcorper dignissim cras tincidunt lobortis. Urna molestie at elementum eu facilisis sed. Vitae aliquetnec ullamcorper sit amet risus nullam eget. Integer feugiat scelerisque varius morbi enim nunc faucibus. Adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Pellentesque id nibh tortor id aliquet lectus proin nibh. Malesuada fames ac turpis egestas integer eget aliquet nibh praesent. Ullamcorper malesuada proin libero nunc consequat interdum varius. Dolor sit amet consectetur adipiscing elit ut. Eget felis eget nunc lobortis mattis aliquam. Quis lectus nulla at volutpat diam ut venenatis tellus in. Eget aliquet nibh praesent tristique magna sit amet purus gravida. Turpis massa tincidunt dui ut ornare lectus sit amet est. Accumsan in nisl nisi scelerisque eu ultrices vitae.',
                      'imageIDs': [
                        'user/WoOJifrP3CeZngW7wlSNArtcmMq2/images/red.png',
                      ],
                      'author': ['John Doe', '@johnny_doe'],
                      'popularity': 42,
                      'discussion': ['post comments/LyNmZ6gGe2PQnhRwUpDa'],
                      'creation': Timestamp.now()
                    }
                  );
                }
              )
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black
          ),
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black
                ),
                child: Column(
                  children: [
                    Image.network(postImageLink[index]),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: Image.network(getImageUrl(posts.getPostList()[index]['postMedia'][0]) as String, fit: BoxFit.cover,),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(posts.getPostList()[index]['author'][0], style: Theme.of(context).textTheme.bodyMedium),
                                Text(posts.getPostList()[index]['author'][1], style: Theme.of(context).textTheme.bodySmall)
                              ],
                            )
                          ),
                          const Icon(Icons.thumb_up_alt_outlined),
                          const SizedBox(width: 15,),
                          const Icon(Icons.message_outlined),     
                          const SizedBox(width: 15,),       
                          const Icon(Icons.share)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(postDescription[index], style: Theme.of(context).textTheme.bodySmall,),
                            const SizedBox(height: 20,),
                            Text('${posts.getPostList()[index]['popularity']} Likes', style: Theme.of(context).textTheme.bodyLarge,),
                            const SizedBox(height: 20,),
                            Text('View Comments (${postComments[index]})', style: Theme.of(context).textTheme.bodyLarge,),
                            const SizedBox(height: 10,),
                            Text('3 weeks ago', style: Theme.of(context).textTheme.bodySmall,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        )
      ),
    );
  }
}