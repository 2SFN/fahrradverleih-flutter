import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/view/neue_ausleihe/neue_ausleihe_page.dart';
import 'package:fahrradverleih/view/rad_auswahl/rad_auswahl_page.dart';
import 'package:fahrradverleih/widget/error_panel.dart';
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

  _handleNavigationEvent(BuildContext context, MapState state) async {
    if (state.status == MapStatus.radAuswahl && state.auswahlStation != null) {
      // Zeige Rad-Auswahl Modal
      final bloc = context.read<MapBloc>();
      var rad = await Navigator.of(context)
          .push(RadAuswahlPage.route(state.auswahlStation!));
      bloc.add(RadSelected(rad));
    } else if (state.status == MapStatus.buchung) {
      // Zeige Neue-Ausleihe Modal
      final bloc = context.read<MapBloc>();
      var ausleihe = await Navigator.of(context)
          .push(NeueAusleihePage.route(state.auswahlRad!));
      bloc.add(BuchungAbgeschlossen(ausleihe));
    } else if (state.status == MapStatus.buchungOk) {
      // Zeige Erfolgsmeldung
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text("Buchung erfolgreich!")));
    }
  }

  _getWidget(BuildContext context, MapState state) {
    switch (state.status) {
      case MapStatus.fetching:
        return const Center(child: CircularProgressIndicator());
      case MapStatus.failure:
        return _getRetryPanel(context);
      case MapStatus.idle:
      case MapStatus.buchung:
      case MapStatus.buchungOk:
      case MapStatus.radAuswahl:
        return _MapView();
    }
  }

  _getRetryPanel(BuildContext context) => ErrorPanel(
      onRetry: () => context.read<MapBloc>().add(const RetryRequested()));
}

class _MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Map-marker style and labels
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) => GoogleMap(
        initialCameraPosition: const CameraPosition(
            target: LatLng(51.102129, 6.892598), zoom: 13.7),
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
          });
    }));
  }
}
