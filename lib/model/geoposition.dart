import 'package:equatable/equatable.dart';

class GeopositionT extends Equatable {
  final double breite;
  final double laenge;

  const GeopositionT({required this.breite, required this.laenge});

  @override
  List<Object?> get props => [breite, laenge];

  @override
  String toString() => "($breite,$laenge)";

  GeopositionT copyWith({
    double? breite,
    double? laenge,
  }) =>
      GeopositionT(
        breite: breite ?? this.breite,
        laenge: laenge ?? this.laenge,
      );

  factory GeopositionT.fromJson(Map<String, dynamic> json) => GeopositionT(
        breite: json["breite"].toDouble(),
        laenge: json["laenge"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "breite": breite,
        "laenge": laenge,
      };
}
