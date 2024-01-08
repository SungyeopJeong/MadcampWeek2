import 'package:devil/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBar(title: "My Page"),
      body: Center(child: Text("My Page")),
    );
  }
}