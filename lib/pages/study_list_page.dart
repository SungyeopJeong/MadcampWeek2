import 'package:devil/models/study.dart';
import 'package:devil/widgets/study_block.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';

class StudyListPage extends StatelessWidget {
  const StudyListPage({
    super.key,
    required this.title,
    required this.list,
  });
  final String title;
  final List<Study> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(title: title, canPop: true),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemCount: list.length,
        itemBuilder: (context, index) => StudyBlock(study: list[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }
}
