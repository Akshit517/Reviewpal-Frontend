import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double tabletBreakpoint;
  final double contentWidthFactor;
  final EdgeInsets padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.tabletBreakpoint = 640,
    this.contentWidthFactor = 0.5,
    this.padding = const EdgeInsets.all(15.0),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= tabletBreakpoint;
        final contentWidth = isTablet 
            ? constraints.maxWidth * contentWidthFactor 
            : constraints.maxWidth;

        return SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isTablet) const Spacer(flex: 1),
              Container(
                width: contentWidth,
                padding: padding,
                child: child,
              ),
              if (isTablet) const Spacer(flex: 1),
            ],
          ),
        );
      },
    );
  }
}
