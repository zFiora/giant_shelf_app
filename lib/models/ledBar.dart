import 'package:flutter/material.dart';

/// A single LED segment (bar) on the shelf map.
class LedBar {
  LedBar({
    required this.id,
    required this.rect,
    required this.orientation,
    this.color = const Color(0xFFFFA000),
    this.on = true,
    this.brightness = 1.0,
  });

  final String id; // e.g., H-1, V-7
  final Rect rect; // normalized (0..1) within the canvas
  final Axis orientation;

  Color color;
  bool on;
  double brightness;

  Color get displayColor {
    final a = (on ? 1.0 : 0.15) * brightness;
    return color.withOpacity(a.clamp(0.0, 1.0));
  }
}
