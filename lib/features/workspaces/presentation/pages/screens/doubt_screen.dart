import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/text_field/text_form_field.dart';
import '../../../../../core/resources/pallete/dark_theme_palette.dart';
import '../../../../injection.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/channel/channel_entity.dart';
import '../../../domain/entities/message/message.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../components/home_screen_main.dart';

class DoubtScreen extends StatefulWidget {
  final Workspace workspace;
  final Category category;
  final Channel channel;

  const DoubtScreen({
    super.key,
    required this.workspace,
    required this.category,
    required this.channel,
  });

  @override
  State<DoubtScreen> createState() => _DoubtScreenState();
}

class _DoubtScreenState extends State<DoubtScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void dispose() {
    sl<ChatBloc>().add(DisconnectChatEvent());
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    sl<ChatBloc>().add(GetPreviousChatEvent(
      workspaceId: widget.workspace.id,
      categoryId: widget.category.id,
      channelId: widget.channel.id,
    ));
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      sl<ChatBloc>().add(SendMessageEvent(message: _messageController.text));
      _messageController.clear();
      _messageFocusNode.requestFocus();
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildChatContent()),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      title: Row(
        children: [
          Text(
            widget.category.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),
          Text(
            widget.channel.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 3.0,
          color: Theme.of(context).dividerColor,
        ),
      ),
      leading: HomeScreenMain.desktopBreakpoint <= size.width
          ? null
          : IconButton(
              onPressed: () {
                sl<ChatBloc>().add(DisconnectChatEvent());
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
      elevation: 0,
    );
  }

  Widget _buildChatContent() {
    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) {
        return previous.messages.length < current.messages.length;
      },
      listener: (context, state) {
        if (_scrollController.position.extentAfter < 200) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildMessageList(state.messages),
            if (state.status == ChatStatus.loading) _buildLoading(),
            if (state.status == ChatStatus.failure)
              _buildError(state.error ?? "An unknown error occurred."),
          ],
        );
      },
    );
  }

  Widget _buildMessageList(List<Message> messages) {
    if (messages.isNotEmpty) {
      _scrollToBottom();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: _getHorizontalPadding(constraints.maxWidth),
          ),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageItem(
              message: messages[index],
              maxWidth: _getMessageMaxWidth(constraints.maxWidth),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen =
            constraints.maxWidth > AppConstants.tabletBreakpoint;

        return Container(
          padding: EdgeInsets.all(isWideScreen ? 16 : 8),
          color: AppColors.inputBackgroundColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  isWideScreen ? AppConstants.maxContentWidth : double.infinity,
            ),
            child: MessageInput(
              controller: _messageController,
              focusNode: _messageFocusNode,
              channelName: widget.channel.name,
              onSendMessage: _sendMessage,
              isWideScreen: isWideScreen,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const CircularProgressIndicator(
          color: AppColors.primaryAccent,
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeChat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > AppConstants.desktopBreakpoint) return 32;
    if (screenWidth > AppConstants.tabletBreakpoint) return 24;
    return 16;
  }

  double _getMessageMaxWidth(double screenWidth) {
    if (screenWidth > AppConstants.desktopBreakpoint) {
      return AppConstants.maxContentWidth;
    }
    return screenWidth;
  }
}

// Message Item Widget
class MessageItem extends StatelessWidget {
  final Message message;
  final double maxWidth;

  const MessageItem({
    super.key,
    required this.message,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(username: message.senderName),
            const SizedBox(width: 12),
            Expanded(
              child: MessageContent(message: message),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String username;

  const UserAvatar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: _getAvatarColor(username),
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : '?',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Color _getAvatarColor(String username) {
    final hash = username.hashCode;
    return AppColors.avatarColors[hash.abs() % AppColors.avatarColors.length];
  }
}

class MessageContent extends StatelessWidget {
  final Message message;

  const MessageContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.senderName,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          message.content,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String channelName;
  final VoidCallback onSendMessage;
  final bool isWideScreen;

  const MessageInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.channelName,
    required this.onSendMessage,
    required this.isWideScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              constraints: BoxConstraints(
                maxHeight: isWideScreen ? 150 : 120,
                minHeight: isWideScreen ? 48 : 44,
              ),
              decoration: BoxDecoration(
                color: AppColors.textFieldBackgroundColor,
                borderRadius: BorderRadius.circular(isWideScreen ? 12 : 8),
              ),
              child: TextFormFieldWidget(
                controller: controller,
                haveObscureText: false,
                haveSuffixIconObscure: false,
                hintText: "Type something here...",
              )),
        ),
        SizedBox(width: isWideScreen ? 12 : 8),
        IconButton(
          icon: Icon(
            Icons.send,
            color: AppColors.iconColor,
            size: isWideScreen ? 28 : 24,
          ),
          onPressed: onSendMessage,
        ),
      ],
    );
  }
}

class AppConstants {
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;
  static const double maxContentWidth = 800;
}

class AppColors {
  static const Color backgroundColor = DarkThemePalette.primaryDark;
  static const Color appBarColor = DarkThemePalette.secondaryDarkGray;
  static const Color inputBackgroundColor = Color(0xFF2D2D30);
  static const Color textFieldBackgroundColor = Color(0xFF3E3E42);
  static const Color iconColor = Color(0xFF9CA3AF);
  static const Color primaryAccent = Color(0xFF60A5FA);
  static const Color cardBackgroundColor = Color(0xFF2D2D30);

  static const List<Color> avatarColors = [
    Color(0xFF60A5FA),
    Color(0xFF34D399),
    Color(0xFFFBBF24),
    Color(0xFFF472B6),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
  ];
}
