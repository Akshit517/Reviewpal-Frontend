import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/infrastructure/media/media_uploader.dart';
import '../../../../core/presentation/widgets/image/universal_image.dart';
import '../../../../core/presentation/widgets/layouts/responsive_scaffold.dart';
import '../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../core/resources/routes/routes.dart';
import '../../../injection.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/profile_bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const GetProfile());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // Convert XFile to File using the path
    if (image != null) {
      File file = File(image.path);
      final uploadedUrl = await sl<MediaUploader>().uploadMedia(file: file);
      if (!mounted) return;
      context
          .read<ProfileBloc>()
          .add(UpdateProfilePic(profilePic: uploadedUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        title: "Profile",
        content: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is UnAuthenticated) {
                  context.go(CustomNavigationHelper.rootAuthPath);
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to Logout")),
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state.status == Status.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile update failed')),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.status == Status.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == Status.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load profile'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(const GetProfile());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final user = state.user;
              if (user == null) {
                return const Center(child: Text('No user data available'));
              }

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: UniversalImage(imageUrl: user.profilePic),
                        ),
                        FloatingActionButton.small(
                          onPressed: _updateProfilePicture,
                          child: const Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController..text = user.username,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: user.email,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (user.authType != null)
                      Text(
                        'Signed in with ${user.authType}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DarkThemePalette.fillColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                                UpdateUsername(
                                    username: _usernameController.text),
                              );
                        }
                      },
                      child: const Text('Update Profile'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 115, 50, 50),
                          foregroundColor:
                              const Color.fromARGB(255, 180, 180, 180)),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogout());
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
