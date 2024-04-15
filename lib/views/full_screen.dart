import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final int likes;
  final int views;

  FullScreenImage(
      {required this.imageUrl, required this.likes, required this.views});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
            child: Hero(
                tag: imageUrl,
                child: Image.network(imageUrl, fit: BoxFit.cover))),
      ),
    );
  }
}
