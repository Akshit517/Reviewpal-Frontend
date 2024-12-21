import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/category/category_bloc.dart';


class WorkspaceHomeWidget extends StatefulWidget {
  final String workspaceId;

  const WorkspaceHomeWidget({super.key, required this.workspaceId});

  @override
  State<WorkspaceHomeWidget> createState() => _WorkspaceHomeWidgetState();
}

class _WorkspaceHomeWidgetState extends State<WorkspaceHomeWidget> {

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategoriesEvent(workspaceId: widget.workspaceId));
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}