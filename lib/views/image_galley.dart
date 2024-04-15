import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'full_screen.dart';

class ImageGallery extends StatefulWidget {
  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  List<dynamic> _images = [];
  bool _loading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    try {
      final response = await Dio().get(
        'https://pixabay.com/api/?key=43405027-2edd63b788d16f7148e97e3ae',
      );

      if (response.statusCode == 200) {
        setState(() {
          _images = response.data['hits'];
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _isError = true;
        });
        throw Exception('Failed to load images');
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _isError = true;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _isError
              ? Center(
                  child: Text('Something went wrong!',
                      style: Theme.of(context).textTheme.titleMedium),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImage(
                              imageUrl: _images[index]['largeImageURL'],
                              likes: _images[index]['likes'],
                              views: _images[index]['views'],
                            ),
                          ),
                        );
                      },
                      child: GridTile(
                        footer: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Likes: ${_images[index]['likes']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Views: ${_images[index]['views']}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        child: Image.network(_images[index]['webformatURL'],
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
    );
  }
}
