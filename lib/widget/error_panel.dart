import 'package:flutter/material.dart';

/// Ein einheitliches Widget, welches bei kritischen Fehlern anstelle des
/// eigentlichen Inhalts eingesetzt wird.
class ErrorPanel extends StatelessWidget {
  const ErrorPanel(
      {Key? key,
      this.icon = _defaultIcon,
      this.title = "Fehler",
      this.message = "Ein unerwarteter Fehler ist aufgetreten.",
      this.retryLabel = "Erneut Versuchen",
      this.onRetry})
      : super(key: key);

  final Widget icon;
  final String title;
  final String? message;
  final String retryLabel;
  final Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        icon,
        Text(title),
        if (message != null) Text(message!),
        TextButton(onPressed: onRetry, child: Text(retryLabel))
      ]),
    ));
  }

  static const Widget _defaultIcon =
      Icon(Icons.error, size: 48, semanticLabel: "Fehler");
}
