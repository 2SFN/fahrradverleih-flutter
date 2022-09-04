import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/station.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required RadApi api})
      : _api = api,
        super(const MapState()) {
    on<FirstConstructed>(_onFirstConstructed);
    on<StationSelected>(_onStationSelected);
    on<BuchungAbgeschlossen>(_onBuchungAbgeschlossen);
    on<RetryRequested>(_onRetryRequested);
  }

  final RadApi _api;

  _onFirstConstructed(FirstConstructed event, Emitter<MapState> emit) async {
    await _fetchStationen(emit);
  }

  _onStationSelected(StationSelected event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapStatus.ausleihe, auswahl: event.auswahl));
  }

  _onBuchungAbgeschlossen(BuchungAbgeschlossen event, Emitter<MapState> emit) {
    // TODO
  }

  _onRetryRequested(RetryRequested event, Emitter<MapState> emit) {
    emit(const MapState());
    add(const FirstConstructed());
  }

  _fetchStationen(Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.fetching, stationen: const [], auswahl: null));
    try {
      var result = await _api.getStationen();
      emit(state.copyWith(status: MapStatus.idle, stationen: result));
    }catch(e) {
      emit(state.copyWith(status: MapStatus.failure));
    }
  }

}
