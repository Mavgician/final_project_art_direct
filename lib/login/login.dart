import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: AlignmentDirectional.topCenter,
          decoration: const BoxDecoration(
              image: DecorationImage(image: NetworkImage('https://picsum.photos/1920/1080'),
              fit: BoxFit.cover
            ),
          ),
        ),
        Container(
          alignment: AlignmentDirectional.bottomCenter,
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            children: const [
              Text('hello'),
              Text('hello'),
              Text('hello'),
              Text('hello')
            ],
          ),
        )
      ],
    );
  }
}

/* class ButtonBigRounded extends StatefulWidget {

}
 */