import 'package:flutter/material.dart';

/// Einfacher Splash-Screen mit einem Lade-Indikator.
class ContentAuth extends StatelessWidget {
  const ContentAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(12), child: CircularProgressIndicator());
  }
}
