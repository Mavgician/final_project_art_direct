import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List<String> postImageLink = ['https://picsum.photos/1920/1080?random=2'];
  List<int> postLikes = [32];
  List<int> postComments = [23];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: ListView.builder(
        itemCount: 1,
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
                          child: Image.network(postAuthorPicture[index], fit: BoxFit.cover,),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(postAuthorName[index], style: Theme.of(context).textTheme.bodyMedium),
                            Text(postAuthorHandlle[index], style: Theme.of(context).textTheme.bodySmall)
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
                        Text('${postLikes[index]} Likes', style: Theme.of(context).textTheme.bodyLarge,),
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
    );
  }
}