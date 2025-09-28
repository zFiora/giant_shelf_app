import 'package:flutter/material.dart';
import 'package:giant_shelf_app/models/ledBar.dart';
import 'package:giant_shelf_app/widgets/barEditor.dart';
import 'package:giant_shelf_app/widgets/barWidget.dart';
import 'package:giant_shelf_app/widgets/legendCard.dart';

class ShelfLightsPage extends StatefulWidget {
  const ShelfLightsPage({super.key});

  @override
  State<ShelfLightsPage> createState() => _ShelfLightsPageState();
}

class _ShelfLightsPageState extends State<ShelfLightsPage> {
  // Grid config (approx DIY Machines layout)
  static const int cols = 4; // 4 columns of boxes
  static const int rows = 3; // 3 rows of boxes

  // Visual sizing (relative to canvas)
  static const double gap = 0.04;          // gap between boxes
  static const double barThickness = 0.025; // thickness of LED bars
  static const double outerMargin = 0.06;   // outer border

  late final List<LedBar> bars = _buildBars();

  List<LedBar> _buildBars() {
    final List<LedBar> list = [];
    int idCounter = 1;

    final double usableW = 1 - 2 * outerMargin;
    final double usableH = 1 - 2 * outerMargin;

    final double cellW = (usableW - (cols - 1) * gap) / cols;
    final double cellH = (usableH - (rows - 1) * gap) / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double left = outerMargin + c * (cellW + gap);
        final double top  = outerMargin + r * (cellH + gap);

        // Top
        list.add(LedBar(
          id: 'H-${idCounter++}',
          orientation: Axis.horizontal,
          rect: Rect.fromLTWH(left, top - barThickness / 2, cellW, barThickness),
        ));

        // Bottom
        list.add(LedBar(
          id: 'H-${idCounter++}',
          orientation: Axis.horizontal,
          rect: Rect.fromLTWH(left, top + cellH - barThickness / 2, cellW, barThickness),
        ));

        // Left
        list.add(LedBar(
          id: 'V-${idCounter++}',
          orientation: Axis.vertical,
          rect: Rect.fromLTWH(left - barThickness / 2, top, barThickness, cellH),
        ));

        // Right
        list.add(LedBar(
          id: 'V-${idCounter++}',
          orientation: Axis.vertical,
          rect: Rect.fromLTWH(left + cellW - barThickness / 2, top, barThickness, cellH),
        ));
      }
    }

    return list;
  }

  Future<void> _editBar(LedBar bar) async {
    final result = await showModalBottomSheet<BarEditResult>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => BarEditor(bar: bar),
    );

    if (result != null) {
      setState(() {
        bar.on = result.on;
        bar.brightness = result.brightness;
        bar.color = result.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shelf Lights (Main)'),
        actions: [
          IconButton(
            tooltip: 'All Off',
            onPressed: () => setState(() {
              for (final b in bars) b.on = false;
            }),
            icon: const Icon(Icons.power_settings_new),
          ),
          IconButton(
            tooltip: 'All On',
            onPressed: () => setState(() {
              for (final b in bars) {
                b.on = true;
                b.brightness = 1.0;
              }
            }),
            icon: const Icon(Icons.light_mode),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final W = constraints.maxWidth;
          final H = constraints.maxHeight;

          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surfaceVariant,
                      ],
                    ),
                  ),
                ),
              ),
              ...bars.map((bar) {
                final rectPx = Rect.fromLTWH(
                  bar.rect.left * W,
                  bar.rect.top * H,
                  bar.rect.width * W,
                  bar.rect.height * H,
                );
                return Positioned(
                  left: rectPx.left,
                  top: rectPx.top,
                  width: rectPx.width,
                  height: rectPx.height,
                  child: BarWidget(
                    bar: bar,
                    onTap: () => _editBar(bar),
                  ),
                );
              }),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: LegendCard(bars: bars),
              ),
            ],
          );
        },
      ),
    );
  }
}
