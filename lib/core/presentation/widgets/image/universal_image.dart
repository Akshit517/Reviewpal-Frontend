import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

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

  Future<bool> _isSvg(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      final contentType = response.headers['content-type'] ?? '';
      return contentType.contains('svg');
    } catch (e) {
      return false; // Assume it's not an SVG in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isSvg(imageUrl),
      builder: (context, snapshot) {
        // While waiting for the response
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If there's an error or no data
        if (snapshot.hasError || snapshot.data == null) {
          return const Icon(Icons.error, color: Colors.red);
        }

        // Based on the result, render the appropriate widget
        bool isSvg = snapshot.data!;
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
                    placeholderBuilder: (context) =>
                        const Center(child: CircularProgressIndicator()),
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
      },
    );
  }
}
