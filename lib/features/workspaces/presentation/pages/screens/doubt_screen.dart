import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/channel/channel_entity.dart';
import '../../../domain/entities/message/message.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/chat/chat_bloc.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Group Chats",
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
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatInitialState) {
              return _buildLoading();
            } else if (state is ChatLoadedState) {
              return _buildLoadedMessages(state.messages);
            } else if (state is ChatSentState) {
              return _buildSentConfirmation();
            } else if (state is ChatUpdatedState) {
              return _buildUpdatedMessage(state.message);
            } else if (state is ChatErrorState) {
              return _buildError(state.error);
            } else {
              return _buildLoading();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedMessages(List<Message> messages) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          title: Text(message.content),
          subtitle: Text(message.senderName),
        );
      },
    );
  }

  Widget _buildSentConfirmation() {
    return const Center(
      child: Text(
        'Message Sent!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUpdatedMessage(Message message) {
    return ListView(
      children: [
        ListTile(
          title: Text(message.content),
          subtitle: Text(message.senderName),
        ),
      ],
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Text(
        'Error: $error',
        style: const TextStyle(fontSize: 18, color: Colors.red),
      ),
    );
  }
}
