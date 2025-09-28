import 'package:flutter/material.dart';
import 'package:giant_shelf_app/models/ledBar.dart';


class LegendCard extends StatelessWidget {
  const LegendCard({super.key, required this.bars});

  final List<LedBar> bars;

  @override
  Widget build(BuildContext context) {
    final onCount = bars.where((b) => b.on).length;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.touch_app),
            const SizedBox(width: 8),
            const Text('Tap a segment to edit'),
            const Spacer(),
            Text('$onCount / ${bars.length} on'),
          ],
        ),
      ),
    );
  }
}
