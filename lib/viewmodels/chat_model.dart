import 'package:devil/models/chat.dart';
import 'package:devil/models/study.dart';
import 'package:devil/services/api.dart';
import 'package:devil/services/socket.dart';
import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier {
  late SocketService _socketService;
  SocketService get socketService => _socketService;

  final Map<Study, List<Chat>> _myChat = {};
  Map<Study, List<Chat>> get myChat => _myChat;

  ChatModel() {
    _socketService = SocketService();
  }

  void init(String userid, List<Study> studies) async {
    _socketService.connect();
    _socketService.on('init', (data) {
      if ((data['statusCode'] as int).isOk()) {
        final chatList = (data['body'] as List)
            .map((e) => Chat.fromJson(userid, e))
            .toList();
        for (final study in studies) {
          _myChat[study] = chatList.where((element) => element.studyId == study.id).toList();
        }
        notifyListeners();
      }
    });
    _socketService.on('study0', (data) {
      final chat = Chat.fromJson(userid, data);
      final study = studies.firstWhere((element) => element.id == chat.studyId);
      _myChat[study] = _myChat[study]! + [chat];
      notifyListeners();
    });
    getMyChat(userid);
  }

  void getMyChat(String userid) {
    _socketService.emit('get', userid);
  }

  void send(ChatToSend chat) async {
    _socketService.emit('send', {
      'userid': chat.userId,
      'studyid': chat.studyId,
      'content': chat.content,
    });
  }
}
