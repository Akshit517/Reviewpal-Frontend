import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/resources/routes/routes.dart';
import 'core/resources/app_themes/themes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/injection.dart';
import 'features/workspaces/presentation/blocs/category/category_bloc.dart';
import 'features/workspaces/presentation/blocs/channel/channel_bloc/channel_bloc.dart';
import 'features/workspaces/presentation/blocs/channel/member/channel_member_bloc.dart';
import 'features/workspaces/presentation/blocs/channel/single_member/single_channel_member_cubit.dart';
import 'features/workspaces/presentation/blocs/iteration/iteration_bloc.dart';
import 'features/workspaces/presentation/blocs/submission/submission_bloc.dart';
import 'features/workspaces/presentation/blocs/workspace/single_member/single_workspace_member_cubit.dart';
import 'features/workspaces/presentation/blocs/workspace/member/workspace_member_bloc.dart';
import 'features/workspaces/presentation/blocs/workspace/workspace_bloc/workspace_bloc.dart';

class AsgRevApp extends StatefulWidget {
  const AsgRevApp({super.key});

  @override
  State<AsgRevApp> createState() => _AsgRevAppState();
}

class _AsgRevAppState extends State<AsgRevApp> {
  @override
  void initState() {
    super.initState();
        
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<WorkspaceBloc>(create: (context) => sl<WorkspaceBloc>()),
        BlocProvider<SingleWorkspaceMemberCubit>(create: (context) => sl<SingleWorkspaceMemberCubit>()),
        BlocProvider<WorkspaceMemberBloc>(create: (context) => sl<WorkspaceMemberBloc>()),
        BlocProvider<CategoryBloc>(create: (context) => sl<CategoryBloc>()),
        BlocProvider<ChannelBloc>(create: (context) => sl<ChannelBloc>()),
        BlocProvider<SingleChannelMemberCubit>(create: (context) => sl<SingleChannelMemberCubit>()),
        BlocProvider<ChannelMemberBloc>(create: (context) => sl<ChannelMemberBloc>()),
        BlocProvider<SubmissionBloc>(create: (context) => sl<SubmissionBloc>()),
        BlocProvider<IterationBloc>(create: (context) => sl<IterationBloc>()),
        ],
      child: MaterialApp.router(
        theme: appThemeData.values.toList()[1],
        routerConfig: CustomNavigationHelper.router,
      ),
    );
  }
}