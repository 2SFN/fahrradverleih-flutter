import 'package:flutter/material.dart';

/// Enthält Funktionen, die einheitliche [ButtonStyle]s generieren.
class ButtonStyles {
  static ButtonStyle primaryButtonStyle(BuildContext context,
      {compact = false}) {
    final color = Theme.of(context).primaryColor;
    final borderSide = BorderSide(color: color, width: 1);
    return OutlinedButton.styleFrom(
        // 'shrinkWrap' entfernt äußeres Margin
        tapTargetSize: compact
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
        // Erlaubt es dem Button, schmaler zu erscheinen
        minimumSize: const Size(200, 20),
        textStyle: const TextStyle(fontWeight: FontWeight.w400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        side: borderSide,
        shape: RoundedRectangleBorder(
            side: borderSide, borderRadius: BorderRadius.zero),
        foregroundColor: color);
  }

  static ButtonStyle dangerButtonStyle(BuildContext context,
      {compact = false}) {
    const color = Color(0xFFEB445A);
    const borderSide = BorderSide(color: color, width: 1);
    return primaryButtonStyle(context, compact: compact).copyWith(
        side: const MaterialStatePropertyAll(borderSide),
        foregroundColor: const MaterialStatePropertyAll(color));
  }

  static ButtonStyle secondaryButtonStyle(BuildContext context,
      {compact = false}) {
    const color = Color(0xFF5E5E5E);
    const borderSide = BorderSide(color: color, width: 1);
    return primaryButtonStyle(context, compact: compact).copyWith(
        side: const MaterialStatePropertyAll(borderSide),
        foregroundColor: const MaterialStatePropertyAll(color));
  }
}
