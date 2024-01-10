import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:flutter/material.dart';

class ErrorMsg extends StatelessWidget {
  const ErrorMsg({super.key, required this.msg});
  final String msg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(flex: 1),
          const Icon(
            Icons.error_rounded,
            size: 40,
            color: DevilColor.lightgrey,
          ),
          const SizedBox(height: 12),
          Text(
            msg,
            style: DevilText.bodyM.copyWith(color: DevilColor.lightgrey),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
