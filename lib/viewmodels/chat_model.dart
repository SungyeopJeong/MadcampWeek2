import 'package:devil/models/chat.dart';
import 'package:devil/services/api.dart';
import 'package:devil/services/socket.dart';
import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier {
  late SocketService _socketService;
  SocketService get socketService => _socketService;

  Map<int, List<Chat>> _myChat = {};
  Map<int, List<Chat>> get myChat => _myChat;

  ChatModel() {
    _socketService = SocketService();
    _socketService.connect();
  }

  void init(String userid) {
    _socketService.on('init', (data) {
      if ((data['statusCode'] as int).isOk()) {
        _myChat = {};
        final chatList = (data['body'] as List)
            .map((e) => Chat.fromJson(userid, e))
            .toList();
        for (final chat in chatList) {
          if (!_myChat.containsKey(chat.studyId)) {
            addStudy(userid, chat.studyId);
          }
          _myChat[chat.studyId] =
              _myChat.putIfAbsent(chat.studyId, () => []) + [chat];
        }
        notifyListeners();
      }
    });
  }

  void addStudy(String userid, int studyid) async {
    _socketService.on('study$studyid', (data) {
      final chat = Chat.fromJson(userid, data);
      _myChat[studyid] = _myChat[studyid]! + [chat];
      notifyListeners();
    });
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
