part of 'ausleihen_bloc.dart';

enum JobState { fetching, failed, idle }

class AusleihenState extends Equatable {
  const AusleihenState({
    this.jobState = JobState.fetching,
    this.ausleihen = const [],
  });

  final JobState jobState;
  final List<Ausleihe> ausleihen;

  @override
  List<Object?> get props => [jobState, ausleihen];

  AusleihenState copyWith({
    JobState? jobState,
    List<Ausleihe>? ausleihen,
  }) {
    return AusleihenState(
      jobState: jobState ?? this.jobState,
      ausleihen: ausleihen ?? this.ausleihen,
    );
  }
}
