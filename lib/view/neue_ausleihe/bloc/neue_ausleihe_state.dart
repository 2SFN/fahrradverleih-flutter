part of 'neue_ausleihe_bloc.dart';

enum NeueAusleiheStatus { idle, fetching, failure, success, cancelled }

class NeueAusleiheState extends Equatable {
  const NeueAusleiheState({
    this.status = NeueAusleiheStatus.idle,
    this.station = Station.empty,
    this.rad = Fahrrad.empty,
    this.dauer = 0,
    this.ausleihe
  });

  final NeueAusleiheStatus status;
  final Station station;
  final Fahrrad rad;
  final int dauer;
  final Ausleihe? ausleihe;

  @override
  List<Object?> get props => [status, station, rad, dauer, ausleihe];

  NeueAusleiheState copyWith({
    NeueAusleiheStatus? status,
    Station? station,
    Fahrrad? rad,
    int? dauer,
    Ausleihe? ausleihe,
  }) {
    return NeueAusleiheState(
      status: status ?? this.status,
      station: station ?? this.station,
      rad: rad ?? this.rad,
      dauer: dauer ?? this.dauer,
      ausleihe: ausleihe ?? this.ausleihe,
    );
  }
}
