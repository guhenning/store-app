import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:store/utils/cache_manager.dart';

class CustomImageBuilder extends StatelessWidget {
  final String image;
  final BoxFit? fit;

  const CustomImageBuilder({super.key, required this.image, this.fit});

  @override
  Widget build(BuildContext context) {
    return _buildImage(image);
  }

  Widget _buildImage(String image) {
    if (image.startsWith('http') || image.startsWith('https')) {
      final customCacheManager = CacheManagerService.customCacheManager;

      return CachedNetworkImage(
        cacheManager: customCacheManager,
        key: UniqueKey(),
        imageUrl: image,
        fit: BoxFit.fill,
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/no_image_available.webp',
          fit: BoxFit.fill,
        ),
      );
    } else if (File(image).existsSync()) {
      return Image.file(fit: BoxFit.cover, File(image));
    } else {
      return Image.asset('assets/images/no_image_available.webp');
    }
  }
}
