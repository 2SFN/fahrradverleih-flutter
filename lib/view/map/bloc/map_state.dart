part of 'map_bloc.dart';

enum MapStatus { fetching, failure, idle, ausleihe }

class MapState extends Equatable {
  const MapState({
    this.status = MapStatus.fetching,
    this.stationen = const [],
    this.auswahl,
  });

  final MapStatus status;
  final List<Station> stationen;
  final Station? auswahl;

  @override
  List<Object?> get props => [status, stationen, auswahl];

  MapState copyWith({
    MapStatus? status,
    List<Station>? stationen,
    Station? auswahl,
  }) {
    return MapState(
      status: status ?? this.status,
      stationen: stationen ?? this.stationen,
      auswahl: auswahl ?? this.auswahl,
    );
  }
}
