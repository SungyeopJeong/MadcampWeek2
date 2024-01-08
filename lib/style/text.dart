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

  static final TextStyle body = medium.copyWith(fontSize: 16, height: 20 / 16);
  static final TextStyle title = bold.copyWith(fontSize: 20, height: 24 / 20);
}