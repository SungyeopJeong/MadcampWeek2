import 'package:devil/models/chat.dart';
import 'package:devil/models/study.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/viewmodels/chat_model.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/widgets/inkwell_btn.dart';
import 'package:flutter/material.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    required this.study,
  });
  final Study study;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: widget.study.name,
        canPop: true,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: () {
              final chatList = context
                      .watch<ChatModel>()
                      .myChat[widget.study.id]
                      ?.reversed
                      .toList() ??
                  [];
              return ListView.builder(
                reverse: true,
                controller: _scrollController,
                itemCount: chatList.length,
                itemBuilder: (_, idx) => _buildChat(
                  chatList[idx],
                ),
              );
            }(),
          ),
          Container(
            color: DevilColor.white,
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                  ),
                ),
                const SizedBox(width: 16),
                InkWellBtn(
                  btnColor: DevilColor.black,
                  radius: 12,
                  onTap: () {
                    context.read<ChatModel>().send(
                          ChatToSend(
                            userId: context.read<InfoModel>().user.id,
                            studyId: widget.study.id!,
                            content: _chatController.text,
                          ),
                        );
                    _chatController.clear();
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceIn,
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 36,
                    alignment: Alignment.center,
                    child: Text(
                      "전송",
                      style: DevilText.bodyM.copyWith(color: DevilColor.point),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChat(Chat chat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: chat.isMine
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Spacer(),
                Text(
                  DateFormat('a h:mm', 'ko').format(chat.timestamp),
                  style: DevilText.labelLS,
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: DevilColor.point,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  child: Text(chat.content, style: DevilText.bodyM),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name,
                  style: DevilText.bodyM,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: DevilColor.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 16),
                      child: Text(chat.content, style: DevilText.bodyM),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('a h:mm', 'ko').format(chat.timestamp),
                      style: DevilText.labelLS,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
