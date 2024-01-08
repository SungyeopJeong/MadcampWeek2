import 'package:devil/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBar(title: "Chat"),
      body: Center(child: Text("Chat Page")),
    );
  }
}