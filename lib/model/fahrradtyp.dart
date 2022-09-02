import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/model/tarif.dart';

class FahrradTyp extends Equatable {
  static const FahrradTyp empty =
      FahrradTyp(bezeichnung: "", tarif: TarifT.empty);

  final String bezeichnung;
  final TarifT tarif;

  const FahrradTyp({required this.bezeichnung, required this.tarif});

  @override
  List<Object?> get props => [bezeichnung, tarif];

  @override
  String toString() => "$bezeichnung ($tarif)";

  FahrradTyp copyWith({
    String? bezeichnung,
    TarifT? tarif,
  }) =>
      FahrradTyp(
          bezeichnung: bezeichnung ?? this.bezeichnung,
          tarif: tarif ?? this.tarif);

  factory FahrradTyp.fromJson(Map<String, dynamic> json) => FahrradTyp(
        bezeichnung: json["bezeichnung"],
        tarif: TarifT.fromJson(json["tarif"]),
      );

  Map<String, dynamic> toJson() => {
        "bezeichnung": bezeichnung,
        "tarif": tarif.toJson(),
      };
}
