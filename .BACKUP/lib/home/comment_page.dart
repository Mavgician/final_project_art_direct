import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_art_direct/firebase/backend_helpers.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'component_widgets.dart';

import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatefulWidget {
  const CommentPage(
    {
      super.key,
      required this.comment,
      required this.postID,
      this.focusOnNavigate = false,
    }
  );

  final dynamic comment, postID;
  final bool focusOnNavigate;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  final scrollController = ScrollController();

  List _commentMainList = [];
  int currentListIndex = 0;
  int maxCommentCount = 0;

  bool isEnd = false;

  Future<List> fetchComment(List commentRefList, int searchLimit) async {
    List convertedList = [];

    int limit = commentRefList.length;

    if ((currentListIndex == commentRefList.length - 1) &&
        commentRefList.length != 1) { 
      return convertedList;
    }

    if (commentRefList.length > searchLimit) {
      if (currentListIndex == 0) {
        limit = searchLimit;
      } else if (currentListIndex + searchLimit > commentRefList.length) {
        currentListIndex += 1;
        limit = commentRefList.length;
      } else if (currentListIndex + searchLimit < commentRefList.length) {
        currentListIndex += 1;
        limit = currentListIndex + searchLimit;
      }
    }

    for (int i = currentListIndex; i < limit; i++) {

      Map<String, dynamic> convertedComRef = {};
      DocumentSnapshot rawComment = await commentRefList[i].get();

      DocumentSnapshot authorObject = await rawComment.get('author').get();

      List<String> author = [authorObject['handle'], authorObject['nickname']];
      String profilePictureURL = await firebaseStorageToURL(authorObject['profile picture']);

      convertedComRef.addAll(rawComment.data() as Map<String, dynamic>);

      convertedComRef['author'] = author;
      convertedComRef['author picture'] = profilePictureURL;

      convertedList.add(convertedComRef);
      currentListIndex = i;
    }
    
    return convertedList;
  }

  Future<void> getComments(Map<String,dynamic>? localComment) async {
  
    setState(() {
      isEnd = false;
    });
    
    if (localComment != null) {
      currentListIndex = _commentMainList.length;

      DocumentSnapshot authorObject = await localComment['author'].get();

      List<String> author = [authorObject['handle'], authorObject['nickname']];
      String profilePictureURL = await firebaseStorageToURL(authorObject['profile picture']);

      localComment['author'] = author;
      localComment['author picture'] = profilePictureURL;

      _commentMainList.insert(0, localComment);
      maxCommentCount += 1;
    } else {
      _commentMainList = [];
      currentListIndex = 0;
    }
    
    updateList(widget.comment, 5);
  }

  void getNextComments() {
    updateList(widget.comment, 5);
  }

  void updateList(List list, int limit) {
    fetchComment(list, limit)
    .then((value) {
      if (value.isEmpty) {
        setState(() { isEnd = true; });
      } else if (value.length < limit) {
        setState(() { isEnd = true; });
        setState(() {
          for (final data in value) {
            _commentMainList.add(data);
          }
        });
      } else {
        setState(() {
          for (final data in value) {
            _commentMainList.add(data);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getComments(null);

    maxCommentCount = widget.comment.length;

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          getNextComments();
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtDirect',
      theme: commentPageTheme,
      home: Scaffold(
        appBar: topBar(title: 'Comments ($maxCommentCount)', context: context),
        bottomNavigationBar: CommentBar(postID: widget.postID, onSend: addComment, locallyAddComment: getComments, focusOnTextField: widget.focusOnNavigate,),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: RefreshIndicator( 
            onRefresh: () async {
              getComments(null);
            },
            child: LayoutBuilder(
              builder: (context, constraints) => ListView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _commentMainList.length + 1,
                itemBuilder: (context, index) {
                  if ((index == _commentMainList.length) && !isEnd) {
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
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  } else if ((index == _commentMainList.length) && isEnd) {
                    return const SizedBox();
                  } else {
                    return IndividualComment(
                      profilePicture: _commentMainList[index]['author picture'],
                      author: _commentMainList[index]['author'],
                      creation: _commentMainList[index]['creation'],
                      message: _commentMainList[index]['message'],
                      popularity: _commentMainList[index]['popularity']
                    );
                  }
                }
              ),
            ),
          ),
        )
      )
    );
  }
}

class IndividualComment extends StatelessWidget {
  const IndividualComment(
    {
      super.key,
      required this.profilePicture,
      required this.author,
      required this.creation,
      required this.message,
      required this.popularity,
    }
  );

  final String profilePicture, message;
  final int popularity;
  final dynamic author, creation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(profilePicture),
              ),
              addHorizontalSpace(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(author[1], style: Theme.of(context).textTheme.bodyLarge),
                            Text(author[0], style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        addVerticalSpace(10),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(timeago.format(creation.toDate()), style: Theme.of(context).textTheme.bodySmall)
                          )
                        ),
                      ],
                    ),
                    addVerticalSpace(20),
                    Text(message, style: Theme.of(context).textTheme.bodyMedium),
                    addVerticalSpace(10),
                    Row(
                      children: [
                        CommentPopularity(popularity: popularity),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text('Share', style: Theme.of(context).textTheme.bodyLarge,)
                        )
                      ],
                    ),
                    
                  ],
                ),
              )
            ]
          ),
        ),
      ),
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