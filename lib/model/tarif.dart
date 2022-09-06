import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/model/currency.dart';

class TarifT extends Equatable {
  static const empty = TarifT(preis: CurrencyT.zero, taktung: 1);

  final CurrencyT preis;
  final int taktung;

  const TarifT({required this.preis, required this.taktung});

  @override
  List<Object?> get props => [preis, taktung];

  @override
  String toString() => "$preis pro $taktung Stunde(n)";

  TarifT copyWith({
    CurrencyT? preis,
    int? taktung,
  }) =>
      TarifT(
        preis: preis ?? this.preis,
        taktung: taktung ?? this.taktung,
      );

  factory TarifT.fromJson(Map<String, dynamic> json) => TarifT(
        preis: CurrencyT.fromJson(json["preis"]),
        taktung: json["taktung"],
      );

  Map<String, dynamic> toJson() => {
        "preis": preis.toJson(),
        "taktung": taktung,
      };
}
