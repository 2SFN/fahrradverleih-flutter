import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/model/fahrradtyp.dart';

class RadKategorie extends Equatable {
  const RadKategorie({
    required this.typ,
    required this.verfuegbar,
  });

  final FahrradTyp typ;
  final int verfuegbar;

  @override
  List<Object?> get props => [typ.bezeichnung];

  RadKategorie add() => copyWith(verfuegbar: verfuegbar + 1);

  RadKategorie copyWith({
    FahrradTyp? typ,
    int? verfuegbar,
  }) {
    return RadKategorie(
      typ: typ ?? this.typ,
      verfuegbar: verfuegbar ?? this.verfuegbar,
    );
  }
}