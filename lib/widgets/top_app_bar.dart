import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key, required this.title, this.canPop = false});
  final String title;
  final bool canPop;

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: canPop
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: DevilColor.black,
              ),
            )
          : null,
      toolbarHeight: preferredSize.height,
      backgroundColor: DevilColor.bg,
      surfaceTintColor: DevilColor.bg,
      title: Text(
        title,
        style: DevilText.titleB,
      ),
      centerTitle: canPop,
    );
  }
}
