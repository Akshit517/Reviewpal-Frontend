import 'package:ReviewPal/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/text_field/text_form_field.dart';
import '../../../../core/widgets/text_field/text_field_header.dart';

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
    return Scaffold(
      appBar: _buildAppBar('Sign Up'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 640;
          final contentWidth =
              isTablet ? constraints.maxWidth * 0.5 : constraints.maxWidth;

          return SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isTablet) const Spacer(flex: 1),
                Container(
                  width: contentWidth,
                  padding: const EdgeInsets.all(15.0),
                  child: _buildSignUpContent(constraints),
                ),
                if (isTablet) const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignUpContent(BoxConstraints constraints) {
    final isTablet = constraints.maxWidth >= 600;
    final buttonWidth =
        isTablet ? constraints.maxWidth * 0.5 : constraints.maxWidth * 0.9;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                )
              );
            } else if (state is AuthSuccess) {
              print(state.message);
              print(state.email);
            }
          },
          builder: (context, state) {
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
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}
