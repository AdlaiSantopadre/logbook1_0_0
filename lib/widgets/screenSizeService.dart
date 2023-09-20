import 'package:flutter/material.dart';

class ScreenSizeService {
  final BuildContext context;

  const ScreenSizeService(
    this.context,
  );

  Size get size => MediaQuery.of(context).size;
  double get height => size.height;
  double get width => size.width;
}