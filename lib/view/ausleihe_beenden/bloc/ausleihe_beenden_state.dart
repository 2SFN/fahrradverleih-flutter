part of 'ausleihe_beenden_bloc.dart';

enum AusleiheBeendenStatus { fetching, idle, failed, succeeded, cancelled }

class AusleiheBeendenState extends Equatable {
  const AusleiheBeendenState({
    this.ausleihe,
    this.status = AusleiheBeendenStatus.fetching,
    this.stationen = const [],
    this.auswahl,
  });

  final AusleiheBeendenStatus status;
  final Ausleihe? ausleihe;
  final List<Station> stationen;
  final Station? auswahl;

  @override
  List<Object?> get props => [status, ausleihe, stationen, auswahl];

  AusleiheBeendenState copyWith({
    AusleiheBeendenStatus? status,
    Ausleihe? ausleihe,
    List<Station>? stationen,
    Station? auswahl,
  }) {
    return AusleiheBeendenState(
      status: status ?? this.status,
      ausleihe: ausleihe ?? this.ausleihe,
      stationen: stationen ?? this.stationen,
      auswahl: auswahl ?? this.auswahl,
    );
  }
}
