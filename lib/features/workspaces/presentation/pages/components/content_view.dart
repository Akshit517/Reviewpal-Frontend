import 'package:flutter/material.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a channel to start chatting',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
