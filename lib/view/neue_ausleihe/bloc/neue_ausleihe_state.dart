part of 'neue_ausleihe_bloc.dart';

enum NeueAusleiheStatus { idle, fetching, failure, success, cancelled }

class NeueAusleiheState extends Equatable {
  const NeueAusleiheState({
    this.status = NeueAusleiheStatus.idle,
    this.rad = Fahrrad.empty,
    this.dauer = 0,
    this.ausleihe
  });

  final NeueAusleiheStatus status;
  final Fahrrad rad;
  final int dauer;
  final Ausleihe? ausleihe;

  @override
  List<Object?> get props => [status, rad, dauer, ausleihe];

  NeueAusleiheState copyWith({
    NeueAusleiheStatus? status,
    Fahrrad? rad,
    int? dauer,
    String? info,
    Ausleihe? ausleihe,
  }) {
    return NeueAusleiheState(
      status: status ?? this.status,
      rad: rad ?? this.rad,
      dauer: dauer ?? this.dauer,
      ausleihe: ausleihe ?? this.ausleihe,
    );
  }
}
