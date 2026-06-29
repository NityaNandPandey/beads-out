import 'package:flutter/material.dart';

enum BeadColor {
  red,
  blue,
  green,
  yellow,
  purple,
  orange,
  pink,
  cyan,
}

extension BeadColorExtension on BeadColor {
  String get displayName {
    return switch (this) {
      BeadColor.red => 'Red',
      BeadColor.blue => 'Blue',
      BeadColor.green => 'Green',
      BeadColor.yellow => 'Yellow',
      BeadColor.purple => 'Purple',
      BeadColor.orange => 'Orange',
      BeadColor.pink => 'Pink',
      BeadColor.cyan => 'Cyan',
    };
  }

  /// Pastel fill color matching Beads Out aesthetic.
  Color get color {
    return Color(colorValue);
  }

  /// Slightly darker shade for borders and shadows.
  Color get darkColor {
    return Color(darkColorValue);
  }

  int get colorValue {
    return switch (this) {
      BeadColor.red => 0xFFFF5252,
      BeadColor.blue => 0xFF448AFF,
      BeadColor.green => 0xFF00E676,
      BeadColor.yellow => 0xFFFFD740,
      BeadColor.purple => 0xFF7C4DFF,
      BeadColor.orange => 0xFFFF9100,
      BeadColor.pink => 0xFFFF4081,
      BeadColor.cyan => 0xFF00E5FF,
    };
  }

  int get darkColorValue {
    return switch (this) {
      BeadColor.red => 0xFFD50000,
      BeadColor.blue => 0xFF2962FF,
      BeadColor.green => 0xFF00C853,
      BeadColor.yellow => 0xFFFFAB00,
      BeadColor.purple => 0xFF651FFF,
      BeadColor.orange => 0xFFE65100,
      BeadColor.pink => 0xFFC51162,
      BeadColor.cyan => 0xFF00B8D4,
    };
  }
}
