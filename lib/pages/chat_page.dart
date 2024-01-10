import 'package:devil/models/chat.dart';
import 'package:devil/viewmodels/chat_model.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:flutter/material.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
    required this.userid,
    required this.studyid,
  });
  String userid;
  int studyid;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (context.watch<InfoModel>().isLogined) {
      final myChat = context.watch<ChatModel>().myChat;
      return Scaffold(
        appBar: const TopAppBar(title: "Chat"),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: myChat.length,
                itemBuilder: (_, idx) => Text(
                  myChat[idx].content,
                  textAlign:
                      myChat[idx].isMine ? TextAlign.end : TextAlign.start,
                ),
              ),
            ),
            Row(
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
            TextButton(
              onPressed: () => context
                  .read<ChatModel>()
                  .getMyChat(context.read<InfoModel>().user.id),
              child: const Text("refresh"),
            ),
          ],
        ),
      );
    }
    return const Text("not yet");
  }
}
