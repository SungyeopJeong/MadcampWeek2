import 'package:flutter/material.dart';

class InkWellBtn extends StatelessWidget {
  const InkWellBtn({
    super.key,
    this.btnColor,
    this.radius,
    this.onTap,
    this.child,
  });

  final Color? btnColor;
  final double? radius;
  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Material(
        color: btnColor,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
