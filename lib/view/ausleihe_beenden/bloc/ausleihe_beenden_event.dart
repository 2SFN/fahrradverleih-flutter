part of 'ausleihe_beenden_bloc.dart';

abstract class AusleiheBeendenEvent extends Equatable {
  const AusleiheBeendenEvent();

  @override
  List<Object?> get props => [];
}

/// Da diese Seite die zu beendende Ausleihe als Argument annimmt, wird dieses
/// hier im FirstConstructed-Event als Parameter [ausleihe] mit aufgenommen.
class FirstConstructed extends AusleiheBeendenEvent {
  const FirstConstructed(this.ausleihe);

  final Ausleihe? ausleihe;

  @override
  List<Object?> get props => [ausleihe];
}

class StationSelected extends AusleiheBeendenEvent {
  const StationSelected(this.station);

  final Station station;

  @override
  List<Object?> get props => [station];
}

class BeendenRequested extends AusleiheBeendenEvent {
  const BeendenRequested();
}

class RetryRequested extends AusleiheBeendenEvent {
  const RetryRequested();
}

class AusleiheBeendenCancelled extends AusleiheBeendenEvent {
  const AusleiheBeendenCancelled();
}
