import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/widgets/inkwell_btn.dart';
import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  const PopUp({
    super.key,
    required this.msg,
    this.onTap,
  });

  final String msg;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
            child: Text(
              msg,
              maxLines: 10,
              style: DevilText.bodyM,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildButton(context, onTap),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, void Function()? onTap) {
    return InkWellBtn(
      btnColor: DevilColor.point,
      radius: 12,
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) onTap();
      },
      child: Container(
        height: 48,
        alignment: Alignment.center,
        child: Text(
          '확인',
          style: DevilText.bodyM,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
