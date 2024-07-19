// lib/widgets/image_grid.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:parking_app/services/api_service.dart';

class ImageGrid extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGrid({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: "${ApiService.apiUrl}/${imageUrls[index]}",
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
    );
  }
}
