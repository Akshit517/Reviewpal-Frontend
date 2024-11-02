import 'package:flutter/material.dart';

class TextFieldHeader extends StatelessWidget {
  const TextFieldHeader({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Text(
          text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
