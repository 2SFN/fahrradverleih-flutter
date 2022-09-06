import 'package:fahrradverleih/model/fahrradtyp.dart';
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
          Icon(Icons.pedal_bike_outlined,
              size: 64, semanticLabel: typ.bezeichnung),
          Column(children: [Text(typ.bezeichnung), ...extensions])
        ]));
  }
}