import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../app/theme/app_theme.dart';

class NetImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;

  const NetImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: AppTheme.primaryLight,
      borderRadius: BorderRadius.circular(radius),
    );
    if (url == null || url!.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: decoration,
        child: const Icon(Icons.store, color: AppTheme.primary),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => Container(
          width: width,
          height: height,
          decoration: decoration,
          child: const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppTheme.primary)),
        ),
        errorWidget: (_, __, ___) => Container(
          width: width,
          height: height,
          decoration: decoration,
          child: const Icon(Icons.store, color: AppTheme.primary),
        ),
      ),
    );
  }
}
