import 'package:fahrradverleih/model/fahrradtyp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RadIcon extends StatelessWidget {
  const RadIcon({Key? key, required this.typ, required this.width})
      : super(key: key);

  final FahrradTyp typ;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (!zuordnung.containsKey(typ.bezeichnung)) {
      return Icon(Icons.pedal_bike_outlined,
          semanticLabel: typ.bezeichnung, size: width);
    } else {
      return SvgPicture.asset(
        zuordnung[typ.bezeichnung]!,
        width: width,
        colorBlendMode: BlendMode.color,
        fit: BoxFit.fitWidth,
        semanticsLabel: typ.bezeichnung,
      );
    }
  }

  static const Map<String, String> zuordnung = {
    "City-Bike": "assets/icons/rad/smart.svg",
    "Jugendrad": "assets/icons/rad/kids.svg",
    "Lastenrad": "assets/icons/rad/cargo.svg",
    "E-Bike": "assets/icons/rad/ebike.svg"
  };
}
