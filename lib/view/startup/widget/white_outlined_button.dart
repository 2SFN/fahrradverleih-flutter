import 'package:flutter/material.dart';

class WhiteOutlinedButton extends OutlinedButton {
  const WhiteOutlinedButton(
      {Key? key, required VoidCallback? onPressed, required Widget child})
      : super(key: key, onPressed: onPressed, child: child);

  @override
  ButtonStyle? get style => OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white.withOpacity(0.5),
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 18
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      minimumSize: const Size(220, 35),
      side: const BorderSide(color: Colors.white, width: 1));
}
