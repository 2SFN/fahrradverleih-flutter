import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/fahrradtyp.dart';
import 'package:fahrradverleih/model/station.dart';
import 'package:fahrradverleih/view/rad_auswahl/model/rad_kategorie.dart';

part 'rad_auswahl_event.dart';

part 'rad_auswahl_state.dart';

class RadAuswahlBloc extends Bloc<RadAuswahlEvent, RadAuswahlState> {
  RadAuswahlBloc({required RadApi api})
      : _api = api,
        super(const RadAuswahlState()) {
    on<FirstConstructed>(_onFirstConstructed);
    on<CancelClicked>(_onCancelClicked);
    on<TypSelected>(_onTypSelected);
    on<RadSelected>(_onRadSelected);
    on<RetryRequested>(_onRetryRequested);
  }

  final RadApi _api;

  _onFirstConstructed(
      FirstConstructed event, Emitter<RadAuswahlState> emit) async {
    emit(state.copyWith(
        status: RadAuswahlStatus.fetching, station: event.station));
    await _fetchData(emit);
  }

  _onCancelClicked(CancelClicked event, Emitter<RadAuswahlState> emit) {
    if (state.status == RadAuswahlStatus.auswahlRad) {
      // Wenn bereits eine Kategorie ausgewählt wurde, wird diese Auswahl
      // nur gelöscht und zurück zur Kategorien-Übersicht gewechselt
      emit(state.copyWith(
          status: RadAuswahlStatus.auswahlTyp, auswahlTyp: null));
    } else {
      emit(state.copyWith(status: RadAuswahlStatus.cancelled));
    }
  }

  _onTypSelected(TypSelected event, Emitter<RadAuswahlState> emit) {
    emit(state.copyWith(
        status: RadAuswahlStatus.auswahlRad, auswahlTyp: event.auswahl));
  }

  _onRadSelected(RadSelected event, Emitter<RadAuswahlState> emit) {
    emit(state.copyWith(
        status: RadAuswahlStatus.done, auswahlRad: event.auswahl));
  }

  _onRetryRequested(RetryRequested event, Emitter<RadAuswahlState> emit) async {
    await _fetchData(emit);
  }

  _fetchData(Emitter<RadAuswahlState> emit) async {
    emit(state.copyWith(
        status: RadAuswahlStatus.fetching,
        raeder: const [],
        typen: const [],
        auswahlRad: null,
        auswahlTyp: null));
    try {
      var raeder = await _api.getRaeder(stationId: state.station.id);
      Map<String, RadKategorie> typen = {};

      for (var rad in raeder) {
        typen.update(rad.typ.bezeichnung, (val) => val.add(),
            ifAbsent: () => RadKategorie(typ: rad.typ, verfuegbar: 1));
      }

      emit(state.copyWith(
          status: RadAuswahlStatus.auswahlTyp,
          raeder: raeder,
          typen: List.of(typen.values)));
    } catch (e) {
      emit(state.copyWith(status: RadAuswahlStatus.failed));
    }
  }
}
