import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/workspace/workspace_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<WorkspaceBloc>().add(const GetJoinedWorkspacesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                       
                    ]),
                  ),
                )
               
                ,

                // Main Content Area
                Expanded(
                  flex: 4,
                  child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
                    builder: (context, state) {
                      if (state is WorkspaceLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is WorkspacesLoaded) {
                        return const CircularProgressIndicator(); 
                      } else if (state is WorkspaceError) {
                        return Center(
                          child: Text("Error: ${state.message}"),
                        );
                      } else {
                        return const Center(child: Text("No data available"));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}