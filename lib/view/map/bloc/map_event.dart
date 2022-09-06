part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class FirstConstructed extends MapEvent {
  const FirstConstructed();
}

class StationSelected extends MapEvent {
  const StationSelected(this.auswahl);

  final Station auswahl;

  @override
  List<Object?> get props => [auswahl];
}

class RadSelected extends MapEvent {
  const RadSelected(this.auswahl);

  final Fahrrad? auswahl;

  @override
  List<Object?> get props => [auswahl];
}

class BuchungAbgeschlossen extends MapEvent {
  const BuchungAbgeschlossen(this.ausleihe);

  final Ausleihe? ausleihe;

  @override
  List<Object?> get props => [ausleihe];
}

class RetryRequested extends MapEvent {
  const RetryRequested();
}
