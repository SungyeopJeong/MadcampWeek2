import 'package:devil/models/chat.dart';
import 'package:devil/models/study.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/viewmodels/chat_model.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:flutter/material.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    required this.studyChat,
  });
  final MapEntry<Study, List<Chat>> studyChat;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: widget.studyChat.key.name,
        canPop: true,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: () {
              final chatList = widget.studyChat.value;
              if (chatList.isEmpty) {
                return const SizedBox();
              } else {
                return Text("todo");
              }
            }(),
          ),
          Container(
            color: DevilColor.white,
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => context.read<ChatModel>().send(
                        ChatToSend(
                          userId: context.read<InfoModel>().user.id,
                          studyId: 24,
                          content: _chatController.text,
                        ),
                      ),
                  child: const Text("send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
