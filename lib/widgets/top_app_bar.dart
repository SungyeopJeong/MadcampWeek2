import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key, required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: DevilColor.bg,
      surfaceTintColor: DevilColor.bg,
      title: Text(
        title,
        style: DevilText.titleB,
      ),
    );
  }
}
