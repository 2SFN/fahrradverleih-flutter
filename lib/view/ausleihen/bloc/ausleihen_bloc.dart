import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';

part 'ausleihen_event.dart';

part 'ausleihen_state.dart';

class AusleihenBloc extends Bloc<AusleihenEvent, AusleihenState> {
  AusleihenBloc({required RadApi api})
      : _api = api,
        super(const AusleihenState()) {
    on<FirstConstructed>(_onFirstConstructed);
    on<ReloadRequested>(_onReloadRequested);
    on<AusleiheSelected>(_onAusleiheSelected);
    on<RueckgabeAbgeschlossen>(_onRueckgabeAbgeschlossen);
  }

  final RadApi _api;

  _onFirstConstructed(
      FirstConstructed event, Emitter<AusleihenState> emit) async {
    await _fetchData(emit);
  }

  _onReloadRequested(
      ReloadRequested event, Emitter<AusleihenState> emit) async {
    await _fetchData(emit);
  }

  _onAusleiheSelected(AusleiheSelected event, Emitter<AusleihenState> emit) {
    emit(state.copyWith(jobState: JobState.rueckgabe, auswahl: event.ausleihe));
  }

  _onRueckgabeAbgeschlossen(
      RueckgabeAbgeschlossen event, Emitter<AusleihenState> emit) {
    // Ausleihe aktualisieren, falls sich etwas geändert hat
    if (event.ausleihe != null) {
      var ausleihen = List<Ausleihe>.from(state.ausleihen);
      var index = ausleihen.indexWhere((a) => a.id == event.ausleihe!.id);
      if (index >= 0) {
        ausleihen[index] = event.ausleihe!;
      }

      emit(state.copyWith(
          jobState: JobState.idle, ausleihen: ausleihen, auswahl: null));
    } else {
      emit(state.copyWith(jobState: JobState.idle, auswahl: null));
    }
  }

  _fetchData(Emitter<AusleihenState> emit) async {
    emit(state.copyWith(jobState: JobState.fetching, ausleihen: const []));
    try {
      await Future.delayed(const Duration(seconds: 1));
      var result = await _api.getAusleihen();
      emit(state.copyWith(jobState: JobState.idle, ausleihen: result));
    } catch (e) {
      emit(state.copyWith(jobState: JobState.failed));
    }
  }
}
