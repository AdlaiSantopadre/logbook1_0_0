import 'package:flutter/material.dart';
import 'package:logbook1_0_0/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProgressIndicatorWidget extends ConsumerWidget {
  //final int totalProgress;
  //const ProgressIndicatorWidget({super.key});

  const ProgressIndicatorWidget(totalProgress, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalProgress = ref.watch(totalProgressProvider.notifier).state;
    Color? color;
    if (totalProgress <= 50) {
      // Gradually transition from red to orange
      color = Color.lerp(Colors.red, Colors.orange, totalProgress / 50);
    } else {
      // Gradually transition from orange to green
      color =
          Color.lerp(Colors.orange, Colors.green, (totalProgress - 50) / 50);
    }

    return Container(
      alignment: Alignment.centerLeft,
      height: 20, // Adjust the height as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Add rounded corners
        color:
            Colors.grey.withOpacity(0.3), // Add a background color with opacity
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: totalProgress / 100,
        child: Container(
          
          height: 20, // Adjust the height as needed
          decoration: BoxDecoration(
            //border: Border.all( ),
            borderRadius: BorderRadius.circular(10), // Add rounded corners
            color: color, // Use the calculated color
          ),
        ),
      ),
    );
  }
}
