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
  // Target grid: 2 columns x 6 rows (12 perfect squares).
  static const int cols = 2;
  static const int rows = 6;

  // Visual tuning (in pixels, not percentages)
  static const double gapPx = 10.0;        // gap between squares
  static const double edgePaddingPx = 16.0; // safe padding inside screen edges
  static const double barThicknessRatio = 0.08; // thickness relative to square size

  // We keep one LedBar instance per segment for state (color/on/brightness).
  // We'll generate them deterministically the first time and reuse.
  late final List<LedBar> _allBars = _createAllBarsForLogicalGrid();

  // This creates "logical" bars with IDs only (positions are computed each frame to enforce perfect squares)
  List<LedBar> _createAllBarsForLogicalGrid() {
    final list = <LedBar>[];
    int idCounter = 1;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        list.add(LedBar(id: 'H-${idCounter++}', rect: Rect.zero, orientation: Axis.horizontal)); // top
        list.add(LedBar(id: 'H-${idCounter++}', rect: Rect.zero, orientation: Axis.horizontal)); // bottom
        list.add(LedBar(id: 'V-${idCounter++}', rect: Rect.zero, orientation: Axis.vertical));   // left
        list.add(LedBar(id: 'V-${idCounter++}', rect: Rect.zero, orientation: Axis.vertical));   // right
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
            onPressed: () {
              setState(() {
                for (final b in _allBars) b.on = false;
              });
            },
            icon: const Icon(Icons.power_settings_new),
          ),
          IconButton(
            tooltip: 'All On',
            onPressed: () {
              setState(() {
                for (final b in _allBars) {
                  b.on = true;
                  b.brightness = 1.0;
                }
              });
            },
            icon: const Icon(Icons.light_mode),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final W = constraints.maxWidth;
          final H = constraints.maxHeight;

          // Usable area after edge padding
          final usableW = (W - 2 * edgePaddingPx).clamp(0, double.infinity);
          final usableH = (H - 2 * edgePaddingPx).clamp(0, double.infinity);

          // Compute the largest possible square size that fits a cols×rows grid with fixed gaps.
          final sX = (usableW - (cols - 1) * gapPx) / cols;
          final sY = (usableH - (rows - 1) * gapPx) / rows;
          final s = sX < sY ? sX : sY; // perfect square side length

          // Actual grid size that will be rendered
          final gridW = cols * s + (cols - 1) * gapPx;
          final gridH = rows * s + (rows - 1) * gapPx;

          // Center the grid within the screen
          final offsetX = (W - gridW) / 2;
          final offsetY = (H - gridH) / 2;

          // Bar thickness relative to square size
          final barT = (s * barThicknessRatio).clamp(2.0, 24.0);

          // Build pixel Positioned widgets for all bars, mapped to our existing LedBar states.
          final children = <Widget>[];

          int barIndex = 0;
          for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
              final cellLeft = offsetX + c * (s + gapPx);
              final cellTop  = offsetY + r * (s + gapPx);

              // Top bar
              final topBar = _allBars[barIndex++];
              children.add(Positioned(
                left: cellLeft,
                top: cellTop,
                width: s,
                height: barT,
                child: BarWidget(bar: topBar, onTap: () => _editBar(topBar)),
              ));

              // Bottom bar
              final bottomBar = _allBars[barIndex++];
              children.add(Positioned(
                left: cellLeft,
                top: cellTop + s - barT,
                width: s,
                height: barT,
                child: BarWidget(bar: bottomBar, onTap: () => _editBar(bottomBar)),
              ));

              // Left bar
              final leftBar = _allBars[barIndex++];
              children.add(Positioned(
                left: cellLeft,
                top: cellTop,
                width: barT,
                height: s,
                child: BarWidget(bar: leftBar, onTap: () => _editBar(leftBar)),
              ));

              // Right bar
              final rightBar = _allBars[barIndex++];
              children.add(Positioned(
                left: cellLeft + s - barT,
                top: cellTop,
                width: barT,
                height: s,
                child: BarWidget(bar: rightBar, onTap: () => _editBar(rightBar)),
              ));
            }
          }

          // Legend/status
          // children.add(
          //   Positioned(
          //     left: 16,
          //     right: 16,
          //     bottom: 16,
          //     child: LegendCard(bars: _allBars),
          //   ),
          // );

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
              ...children,
            ],
          );
        },
      ),
    );
  }
}
