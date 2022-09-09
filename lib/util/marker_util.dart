import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utility-Klasse mit Funktionen, welche ein Marker-Icon mit einem
/// Label generieren können.
class MarkerUtil {
  static String? _rawIconData;

  /// Ziel-Größe des Icons
  static const double _iconSize = 48;

  /// Generiert ein Marker-Icon mit einem Label als [BitmapDescriptor] für
  /// Google Maps.
  ///
  /// Lösung orientiert sich an https://stackoverflow.com/a/63201170.
  static Future<BitmapDescriptor> paintMarker(BuildContext context,
      {count = "0"}) async {
    // Ziel-Größe berechnen, abhängig von der Plattform-Pixeldichte
    double dimensions = MediaQuery.of(context).devicePixelRatio * _iconSize;

    // Rohdaten für das Icon lesen und Platzhalter (hier: $c) durch
    // String aus Argument ersetzen
    String rawIconData = await _getRawIconData(context);
    String iconData = rawIconData.replaceAll("@c", count);

    // Zeichnen des Icons
    DrawableRoot drawableRoot = await svg.fromSvgString(iconData, "icon");
    var picture = drawableRoot.toPicture(size: Size(dimensions, dimensions));
    var image = await picture.toImage(dimensions.toInt(), dimensions.toInt());

    // PNG Byte-Daten für Maps
    var bytes = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  static Future<String> _getRawIconData(BuildContext context) async {
    _rawIconData ??= await DefaultAssetBundle.of(context)
        .loadString("assets/icons/marker_count.svg");
    return _rawIconData!;
  }
}
