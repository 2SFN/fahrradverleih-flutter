import 'package:fahrradverleih/model/fahrradtyp.dart';
import 'package:fahrradverleih/widget/rad_icon.dart';
import 'package:flutter/material.dart';

/// Erweiterbares List-Item, welches ein Icon und den Rad-Typen zu einem
/// [Fahrrad] anzeigt.
///
/// Kann durch [extensions] einfach erweitert werden.
class RadItemBase extends StatelessWidget {
  const RadItemBase({
    Key? key,
    required this.typ,
    this.extensions = const [],
  }) : super(key: key);

  final FahrradTyp typ;
  final List<Widget> extensions;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          RadIcon(typ: typ, width: 92),
          const Padding(padding: EdgeInsets.all(8)),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(typ.bezeichnung, style: primaryTextStyle),
                  spacing,
                  ...extensions
                ]),
          )
        ]));
  }

  static const spacing = Padding(padding: EdgeInsets.all(2));

  static const primaryTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  static const secondaryTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
}
