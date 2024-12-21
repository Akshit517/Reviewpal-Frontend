import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/pallete/dark_theme_palette.dart';

class SocialTextButton extends StatelessWidget {
  const SocialTextButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.redirectTo,
    required this.constraints,
  });
  final BoxConstraints constraints;
  final String text;
  final String iconPath;
  final String redirectTo;

  void _launchOAuthUrl(String uri) async {
    Uri url = Uri.parse(uri);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth * 0.90,
      height: 50,
      child: TextButton.icon(
        onPressed: () {
          _launchOAuthUrl(redirectTo);
        },
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: DarkThemePalette.textPrimary,
          ),
        ),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SvgPicture.asset(iconPath, width: 20),
        ),
        style: TextButton.styleFrom(
          backgroundColor: DarkThemePalette.backgroundSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
    );
  }
}
