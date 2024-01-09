import 'package:devil/style/color.dart';
import 'package:flutter/material.dart';

class DevilText {
  static const TextStyle _txtBase = TextStyle(
    overflow: TextOverflow.ellipsis,
    leadingDistribution: TextLeadingDistribution.even,
    color: DevilColor.black,
  );

  static final TextStyle _light = _txtBase.copyWith(fontWeight: FontWeight.w300);
  static final TextStyle _medium = _txtBase.copyWith(fontWeight: FontWeight.w500);
  static final TextStyle _bold = _txtBase.copyWith(fontWeight: FontWeight.w700);

  static final TextStyle labelL = _light.copyWith(fontSize: 12, height: 16 / 12);
  static final TextStyle labelLH = _light.copyWith(fontSize: 14, height: 18 / 14);
  static final TextStyle bodyL = _light.copyWith(fontSize: 16, height: 20 / 16);
  static final TextStyle titleL = _light.copyWith(fontSize: 20, height: 24 / 20);

  static final TextStyle labelM = _medium.copyWith(fontSize: 12, height: 16 / 12);
  static final TextStyle bodyM = _medium.copyWith(fontSize: 16, height: 20 / 16);
  static final TextStyle titleM = _medium.copyWith(fontSize: 20, height: 24 / 20);

  static final TextStyle labelB = _bold.copyWith(fontSize: 12, height: 16 / 12);
  static final TextStyle titleB = _bold.copyWith(fontSize: 20, height: 24 / 20);
  static final TextStyle headlineB = _bold.copyWith(fontSize: 24, height: 28 / 24);
}