import 'package:final_project_art_direct/miscellaneous/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:final_project_art_direct/miscellaneous/buttons.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';

import 'package:final_project_art_direct/firebase/backend_helpers.dart';

// Widgets for necessary components for home and other pages.
class BotNav extends StatefulWidget {
  const BotNav(
    {
      super.key,
      required this.currentIndex,
      required this.onTap
    }
  );

  final int currentIndex;
  final Function(int index)? onTap;

  @override
  State<BotNav> createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), label: 'Home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search,), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add a Post'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Inbox')
    ]);
  }
}

PreferredSizeWidget topBar({title = 'ArtDirect', BuildContext? context}) {
  return AppBar(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900),),
    leading: context == null ? 
      null :
      BackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      )
  );
}

class CommentBar extends StatefulWidget {
  const CommentBar(
    {
      super.key,
      required this.postID,
      required this.onSend,
      this.locallyAddComment,
      this.focusOnTextField = false,
    }
  );

  final String postID;
  final dynamic onSend, locallyAddComment;
  final bool focusOnTextField;

  @override
  State<CommentBar> createState() => _CommentBarState();
}

class _CommentBarState extends State<CommentBar> {

  final textController = TextEditingController();
  String messageData = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container (
        height: 100,
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: textController,
          autofocus: widget.focusOnTextField,
          decoration: InputDecoration(
            labelText: 'Comment',
            labelStyle: const TextStyle(color: Colors.white),
            suffixIcon: IconButton(
              onPressed: () {
                if (messageData.isNotEmpty) {
                  widget.locallyAddComment(addComment(messageData, FirebaseAuth.instance.currentUser!.uid, widget.postID));
                  FocusManager.instance.primaryFocus?.unfocus();
                  textController.clear();
                  messageData = '';
                }
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
          onChanged: (value) => setState(() => { messageData = value }),
        ),
      )
    );
  }
}

Widget sideDrawer(context) {
  UserFromFirebase user = UserFromFirebase();

  Future<dynamic> convertAuthorFuture() async{
    Map<String, dynamic> convertedMap = {};
    Map<String, dynamic> userMap = await user.getCurrentUser();

    List<String> authorIdentity = [userMap['handle'], userMap['nickname']];
    String profilePicture = await firebaseStorageToURL(userMap['profile picture']);

    List<dynamic> following = userMap['following'], followers = userMap['followers'];

    convertedMap.addAll(userMap);

    convertedMap['author'] = authorIdentity;
    convertedMap['profile picture'] = profilePicture;
    convertedMap['following'] = following;
    convertedMap['followers'] = followers;

    return convertedMap;
  }

  return Drawer(
    backgroundColor: const Color.fromARGB(255, 30, 37, 55),
    child: Column (
      children: [
        DrawerHeader(
          child: FutureBuilder(
            future: convertAuthorFuture(),
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData ?
              Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(snapshot.data['profile picture']),
                  ),
                  addVerticalSpace(10),
                  Text(snapshot.data['nickname'], style: Theme.of(context).textTheme.bodyMedium,),
                  Text(snapshot.data['handle'], style: Theme.of(context).textTheme.bodySmall,),
                  addVerticalSpace(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${snapshot.data['following'].length}  Following', style: Theme.of(context).textTheme.bodySmall,),
                      addHorizontalSpace(20),
                      Text('${snapshot.data['followers'].length}  Followers', style: Theme.of(context).textTheme.bodySmall,),
                    ],
                  )
                ],
              ) : const Center(child: CircularProgressIndicator(),);
            }
          ),
        ),
        /* SocialLoginButton(
          iconDirectory: 'assets/icons/navigation/add_post.svg',
          text: 'test',
          onTap: () {
            FirebaseFirestore.instance.collection('posts').add(
              <String, dynamic> {
                'title': 'A funny thing',
                'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. At volutpat diam ut venenatis. Consectetur adipiscing elit pellentesque habitant. At urna condimentum mattis pellentesque id nibh tortor. Ac tincidunt vitae semper quis lectus nulla at volutpat diam. Est pellentesque elit ullamcorper dignissim cras tincidunt lobortis. Urna molestie at elementum eu facilisis sed. Vitae aliquetnec ullamcorper sit amet risus nullam eget. Integer feugiat scelerisque varius morbi enim nunc faucibus. Adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Pellentesque id nibh tortor id aliquet lectus proin nibh. Malesuada fames ac turpis egestas integer eget aliquet nibh praesent. Ullamcorper malesuada proin libero nunc consequat interdum varius. Dolor sit amet consectetur adipiscing elit ut. Eget felis eget nunc lobortis mattis aliquam. Quis lectus nulla at volutpat diam ut venenatis tellus in. Eget aliquet nibh praesent tristique magna sit amet purus gravida. Turpis massa tincidunt dui ut ornare lectus sit amet est. Accumsan in nisl nisi scelerisque eu ultrices vitae.',
                'postMedia': [
                  '/users/WoOJifrP3CeZngW7wlSNArtcmMq2/post media/Red.png',
                ],
                'author': FirebaseFirestore.instance.doc('users/${FirebaseAuth.instance.currentUser!.uid}'),
                'popularity': 42,
                'discussion': [FirebaseFirestore.instance.doc('post comments/LyNmZ6gGe2PQnhRwUpDa')],
                'creation': Timestamp.now()
              }
            ).then((docRef) {
              FirebaseFirestore.instance.collection('posts').doc(docRef.id).update(
                {'id': docRef.id}
              );
            });
          }
        ), */
        ListTile(
          title: const Text('Profile'),
          leading: const Icon(Icons.person),
          iconColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Settings'),
          leading: const Icon(Icons.settings),
          iconColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Help'),
          leading: const Icon(Icons.info),
          iconColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          onTap: () {},
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: ListTile(
              title: const Text('Log Out'),
              leading: const Icon(Icons.door_back_door_outlined),
              iconColor: Colors.red,
              textColor: Colors.red,
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () async {
                AuthService().signOut();
                Navigator.of(context)
                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthService().handleAuthState()), (Route route) => false);
              },
            ),
          )
        )
      ],
    ),
  );
}

profilePictureFromAuthorRef(ref) {
  try {
    return FutureBuilder(
      future: getDocument(ref),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(),);
        } else {
          return getImage(snapshot.data['profile picture']);
        }
      }
    );
  } catch (err) {
    // TODO handle error by implementing an error page.
    return const Placeholder();
  }
}