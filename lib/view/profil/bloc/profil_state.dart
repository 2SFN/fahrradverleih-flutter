part of 'profil_bloc.dart';

/// Beschreibt den aktuellen Zustand der Profil-Ansicht.
enum JobState {
  /// Ruft gerade Benutzer-Informationen ab.
  fetching,

  /// Speichert gerade Benutzer-Informationen.
  saving,

  /// Während einer Operation ist ein Fehler aufgetreten.
  ///
  /// In diesem Fall ist vorgesehen, dass dem Anwender angeboten wird, den
  /// Inhalt neu zu laden. Unabhängig vom vorherigen Zustand soll sich der
  /// Bloc dann verhalten, als wäre er gerade erstellt worden (Reset).
  failed,

  /// Daten wurden abgerufen und können vom Anwender manipuliert werden.
  idle,

  /// Der Anwender hat sich abgemeldet.
  ///
  /// Ist dieser Zustand aktiv, soll zu der [StartupPage] navigiert werden.
  logout
}

/// Zustand der Profil-Ansicht.
class ProfilState extends Equatable {
  const ProfilState({
    this.benutzer = Benutzer.empty,
    this.jobState = JobState.fetching,
  });

  final Benutzer benutzer;
  final JobState jobState;

  @override
  List<Object?> get props => [benutzer, jobState];

  ProfilState copyWith({
    Benutzer? benutzer,
    JobState? jobState,
  }) {
    return ProfilState(
      benutzer: benutzer ?? this.benutzer,
      jobState: jobState ?? this.jobState,
    );
  }
}
