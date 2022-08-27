import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/model/fahrradtyp.dart';
import 'package:fahrradverleih/model/geoposition.dart';

class Fahrrad extends Equatable {
  final String id;
  final GeopositionT position;
  final FahrradTyp typ;

  const Fahrrad({required this.id, required this.position, required this.typ});

  @override
  List<Object?> get props => [id, position, typ];

  @override
  String toString() => "${typ.bezeichnung} [$id]";

  Fahrrad copyWith({
    String? id,
    GeopositionT? position,
    FahrradTyp? typ,
  }) =>
      Fahrrad(
        id: id ?? this.id,
        position: position ?? this.position,
        typ: typ ?? this.typ,
      );

  factory Fahrrad.fromJson(Map<String, dynamic> json) => Fahrrad(
        id: json["id"],
        position: GeopositionT.fromJson(json["position"]),
        typ: FahrradTyp.fromJson(json["typ"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position.toJson(),
        "typ": typ.toJson(),
      };
}
