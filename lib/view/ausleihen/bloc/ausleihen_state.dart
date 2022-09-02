part of 'ausleihen_bloc.dart';

enum JobState { fetching, failed, idle, rueckgabe }

class AusleihenState extends Equatable {
  const AusleihenState({
    this.jobState = JobState.fetching,
    this.ausleihen = const [],
    this.auswahl
  });

  final JobState jobState;
  final List<Ausleihe> ausleihen;
  final Ausleihe? auswahl;

  @override
  List<Object?> get props => [jobState, ausleihen, auswahl];

  AusleihenState copyWith({
    JobState? jobState,
    List<Ausleihe>? ausleihen,
    Ausleihe? auswahl,
  }) {
    return AusleihenState(
      jobState: jobState ?? this.jobState,
      ausleihen: ausleihen ?? this.ausleihen,
      auswahl: auswahl ?? this.auswahl,
    );
  }
}
