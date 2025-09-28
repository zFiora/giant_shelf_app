import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:giant_shelf_app/models/ledBar.dart';


class BarEditor extends StatefulWidget {
  const BarEditor({super.key, required this.bar});
  final LedBar bar;

  @override
  State<BarEditor> createState() => _BarEditorState();
}

class _BarEditorState extends State<BarEditor> {
  late bool on = widget.bar.on;
  late double brightness = widget.bar.brightness;
  late Color color = widget.bar.color;

  @override
  Widget build(BuildContext context) {
    final display = color.withOpacity((on ? 1.0 : 0.15) * brightness);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8,
            width: 60,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Row(
            children: [
              Text('Edit ${widget.bar.id}',
                  style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Switch.adaptive(
                value: on,
                onChanged: (v) => setState(() => on = v),
              ),
              const SizedBox(width: 6),
              Text(on ? 'On' : 'Off'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: display,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            alignment: Alignment.center,
            child: const Text('Preview'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined),
              Expanded(
                child: Slider(
                  value: brightness,
                  onChanged: (v) => setState(() => brightness = v),
                  min: 0.0,
                  max: 1.0,
                ),
              ),
              const Icon(Icons.wb_sunny),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Color'),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: color,
                          onColorChanged: (c) => setState(() => color = c),
                          enableAlpha: false,
                          labelTypes: const [],
                          portraitOnly: true,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  BarEditResult(
                    on: on,
                    brightness: brightness,
                    color: color,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

/// Result object returned from the editor.
class BarEditResult {
  BarEditResult({
    required this.on,
    required this.brightness,
    required this.color,
  });
  final bool on;
  final double brightness;
  final Color color;
}
