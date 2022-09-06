part of 'neue_ausleihe_bloc.dart';

abstract class NeueAusleiheEvent extends Equatable {
  const NeueAusleiheEvent();

  @override
  List<Object?> get props => [];
}

class FirstConstructed extends NeueAusleiheEvent {
  const FirstConstructed(this.rad);

  final Fahrrad rad;

  @override
  List<Object?> get props => [rad];
}

class PlusClicked extends NeueAusleiheEvent {
  const PlusClicked();
}

class MinusClicked extends NeueAusleiheEvent {
  const MinusClicked();
}

class BuchenClicked extends NeueAusleiheEvent {
  const BuchenClicked();
}

class CancelClicked extends NeueAusleiheEvent {
  const CancelClicked();
}
