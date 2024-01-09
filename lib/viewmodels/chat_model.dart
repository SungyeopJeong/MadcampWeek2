import 'package:devil/models/chat.dart';
import 'package:devil/models/study.dart';
import 'package:devil/services/api.dart';
import 'package:devil/services/socket.dart';
import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier {
  late SocketService _socketService;
  SocketService get socketService => _socketService;

  late List<Chat> _myChat;
  List<Chat> get myChat => _myChat;

  ChatModel() {
    _socketService = SocketService();
  }

  void init(String userid, List<Study> studies) async {
    _socketService.connect();
    _socketService.on('init', (data) {
      if ((data['statusCode'] as int).isOk()) {
        _myChat = (data['body'] as List)
            .map((e) => Chat.fromJson(/*userid*/ '7', e))
            .toList();
        notifyListeners();
      }
    });
    _socketService.on('study0', (data) {
      _myChat.add(Chat.fromJson(userid, data));
      notifyListeners();
    });
    getMyChat(userid);
  }

  void getMyChat(String userid) {
    _socketService.emit('get', /*userid*/ '7');
  }

  void send(ChatToSend chat) async {
    _socketService.emit('send', {
      'userid': chat.userId,
      'studyid': chat.studyId,
      'content': chat.content,
    });
  }
}
