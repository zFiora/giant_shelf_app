import 'package:flutter/material.dart';
import 'package:giant_shelf_app/models/ledBar.dart';


class BarWidget extends StatelessWidget {
  const BarWidget({super.key, required this.bar, required this.onTap});

  final LedBar bar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'LED segment ${bar.id}',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          decoration: BoxDecoration(
            color: bar.displayColor,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              if (bar.on && bar.brightness > 0.65)
                const BoxShadow(blurRadius: 10, spreadRadius: 1),
            ],
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                bar.id,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.55),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
