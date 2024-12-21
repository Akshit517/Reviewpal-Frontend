import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../core/resources/routes/routes.dart';
import '../../../../core/widgets/buttons/general_text_button.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double buttonHeight = 60.0;
    double imageSize = 120.0;
    double buttonWidth = size.width * 0.85;
    double textScaleFactor = MediaQuery.textScalerOf(context).scale(16);

    if (size.width > 1200) {
      buttonHeight = 80.0;
      imageSize = 240.0;
    } else if (size.width > 800) {
      buttonHeight = 70.0;
      imageSize = 210.0;
    } else if (size.width > 600) {
      buttonHeight = 60.0;
      imageSize = 180.0;
    } else {
      buttonHeight = 50.0;
      imageSize = 150.0;
    }

    return Scaffold(
      backgroundColor: DarkThemePalette.backgroundSurface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          // Landscape mode
          if (isLandscape) {
            return _landscapeView(imageSize, context, buttonHeight);
          }

          final containerWidth = size.width * 0.6;

          return _portraitView(containerWidth, imageSize, buttonWidth,
              buttonHeight, context, textScaleFactor);
        },
      ),
    );
  }
  //when size.width > size.height
  Row _landscapeView(double imageSize, BuildContext context, double buttonHeight) {
    return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Expanded(
                flex: 4,
                child: Image.asset(
                  'assets/ic_launcher/ic_launcher.png',
                  width: imageSize,
                  height: imageSize,
                )),
            const Spacer(flex: 1),
            Expanded(
                flex: 4,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GeneralTextButton(
                        onPressed: () => context.push(CustomNavigationHelper.loginPath), 
                        buttonHeight: buttonHeight, 
                        text: "Login"
                      ),
                      const SizedBox(height: 20.0),
                      GeneralTextButton(
                        onPressed: () => context.push(CustomNavigationHelper.signUpPath), 
                        buttonHeight: buttonHeight,
                        buttonColor: DarkThemePalette.fillColor,
                        text: "Sign Up",
                        textColor: DarkThemePalette.primaryAccent,
                      )
                    ],
                  ),
                )),
                const Spacer(flex: 1),
          ]);
  }
  // when size.height > size.width
  Column _portraitView(
      double containerWidth,
      double imageSize,
      double buttonWidth,
      double buttonHeight,
      BuildContext context,
      double textScaleFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 6),
        Expanded(
          flex: 24,
          child: Container(
            width: containerWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  DarkThemePalette.primaryAccent,
                  DarkThemePalette.primaryDark,
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(300)),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/ic_launcher/ic_launcher.png',
              width: imageSize,
              height: imageSize,
            ),
          ),
        ),
        const Spacer(flex: 6),
        Expanded(
          flex: 8,
          child: Center(
            child: Column(
              children: [
                GeneralTextButton(
                  onPressed: () => context.push(CustomNavigationHelper.loginPath), 
                  buttonHeight: buttonHeight, 
                  buttonWidth: buttonWidth, 
                  text: "Login"),
                const SizedBox(height: 10),
                GeneralTextButton(
                  onPressed: () => context.push(CustomNavigationHelper.signUpPath), 
                  buttonHeight: buttonHeight,
                  buttonWidth: buttonWidth,
                  buttonColor: DarkThemePalette.fillColor,
                  text: "Sign Up",
                  textColor: DarkThemePalette.primaryAccent,

                )
              ],
            ),
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}