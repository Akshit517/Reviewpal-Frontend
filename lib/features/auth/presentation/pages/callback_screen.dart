import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/routes/routes.dart';
import '../bloc/auth_bloc.dart';

class CallbackScreen extends StatefulWidget {
  final String code;
  final String redirectUri;
  final String provider;

  const CallbackScreen({
    super.key,
    required this.code,
    required this.redirectUri,
    required this.provider,
  });

  @override
  State<CallbackScreen> createState() => _CallbackScreenState();
}

class _CallbackScreenState extends State<CallbackScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(
          AuthLoginOAuth(
            code: widget.code,
            provider: widget.provider,
            redirectUri: widget.redirectUri,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
            context.go(CustomNavigationHelper.homePath);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
            context.go(CustomNavigationHelper.loginPath);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
            child: Text('Authenticating...'),
          );
        },
      ),
    );
  }
}
