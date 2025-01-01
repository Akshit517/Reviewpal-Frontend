import 'package:flutter/material.dart';

const _shimmerGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 144, 143, 143),
    Color.fromARGB(255, 133, 133, 133),
    Color.fromARGB(255, 116, 115, 115),
  ],
  stops: [0.1, 0.3, 0.4],
  tileMode: TileMode.clamp,
);

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = _controller.value * 2 - 1; // Ranges from -1 to 1
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: _shimmerGradient.colors,
              stops: _shimmerGradient.stops,
              begin: Alignment(-1.0 + offset, -0.3),
              end: Alignment(1.0 + offset, 0.3),
              tileMode: _shimmerGradient.tileMode,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
