part of 'startup_bloc.dart';

/// Beschreibt den anzuzeigenden "Inhalt"
enum StartupContent {
  /// Splash-Screen, welcher im Hintergrund das hinterlegte Token prüft.
  /// Implementiert in [ContentAuth]
  authentication,

  /// Login-Formular für den Anwender; implementiert in [ContentLogin].
  login,

  /// Registrierung; im Rahmen des Fallbeispiels nicht implementiert.
  register,

  /// Einfacher Willkommens-Bildschirm, implementiert in [ContentWelcome].
  welcome
}

/// Beschreibt den Zustand der Authentifizierung.
/// Zutreffend bei den Inhalten [StartupContent.authentication],
/// [StartupContent.login] und [StartupContent.register].
enum AuthenticationStatus { idle, authenticating, failed }

class StartupState extends Equatable {
  const StartupState(
      {this.content = StartupContent.authentication,
      this.authenticationStatus = AuthenticationStatus.idle,
      this.password = "",
      this.email = ""});

  final StartupContent content;
  final AuthenticationStatus authenticationStatus;

  final String email;
  final String password;

  @override
  List<Object?> get props => [content, authenticationStatus, email, password];

  StartupState copyWith({
    StartupContent? content,
    AuthenticationStatus? authenticationStatus,
    String? email,
    String? password,
  }) {
    return StartupState(
      content: content ?? this.content,
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
