import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/tarif.dart';

class Ausleihe extends Equatable {
  final String id;
  final Fahrrad fahrrad;
  final TarifT tarif;
  final DateTime von;
  final DateTime bis;

  const Ausleihe(
      {required this.id,
      required this.fahrrad,
      required this.tarif,
      required this.von,
      required this.bis});

  @override
  List<Object?> get props => [id, fahrrad, tarif, von, bis];

  @override
  String toString() => "Ausleihe $id";

  Ausleihe copyWith({
    String? id,
    Fahrrad? fahrrad,
    TarifT? tarif,
    DateTime? von,
    DateTime? bis,
  }) =>
      Ausleihe(
        id: id ?? this.id,
        fahrrad: fahrrad ?? this.fahrrad,
        tarif: tarif ?? this.tarif,
        von: von ?? this.von,
        bis: bis ?? this.bis,
      );

  factory Ausleihe.fromJson(Map<String, dynamic> json) => Ausleihe(
        id: json["id"],
        fahrrad: Fahrrad.fromJson(json["fahrrad"]),
        tarif: TarifT.fromJson(json["tarif"]),
        von: DateTime.parse(json["von"]),
        bis: DateTime.parse(json["bis"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fahrrad": fahrrad.toJson(),
        "tarif": tarif.toJson(),
        "von": von.toIso8601String(),
        "bis": bis.toIso8601String(),
      };
}
