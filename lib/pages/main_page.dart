import 'package:devil/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBar(title: "Study"),
      body: Center(child: Text("Main Page")),
    );
  }
}