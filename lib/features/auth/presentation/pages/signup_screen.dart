import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/responsive/responsive_helpers.dart';
import '../../../../core/presentation/widgets/layouts/responsive_scaffold.dart';
import '../../../../core/presentation/widgets/text_field/text_form_field.dart';
import '../../../../core/presentation/widgets/text_field/text_field_header.dart';
import '../../../../core/resources/routes/routes.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: "Sign Up",
      content: _buildSignUpContent(),
    );
  }

  Widget _buildSignUpContent() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
            ));
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Successfully Signed Up!!!"),
            ));
            context.go(CustomNavigationHelper.homePath);
          }
        },
        builder: (context, state) {
          final buttonWidth = ResponsiveHelpers.getButtonWidth(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TextFieldHeader(text: 'Username'),
              TextFormFieldWidget(
                controller: _usernameController,
                hintText: 'Your Username...',
                haveObscureText: false,
                haveSuffixIconObscure: false,
              ),
              const SizedBox(height: 16.0),
              const TextFieldHeader(text: 'Email'),
              TextFormFieldWidget(
                controller: _emailController,
                hintText: 'Your Email...',
                haveObscureText: false,
                haveSuffixIconObscure: false,
              ),
              const SizedBox(height: 16.0),
              const TextFieldHeader(text: 'Password'),
              TextFormFieldWidget(
                controller: _passwordController,
                hintText: 'Minimum 8 characters long...',
                haveObscureText: true,
                haveSuffixIconObscure: true,
              ),
              const SizedBox(height: 26.0),
              SizedBox(
                width: buttonWidth,
                height: 50.0,
                child: TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthSignUp(
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
