import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UniversalImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const UniversalImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = imageUrl.toLowerCase().endsWith('.svg') || Uri.parse(imageUrl).path.endsWith('svg');

return LayoutBuilder(
      builder: (context, constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;

        return isSvg
            ? SvgPicture.network(
                imageUrl,
                width: width ?? parentWidth, 
                height: height ?? parentHeight, 
                fit: fit ?? BoxFit.cover,
                placeholderBuilder: (context) => const Center(child: CircularProgressIndicator()),
              )
            : Image.network(
                imageUrl,
                width: width ?? parentWidth, 
                height: height ?? parentHeight,
                fit: fit ?? BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              );
      },
    );
  }
}