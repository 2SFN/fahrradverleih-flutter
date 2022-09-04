import 'package:fahrradverleih/api/rad_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/station.dart';
import 'bloc/map_bloc.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapBloc>(
      create: (context) => MapBloc(api: RepositoryProvider.of<RadApi>(context))
        ..add(const FirstConstructed()),
      child: _ContentView(),
    );
  }
}

class _ContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text("Stationen Suchen")),
        body: _getWidget(context, state),
      ),
      listenWhen: (p, c) => p.status != c.status,
      listener: (p, c) {
        _handleNavigationEvent(context, c);
      },
    );
  }

  _handleNavigationEvent(BuildContext context, MapState state) {
    // TODO: Impl.
  }

  _getWidget(BuildContext context, MapState state) {
    switch (state.status) {
      case MapStatus.fetching:
        return const Center(child: CircularProgressIndicator());
      case MapStatus.failure:
        return _RetryPanel();
      case MapStatus.idle:
      case MapStatus.ausleihe:
        return _MapView();
    }
  }
}

class _MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Map-marker style and labels
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) => GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: LatLng(51.102129, 6.892598), zoom: 14),
        minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
        tiltGesturesEnabled: false,
        markers: _buildMarkers(context, state.stationen),
      ),
    );
  }

  Set<Marker> _buildMarkers(BuildContext context, List<Station> stationen) {
    return Set.from(List.generate(stationen.length, (index) {
      var s = stationen[index];
      return Marker(
        markerId: MarkerId(s.id),
        position: LatLng(s.position.breite, s.position.laenge),
        consumeTapEvents: true,
        onTap: () {
          context.read<MapBloc>().add(StationSelected(s));
        }
    );
    }));
  }
}

class _RetryPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const Icon(
        Icons.error,
        size: 48,
        semanticLabel: "Fehler",
      ),
      TextButton(
          onPressed: () {
            context.read<MapBloc>().add(const RetryRequested());
          },
          child: const Text("Neu Laden"))
    ]));
  }
}
