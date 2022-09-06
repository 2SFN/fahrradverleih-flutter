import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/station.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required RadApi api})
      : _api = api,
        super(const MapState()) {
    on<FirstConstructed>(_onFirstConstructed);
    on<StationSelected>(_onStationSelected);
    on<RadSelected>(_onRadSelected);
    on<BuchungAbgeschlossen>(_onBuchungAbgeschlossen);
    on<RetryRequested>(_onRetryRequested);
  }

  final RadApi _api;

  _onFirstConstructed(FirstConstructed event, Emitter<MapState> emit) async {
    await _fetchStationen(emit);
  }

  _onStationSelected(StationSelected event, Emitter<MapState> emit) {
    emit(state.copyWith(
        status: MapStatus.radAuswahl, auswahlStation: event.auswahl));
  }

  _onRadSelected(RadSelected event, Emitter<MapState> emit) {
    if (event.auswahl == null) {
      emit(state.copyWith(
          status: MapStatus.idle, auswahlStation: null, auswahlRad: null));
    } else {
      emit(
          state.copyWith(status: MapStatus.buchung, auswahlRad: event.auswahl));
    }
  }

  _onBuchungAbgeschlossen(
      BuchungAbgeschlossen event, Emitter<MapState> emit) async {
    if (event.ausleihe != null) {
      emit(state.copyWith(
          status: MapStatus.buchungOk, auswahlRad: null, auswahlStation: null));
      // Aktualisiere Liste von Stationen
      await _fetchStationen(emit);
    } else {
      emit(state.copyWith(
          status: MapStatus.idle, auswahlStation: null, auswahlRad: null));
    }
  }

  _onRetryRequested(RetryRequested event, Emitter<MapState> emit) {
    emit(const MapState());
    add(const FirstConstructed());
  }

  _fetchStationen(Emitter<MapState> emit) async {
    emit(state.copyWith(
        status: MapStatus.fetching, stationen: const [], auswahlStation: null));
    try {
      var result = await _api.getStationen();
      emit(state.copyWith(status: MapStatus.idle, stationen: result));
    } catch (e) {
      emit(state.copyWith(status: MapStatus.failure));
    }
  }
}
