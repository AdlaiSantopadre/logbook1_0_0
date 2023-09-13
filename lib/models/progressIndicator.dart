import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int _totalProgress;

  ProgressIndicatorWidget(this._totalProgress);

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (_totalProgress <= 50) {
      // Gradually transition from red to orange
      color = Color.lerp(Colors.red, Colors.orange, _totalProgress / 50);
    } else {
      // Gradually transition from orange to green
      color = Color.lerp(Colors.orange, Colors.green, (_totalProgress - 50) / 50);
    }

    return LinearProgressIndicator(
      value: _totalProgress / 100,
      valueColor: AlwaysStoppedAnimation<Color>(color!),
      backgroundColor: Colors.grey, // You can customize the background color
    );
  }
}
