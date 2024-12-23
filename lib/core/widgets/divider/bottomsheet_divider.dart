import 'package:flutter/material.dart';

class BottomSheetDivider extends StatelessWidget {
  const BottomSheetDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Spacer(flex: 1),
        Expanded(flex: 1, child: Divider(thickness: 2)),
        Spacer(flex: 1),
      ],
    );
  }
}