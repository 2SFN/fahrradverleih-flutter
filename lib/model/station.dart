import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/model/geoposition.dart';

class Station extends Equatable {
  final String id;
  final String bezeichnung;
  final GeopositionT position;
  final int verfuegbar;

  const Station(
      {required this.id,
      required this.bezeichnung,
      required this.position,
      required this.verfuegbar});

  @override
  List<Object?> get props => [id, bezeichnung, position, verfuegbar];

  @override
  String toString() => "Station $bezeichnung [$id]";

  Station copyWith({
    String? id,
    String? bezeichnung,
    GeopositionT? position,
    int? verfuegbar,
  }) =>
      Station(
        id: id ?? this.id,
        bezeichnung: bezeichnung ?? this.bezeichnung,
        position: position ?? this.position,
        verfuegbar: verfuegbar ?? this.verfuegbar,
      );

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json["id"],
        bezeichnung: json["bezeichnung"],
        position: GeopositionT.fromJson(json["position"]),
        verfuegbar: json["verfuegbar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bezeichnung": bezeichnung,
        "position": position.toJson(),
        "verfuegbar": verfuegbar,
      };
}
