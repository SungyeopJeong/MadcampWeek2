import 'package:devil/models/chat.dart';
import 'package:devil/models/study.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/viewmodels/chat_model.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/widgets/error_msg.dart';
import 'package:devil/widgets/inkwell_btn.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.navigateToDetail});

  final void Function(MapEntry<Study, List<Chat>>) navigateToDetail;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(backgroundColor: DevilColor.white, title: "Chat"),
      body: context.watch<InfoModel>().isLogined
          ? () {
              final myChat = context.watch<ChatModel>().myChat;
              if (myChat.isEmpty) {
                return const ErrorMsg(msg: '가입한 스터디가 없습니다.');
              } else {
                return ListView.builder(
                  itemCount: myChat.length,
                  itemBuilder: (context, idx) => _buildStudyChat(
                    context,
                    myChat.entries.elementAt(idx),
                  ),
                );
              }
            }()
          : const ErrorMsg(msg: '로그인 후 이용 가능합니다.'),
    );
  }

  Widget _buildStudyChat(
      BuildContext context, MapEntry<Study, List<Chat>> studyChat) {
    return InkWellBtn(
      btnColor: DevilColor.white,
      onTap: () => widget.navigateToDetail(studyChat),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studyChat.key.name, style: DevilText.labelMH),
                  const SizedBox(height: 8),
                  Text(
                    studyChat.value.lastOrNull?.content ?? '',
                    style: DevilText.labelL.copyWith(color: DevilColor.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              lastTime(studyChat.value.lastOrNull?.timestamp),
              style: DevilText.labelLS.copyWith(color: DevilColor.lightgrey),
            ),
          ],
        ),
      ),
    );
  }

  String lastTime(DateTime? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    if (timestamp.year != now.year) {
      return DateFormat('yyyy. MM. dd').format(timestamp);
    } else if (timestamp.month == now.month && timestamp.day == now.day) {
      return DateFormat('a h:mm', 'ko').format(timestamp);
    }
    return DateFormat('M월 d일').format(timestamp);
  }
}
