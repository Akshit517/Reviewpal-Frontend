import 'package:ReviewPal/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/routes/routes.dart';
import '../../../../core/widgets/divider/middle_text_divider.dart';
import '../../../../core/widgets/text_button/social_text_button.dart';
import '../../../../core/widgets/text_field/text_form_field.dart';
import '../../../../core/widgets/text_field/text_field_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose(); 
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar('Login'),
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
                  child: _buildLoginContent(constraints),
                ),
                if (isTablet) const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginContent(BoxConstraints constraints) {
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
              context.go(CustomNavigationHelper.homePath);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                        AuthLogin(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const MiddleTextDivider(text: 'OR'),
                const SizedBox(height: 20.0),
                SocialTextButton(
                  constraints: constraints,
                  text: 'Continue with Google',
                  iconPath: 'assets/icons/g_logo.svg',
                  redirectTo: dotenv.env['GOOGLE_REDIRECT_URI']!,
                ),
                const SizedBox(height: 20.0),
                const MiddleTextDivider(text: 'OR'),
                const SizedBox(height: 20.0),
                SocialTextButton(
                  constraints: constraints,
                  text: 'Continue with Channel-I',
                  iconPath: 'assets/icons/chi_logo.svg',
                  redirectTo: dotenv.env['CHANNELI_REDIRECT_URI']!,
                ),
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
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 3.0,
            color: Colors.grey,
          ),
        ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}
