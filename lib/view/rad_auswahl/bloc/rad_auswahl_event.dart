part of 'rad_auswahl_bloc.dart';

abstract class RadAuswahlEvent extends Equatable {
  const RadAuswahlEvent();

  @override
  List<Object?> get props => [];
}

class FirstConstructed extends RadAuswahlEvent {
  const FirstConstructed(this.station);

  final Station station;

  @override
  List<Object?> get props => [station];
}

class CancelClicked extends RadAuswahlEvent {
  const CancelClicked();
}

class TypSelected extends RadAuswahlEvent {
  const TypSelected(this.auswahl);

  final FahrradTyp auswahl;

  @override
  List<Object?> get props => [auswahl];
}

class RadSelected extends RadAuswahlEvent {
  const RadSelected(this.auswahl);

  final Fahrrad auswahl;

  @override
  List<Object?> get props => [auswahl];
}

class RetryRequested extends RadAuswahlEvent {
  const RetryRequested();
}
