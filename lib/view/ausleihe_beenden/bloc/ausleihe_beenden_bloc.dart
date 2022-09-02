import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/station.dart';

part 'ausleihe_beenden_event.dart';

part 'ausleihe_beenden_state.dart';

class AusleiheBeendenBloc
    extends Bloc<AusleiheBeendenEvent, AusleiheBeendenState> {
  AusleiheBeendenBloc({required RadApi api})
      : _api = api,
        super(const AusleiheBeendenState()) {
    on<FirstConstructed>(_onFirstConstructed);
    on<StationSelected>(_onStationSelected);
    on<BeendenRequested>(_onBeendenRequested);
    on<RetryRequested>(_onRetryRequested);
    on<AusleiheBeendenCancelled>(_onCancelled);
  }

  final RadApi _api;

  _onFirstConstructed(
      FirstConstructed event, Emitter<AusleiheBeendenState> emit) async {
    emit(state.copyWith(
        status: AusleiheBeendenStatus.fetching, ausleihe: event.ausleihe));
    await _fetchData(emit);
  }

  _onStationSelected(
      StationSelected event, Emitter<AusleiheBeendenState> emit) {
    emit(state.copyWith(auswahl: event.station));
  }

  _onBeendenRequested(
      BeendenRequested event, Emitter<AusleiheBeendenState> emit) async {
    if (state.auswahl != null && state.ausleihe != null) {
      emit(state.copyWith(status: AusleiheBeendenStatus.fetching));
      try {
        Future.delayed(const Duration(seconds: 1));
        var result = await _api.beendeAusleihe(
            ausleiheId: state.ausleihe!.id, stationId: state.auswahl!.id);
        // Neues, möglicherweise geändertes [Ausleihe]-Objekt mit aktualisieren
        emit(state.copyWith(
            status: AusleiheBeendenStatus.succeeded, ausleihe: result));
      } catch (e) {
        emit(state.copyWith(status: AusleiheBeendenStatus.failed));
      }
    }
  }

  _onRetryRequested(
      RetryRequested event, Emitter<AusleiheBeendenState> emit) async {
    await _fetchData(emit);
  }

  _onCancelled(
      AusleiheBeendenCancelled event, Emitter<AusleiheBeendenState> emit) {
    emit(state.copyWith(status: AusleiheBeendenStatus.cancelled));
  }

  _fetchData(Emitter<AusleiheBeendenState> emit) async {
    emit(state.copyWith(
        status: AusleiheBeendenStatus.fetching,
        stationen: const [],
        auswahl: null));
    try {
      await Future.delayed(const Duration(seconds: 1));
      var result = await _api.getStationen();
      emit(state.copyWith(
          status: AusleiheBeendenStatus.idle, stationen: result));
    } catch (e) {
      emit(state.copyWith(status: AusleiheBeendenStatus.failed));
    }
  }
}
