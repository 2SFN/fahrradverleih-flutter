part of 'rad_auswahl_bloc.dart';

enum RadAuswahlStatus {
  fetching,
  failed,
  cancelled,
  done,
  auswahlTyp,
  auswahlRad
}

class RadAuswahlState extends Equatable {
  const RadAuswahlState({
    this.status = RadAuswahlStatus.fetching,
    this.station = Station.empty,
    this.raeder = const [],
    this.typen = const [],
    this.auswahlTyp,
    this.auswahlRad,
  });

  final RadAuswahlStatus status;
  final Station station;
  final List<Fahrrad> raeder;
  final List<RadKategorie> typen;
  final FahrradTyp? auswahlTyp;
  final Fahrrad? auswahlRad;

  List<Fahrrad> get raederGefiltert =>
      List.of(raeder.where((rad) => rad.typ == auswahlTyp));

  @override
  List<Object?> get props =>
      [status, station, raeder, typen, auswahlTyp, auswahlRad];

  RadAuswahlState copyWith({
    RadAuswahlStatus? status,
    Station? station,
    List<Fahrrad>? raeder,
    List<RadKategorie>? typen,
    FahrradTyp? auswahlTyp,
    Fahrrad? auswahlRad,
  }) {
    return RadAuswahlState(
      status: status ?? this.status,
      station: station ?? this.station,
      raeder: raeder ?? this.raeder,
      typen: typen ?? this.typen,
      auswahlTyp: auswahlTyp ?? this.auswahlTyp,
      auswahlRad: auswahlRad ?? this.auswahlRad,
    );
  }
}
