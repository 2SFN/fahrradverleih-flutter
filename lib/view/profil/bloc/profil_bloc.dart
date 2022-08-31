import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/api/remote/remote_rad_api.dart';
import 'package:fahrradverleih/model/benutzer.dart';
import 'package:fahrradverleih/util/prefs.dart';
import 'package:fahrradverleih/view/startup/startup_page.dart';

part 'profil_event.dart';

part 'profil_state.dart';

class ProfilBloc extends Bloc<ProfilEvent, ProfilState> {
  ProfilBloc({required RadApi api})
      : _api = api,
        super(const ProfilState()) {
    on<FirstConstructed>(_onFirstConstructed);
    on<RetryRequested>(_onRetryRequested);
    on<SaveRequested>(_onSaveRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<FormVornameChanged>(_onFormVornameChanged);
    on<FormNachnameChanged>(_onFormNachnameChanged);
    on<FormEmailChanged>(_onFormEmailChanged);
  }

  final RadApi _api;

  /// Löst das [FirstConstructed] Event aus, um Daten abzurufen.
  ProfilBloc firstConstructed() {
    add(const FirstConstructed());
    return this;
  }

  _onFirstConstructed(FirstConstructed event, Emitter<ProfilState> emit) async {
    emit(const ProfilState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      var benutzer = await _api.getBenutzer();
      emit(state.copyWith(benutzer: benutzer, jobState: JobState.idle));
    } catch (e) {
      emit(state.copyWith(jobState: JobState.failed));
    }
  }

  _onRetryRequested(RetryRequested event, Emitter<ProfilState> emit) {
    if(state.jobState != JobState.failed) {
      return;
    }

    add(const FirstConstructed());
  }

  _onSaveRequested(SaveRequested event, Emitter<ProfilState> emit) async {
    if(state.jobState != JobState.idle) {
      return;
    }

    emit(state.copyWith(jobState: JobState.saving));
    try {
      await Future.delayed(const Duration(seconds: 1));
      var benutzer = await _api.setBenutzer(benutzer: state.benutzer);
      emit(state.copyWith(benutzer: benutzer, jobState: JobState.idle));
    }catch(e){
      emit(state.copyWith(jobState: JobState.failed));
    }
  }

  _onLogoutRequested(LogoutRequested event, Emitter<ProfilState> emit) async {
    // Gespeichertes Token löschen (und ggf. API informieren)
    Prefs.remove(Prefs.keyToken);
    if (_api is RemoteRadApi) {
      (_api as RemoteRadApi).init("");
    }

    emit(state.copyWith(jobState: JobState.logout));
  }

  _onFormVornameChanged(FormVornameChanged event, Emitter<ProfilState> emit) {
    emit(state.copyWith(
        benutzer: state.benutzer.copyWith(vorname: event.vorname)));
  }

  _onFormNachnameChanged(FormNachnameChanged event, Emitter<ProfilState> emit) {
    emit(state.copyWith(
        benutzer: state.benutzer.copyWith(name: event.nachname)));
  }

  _onFormEmailChanged(FormEmailChanged event, Emitter<ProfilState> emit) {
    emit(state.copyWith(benutzer: state.benutzer.copyWith(email: event.email)));
  }
}
