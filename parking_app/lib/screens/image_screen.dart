// lib/screens/image_screen.dart
/*
import 'package:flutter/material.dart';
import 'package:parking_app/services/api_service.dart'; // Remplace 'your_project' par le nom de ton projet
import 'package:parking_app/widgets/image_grid.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late Future<List<String>> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = ApiService().fetchImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
      ),
      body: FutureBuilder<List<String>>(
        future: imageUrls,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No images found'));
          } else {
            return ImageGrid(imageUrls: snapshot.data!);
          }
        },
      ),
    );
  }
}
*/
/*
// lib/screens/image_screen.dart
import 'package:flutter/material.dart';
import 'package:parking_app/services/api_service.dart'; // Remplace 'parking_app' par le nom de ton projet
import 'package:parking_app/widgets/image_grid.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late Future<List<String>> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = ApiService().fetchImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Action pour le bouton menu
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: imageUrls,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          imageUrls = ApiService().fetchImageUrls();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No images found',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImageGrid(imageUrls: snapshot.data!),
              );
            }
          },
        ),
      ),
    );
  }
}
*/
// lib/screens/image_screen.dart
import 'package:flutter/material.dart';
import 'package:parking_app/services/api_service.dart'; // Remplace 'parking_app' par le nom de ton projet
import 'package:parking_app/widgets/image_grid.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late Future<List<String>> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = ApiService().fetchImageUrls();
  }

  void _refreshImages() {
    setState(() {
      imageUrls = ApiService().fetchImageUrls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Images',
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Action pour le bouton menu
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshImages,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: imageUrls,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _refreshImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No images found',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImageGrid(imageUrls: snapshot.data!),
              );
            }
          },
        ),
      ),
    );
  }
}

