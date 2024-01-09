class Chat {
  final String name, content;
  final int studyId;
  final DateTime timestamp;
  final bool isMine;

  Chat({
    required this.name,
    required this.studyId,
    required this.content,
    required this.timestamp,
    required this.isMine,
  });

  factory Chat.fromJson(String myId, Map<String, dynamic> json) {
    return Chat(
      name: json['username'],
      studyId: json['studyid'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isMine: json['userid'] == myId ? true : false,
    );
  }
}

class ChatToSend {
  final String userId, content;
  final int studyId;

  ChatToSend({
    required this.userId,
    required this.studyId,
    required this.content,
  });
}
