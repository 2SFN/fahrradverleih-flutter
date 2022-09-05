import 'package:flutter/material.dart';

class EndOfListItem extends StatelessWidget {
  static const defaultText = "Keine weiteren Elemente.";

  const EndOfListItem({Key? key, this.text = defaultText}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(20),
      child: Text(text)
    ));
  }
}