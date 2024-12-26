import 'package:flutter/material.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';

class DoubtScreen extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;
  const DoubtScreen({super.key, required this.workspace, required this.category, required this.channel}); 

  @override
  State<DoubtScreen> createState() => _DoubtScreenState();
}

class _DoubtScreenState extends State<DoubtScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}