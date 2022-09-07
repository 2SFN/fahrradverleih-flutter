part of 'map_bloc.dart';

enum MapStatus {
  fetching,
  permissionsCheck,
  failure,
  idle,
  radAuswahl,
  buchung,
  buchungOk
}

class MapState extends Equatable {
  const MapState(
      {this.status = MapStatus.fetching,
      this.stationen = const [],
      this.auswahlStation,
      this.auswahlRad});

  final MapStatus status;
  final List<Station> stationen;
  final Station? auswahlStation;
  final Fahrrad? auswahlRad;

  @override
  List<Object?> get props => [status, stationen, auswahlStation];

  MapState copyWith({
    MapStatus? status,
    List<Station>? stationen,
    Station? auswahlStation,
    Fahrrad? auswahlRad,
  }) {
    return MapState(
      status: status ?? this.status,
      stationen: stationen ?? this.stationen,
      auswahlStation: auswahlStation ?? this.auswahlStation,
      auswahlRad: auswahlRad ?? this.auswahlRad,
    );
  }
}
