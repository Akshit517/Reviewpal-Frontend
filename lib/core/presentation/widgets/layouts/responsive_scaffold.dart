import 'package:flutter/material.dart';

import 'responsive_layout.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.content,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ResponsiveLayout(
        child: content,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(
          height: 1.0,
          thickness: 3.0,
          color: Colors.grey,
        ),
      ),
      centerTitle: centerTitle,
      leading: onBackPressed != null
          ? IconButton(
              onPressed: onBackPressed,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            )
          : null,
      actions: actions,
    );
  }
}