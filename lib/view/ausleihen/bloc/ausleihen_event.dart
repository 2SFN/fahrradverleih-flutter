part of 'ausleihen_bloc.dart';

abstract class AusleihenEvent extends Equatable {
  const AusleihenEvent();

  @override
  List<Object?> get props => [];
}

class FirstConstructed extends AusleihenEvent {
  const FirstConstructed();
}

class ReloadRequested extends AusleihenEvent {
  const ReloadRequested();
}

class AusleiheSelected extends AusleihenEvent {
  const AusleiheSelected(this.ausleihe);

  final Ausleihe ausleihe;

  @override
  List<Object?> get props => [ausleihe];
}
