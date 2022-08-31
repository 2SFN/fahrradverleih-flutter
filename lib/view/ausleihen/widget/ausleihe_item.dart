import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AusleiheItem extends StatelessWidget {
  const AusleiheItem({Key? key, required this.ausleihe, this.onRueckgabe})
      : super(key: key);

  final Ausleihe ausleihe;
  final VoidCallback? onRueckgabe;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          // TODO: Ersetzen durch Rad-Spezifisches Icon
          Icon(Icons.pedal_bike,
              size: 64, semanticLabel: ausleihe.fahrrad.typ.bezeichnung),
          Column(children: [
            Text(ausleihe.fahrrad.typ.bezeichnung),
            Text(_tarifInfo()),
            Text(_rueckgabeInfo()),
            if (ausleihe.aktiv)
              ElevatedButton(
                onPressed: onRueckgabe,
                child: const Text("Zurückgeben"),
              )
          ])
        ]));
  }

  /// Rückgabe (bspw.):  Tarif: 6€ für 12 Stunden
  String _tarifInfo() {
    var t = ausleihe.tarif;
    var ppu = t.preis.betrag / t.taktung;
    double betrag = ausleihe.dauer.toDouble() * ppu;
    return "Tarif: ${t.preis.iso4217} ${_formatBetrag(betrag)} "
        "für ${ausleihe.dauer} Stunden";
  }

  /// Rückgabe (bspw.): Rückgabe bis 31.08.2022 um 11:00 Uhr
  String _rueckgabeInfo() {
    var bis = ausleihe.bis;
    if (ausleihe.aktiv) {
      return "Rückgabe bis ${_formatDate(bis)} um ${_formatTime(bis)} Uhr";
    } else {
      return "Zurückgegeben am ${_formatDate(bis)}";
    }
  }

  /// Formatiert einen Geldbetrag.
  ///
  /// Glatte Beträge werden ohne Dezimalstellen ausgegeben, z.B.:
  /// 2.334 -> 2.33
  /// 2.0 -> 2
  String _formatBetrag(double betrag) {
    return betrag.toStringAsFixed(betrag.truncateToDouble() == betrag ? 0 : 2);
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd.MM.yyyy", "de_DE").format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat("H:mm", "de_DE").format(date);
  }
}
