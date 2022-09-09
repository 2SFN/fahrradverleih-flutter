import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/station.dart';

part 'neue_ausleihe_event.dart';
part 'neue_ausleihe_state.dart';

class NeueAusleiheBloc extends Bloc<NeueAusleiheEvent, NeueAusleiheState> {
  NeueAusleiheBloc({required RadApi api})
      : _api = api,
        super(const NeueAusleiheState()) {
    on<FirstConstructed>(_onFirstCreated);
    on<PlusClicked>(_onPlusClicked);
    on<MinusClicked>(_onMinusClicked);
    on<BuchenClicked>(_onBuchenClicked);
    on<CancelClicked>(_onCancelClicked);
  }

  final RadApi _api;

  _onFirstCreated(FirstConstructed event, Emitter<NeueAusleiheState> emit) {
    // Initialisiere mit Fahrrad aus Parametern und setze die Dauer
    // standardmäßig auf die kleinste Einheit der Taktung
    emit(state.copyWith(
        status: NeueAusleiheStatus.idle,
        station: event.station,
        rad: event.rad,
        dauer: event.rad.typ.tarif.taktung));
  }

  _onPlusClicked(PlusClicked event, Emitter<NeueAusleiheState> emit) {
    int neueDauer = state.dauer + state.rad.typ.tarif.taktung;
    if (neueDauer <= 48) {
      emit(state.copyWith(dauer: neueDauer));
    }
  }

  _onMinusClicked(MinusClicked event, Emitter<NeueAusleiheState> emit) {
    int neueDauer = state.dauer - state.rad.typ.tarif.taktung;
    if (neueDauer >= state.rad.typ.tarif.taktung) {
      emit(state.copyWith(dauer: neueDauer));
    }
  }

  _onBuchenClicked(BuchenClicked event, Emitter<NeueAusleiheState> emit) async {
    emit(state.copyWith(status: NeueAusleiheStatus.fetching));
    try {
      final ausleihe = await _api.neueAusleihe(
          radId: state.rad.id,
          von: DateTime.now(),
          bis: DateTime.now().add(Duration(hours: state.dauer)));
      emit(state.copyWith(
          status: NeueAusleiheStatus.success, ausleihe: ausleihe));
    } catch (e) {
      emit(state.copyWith(status: NeueAusleiheStatus.failure));
      emit(state.copyWith(status: NeueAusleiheStatus.idle));
    }
  }

  _onCancelClicked(CancelClicked event, Emitter<NeueAusleiheState> emit) {
    emit(state.copyWith(status: NeueAusleiheStatus.cancelled));
  }
}
