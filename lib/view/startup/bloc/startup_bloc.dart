import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/api/remote/remote_rad_api.dart';
import 'package:fahrradverleih/util/prefs.dart';
import 'package:fahrradverleih/view/startup/startup_page.dart';
import 'package:fahrradverleih/view/startup/widget/content_auth.dart';
import 'package:fahrradverleih/view/startup/widget/content_login.dart';
import 'package:fahrradverleih/view/startup/widget/content_welcome.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'startup_event.dart';

part 'startup_state.dart';

/// Verwaltet den Zustand und Interaktionen mit der [StartupPage].
class StartupBloc extends Bloc<StartupEvent, StartupState> {
  StartupBloc({required RadApi api})
      : _api = api,
        super(const StartupState()) {
    // Event-Listeners
    on<AppStarted>(_onAppStart);
    on<StartupNavigationEvent>(_onNavigationEvent);
    on<BackPressed>(_onBackPressed);
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<AuthenticationFailed>(_onAuthenticationFailed);
  }

  final RadApi _api;

  /// Helfer-Funktion, die an der Stelle der Bloc-Erzeugung aufgerufen werden
  /// kann, um das [AppStarted]-Event auszulösen und die anfängliche
  /// Authentifizierung zu starten.
  StartupBloc appStarted() {
    add(const AppStarted());
    return this;
  }

  /// Stößt beim ersten Start die Authentifizierung an,
  /// s. [StartupBloc_authenticate].
  void _onAppStart(AppStarted event, Emitter<StartupState> emit) {
    add(const StartupNavigationEvent(StartupContent.authentication));
  }

  /// Behandelt die interne Navigation zwischen Inhalten (definiert in
  /// [StartupContent]) und führt mit den jeweiligen Zuständen verbundene
  /// Aktionen aus.
  void _onNavigationEvent(
      StartupNavigationEvent event, Emitter<StartupState> emit) async {
    switch (event.content) {
      case StartupContent.authentication:
        await _authenticate(emit, event);
        break;
      case StartupContent.login:
        emit(state.copyWith(
            content: event.content,
            authenticationStatus: AuthenticationStatus.idle,
            email: "",
            password: ""));
        break;
      case StartupContent.register:
        // Im Rahmen des Fallbeispiels nicht implementiert
        break;
      case StartupContent.welcome:
        emit(state.copyWith(
            content: event.content,
            authenticationStatus: AuthenticationStatus.idle,
            email: "",
            password: ""));
        break;
    }
  }

  /// Reagiert auf Interaktion mit dem Zurück-Button/-Geste.
  _onBackPressed(BackPressed event, Emitter<StartupState> emit) {
    if(state.authenticationStatus != AuthenticationStatus.authenticating) {
      add(const StartupNavigationEvent(StartupContent.welcome));
    }
  }

  /// Stellt sicher, dass das gespeicherte Token (falls vorhanden) von der
  /// API akzeptiert wird.
  /// Ist dies nicht der Fall (entweder es liegt noch kein Token vor, oder es
  /// ist z.B. abgelaufen), dann wird zum [StartupContent.welcome]-Inhalt
  /// gewechselt, und der Anwender kann sich neu authentifizieren.
  Future<void> _authenticate(
      Emitter<StartupState> emit, StartupNavigationEvent event) async {
    emit(state.copyWith(
        content: event.content,
        authenticationStatus: AuthenticationStatus.authenticating));
    try {
      await Future.delayed(const Duration(seconds: 1));
      await _api.auth();
      // TODO: Success! Navigate away...
    } catch (e) {
      emit(state.copyWith(content: StartupContent.welcome));
      add(AuthenticationFailed("Authentifizierung fehlgeschlagen: $e\n\n"
          "Bitte melden Sie sich neu an."));
    }
  }

  _onEmailChanged(LoginEmailChanged event, Emitter<StartupState> emit) {
    emit(state.copyWith(email: event.email));
  }

  _onPasswordChanged(LoginPasswordChanged event, Emitter<StartupState> emit) {
    emit(state.copyWith(password: event.password));
  }

  /// Fragt bei der API mit den eingegebenen Login-Daten eine neue Session an.
  /// Ist die Anfrage erfolgreich, wird das Token gespeichert, angewendet,
  /// und anschließend wird wieder zum [StartupContent.authentication]-Inhalt
  /// gewechselt.
  _onLoginSubmitted(LoginSubmitted event, Emitter<StartupState> emit) async {
    emit(state.copyWith(
        authenticationStatus: AuthenticationStatus.authenticating));

    try {
      var loginResult =
          await _api.login(email: state.email, secret: state.password);

      if (!loginResult.ok) {
        throw const RadApiException("Login fehlgeschlagen!");
      }

      // Neues Token ablegen und in API-Instanz anwenden
      var token = loginResult.token;
      await Prefs.set(Prefs.keyToken, token);
      if (_api is RemoteRadApi) {
        await (_api as RemoteRadApi).init(token);
      }

      add(const StartupNavigationEvent(StartupContent.authentication));
    } catch (e) {
      add(AuthenticationFailed("Login fehlgeschlagen:\n$e"));
    }
  }

  /// Setzt bei fehlgeschlagener Authentifizierung den Status zurück.
  /// Weitere Maßnahmen, wie das Anzeigen einer entsprechenden
  /// Fehlermeldung, können vom Presentation-Layer ausgeführt werden.
  _onAuthenticationFailed(
      AuthenticationFailed event, Emitter<StartupState> emit) async {
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.failed));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.idle));
  }
}
