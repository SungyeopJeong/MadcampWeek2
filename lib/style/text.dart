import 'package:devil/style/color.dart';
import 'package:flutter/material.dart';

class DevilText {
  static const TextStyle txtBase = TextStyle(
    overflow: TextOverflow.ellipsis,
    leadingDistribution: TextLeadingDistribution.even,
    color: DevilColor.black,
  );

  static final TextStyle light = txtBase.copyWith(fontWeight: FontWeight.w300);
  static final TextStyle medium = txtBase.copyWith(fontWeight: FontWeight.w500);
  static final TextStyle bold = txtBase.copyWith(fontWeight: FontWeight.w700);
}