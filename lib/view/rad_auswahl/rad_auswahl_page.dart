import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/fahrradtyp.dart';
import 'package:fahrradverleih/model/station.dart';
import 'package:fahrradverleih/model/tarif.dart';
import 'package:fahrradverleih/view/ausleihe_beenden/ausleihe_beenden_page.dart';
import 'package:fahrradverleih/view/rad_auswahl/bloc/rad_auswahl_bloc.dart';
import 'package:fahrradverleih/view/rad_auswahl/model/rad_kategorie.dart';
import 'package:fahrradverleih/widget/end_of_list_item.dart';
import 'package:fahrradverleih/widget/error_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RadAuswahlPage extends StatelessWidget {
  const RadAuswahlPage({Key? key}) : super(key: key);

  static const routeName = "/rad-auswahl";

  /// Route mit Argument und Rückgabewert.
  ///
  /// S. z.B. route in [AusleiheBeendenPage].
  static Route<Fahrrad?> route(Station station) => CupertinoModalPopupRoute(
      builder: (_) => const RadAuswahlPage(),
      settings: RouteSettings(name: routeName, arguments: station),
      barrierLabel: "Abbrechen",
      barrierDismissible: false);

  @override
  Widget build(BuildContext context) {
    // Argument auslesen
    final station = ModalRoute.of(context)!.settings.arguments as Station;

    return BlocProvider<RadAuswahlBloc>(
      create: (context) =>
          RadAuswahlBloc(api: RepositoryProvider.of<RadApi>(context))
            ..add(FirstConstructed(station)),
      child: _ContentView(),
    );
  }
}

/// Zeigt basierend auf dem [RadAuswahlStatus] verschiedene Inhalte an.
class _ContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RadAuswahlBloc, RadAuswahlState>(
        buildWhen: (p, c) => p.status != c.status,
        builder: (context, state) => Scaffold(
              appBar: AppBar(title: Text(_getAppBarTitle(state.status))),
              body: _getWidget(context, state),
              persistentFooterButtons: [
                OutlinedButton(
                    onPressed: () => context
                        .read<RadAuswahlBloc>()
                        .add(const CancelClicked()),
                    child: const Text("Zurück"))
              ],
            ),
        listenWhen: (p, c) => p.status != c.status,
        listener: (p, c) => _handleNavEvents(context, c));
  }

  _handleNavEvents(BuildContext context, RadAuswahlState state) {
    if(state.status == RadAuswahlStatus.cancelled) {
      Navigator.pop(context, null);
    } else if(state.status == RadAuswahlStatus.done) {
      Navigator.pop(context, state.auswahlRad);
    }
  }

  Widget _getWidget(BuildContext context, RadAuswahlState state) {
    switch (state.status) {
      case RadAuswahlStatus.fetching:
      case RadAuswahlStatus.cancelled:
        return const Center(child: CircularProgressIndicator());
      case RadAuswahlStatus.failed:
        return _getRetryPanel(context);
      case RadAuswahlStatus.done:
      case RadAuswahlStatus.auswahlRad:
        return _RadAuswahlPanel();
      case RadAuswahlStatus.auswahlTyp:
        return _TypAuswahlPanel();
    }
  }

  String _getAppBarTitle(RadAuswahlStatus status) {
    return (status == RadAuswahlStatus.auswahlTyp)
        ? "Radtypen auswählen"
        : "Fahrrad auswählen";
  }

  Widget _getRetryPanel(BuildContext context) {
    return ErrorPanel(onRetry: () {
      context.read<RadAuswahlBloc>().add(const RetryRequested());
    });
  }
}

class _TypAuswahlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadAuswahlBloc, RadAuswahlState>(
      builder: (context, state) {
        return Scrollbar(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    _buildItem(context, index, state.typen),
                separatorBuilder: (context, i) => const Divider(),
                itemCount: state.typen.length + 1));
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, List<RadKategorie> typen) {
    if (index == typen.length) {
      return const EndOfListItem();
    }

    final RadKategorie kategorie = typen[index];
    return _RadItemBase(
      typ: kategorie.typ,
      extensions: [
        Text("Verfügbar: ${kategorie.verfuegbar}"),
        OutlinedButton(
            onPressed: () {
              context.read<RadAuswahlBloc>().add(TypSelected(kategorie.typ));
            },
            child: const Text("Auswählen"))
      ],
    );
  }
}

class _RadAuswahlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadAuswahlBloc, RadAuswahlState>(
      builder: (context, state) {
        return Scrollbar(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    _buildItem(context, index, state.raederGefiltert),
                separatorBuilder: (context, i) => const Divider(),
                itemCount: state.raederGefiltert.length + 1));
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, List<Fahrrad> raeder) {
    if (index == raeder.length) {
      return const EndOfListItem();
    }

    final Fahrrad rad = raeder[index];
    return _RadItemBase(
      typ: rad.typ,
      extensions: [
        Text(_tarifInfo(rad.typ.tarif)),
        Text("ID: ${rad.id}"),
        OutlinedButton(onPressed: () {}, child: const Text("Reservieren")),
        OutlinedButton(
            onPressed: () {
              context.read<RadAuswahlBloc>().add(RadSelected(rad));
            },
            child: const Text("Jetzt Buchen")),
      ],
    );
  }

  String _tarifInfo(TarifT t) {
    return "Tarif: ${t.preis.iso4217} ${t.preis.betrag} "
        "für ${t.taktung} Stunde(n)";
  }
}

/// Erweiterbares List-Item, das Informationen zu einem Rad oder Rad-Typen
/// anzeigt.
class _RadItemBase extends StatelessWidget {
  const _RadItemBase({
    required this.typ,
    this.extensions = const [],
  });

  final FahrradTyp typ;
  final List<Widget> extensions;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          Icon(Icons.pedal_bike_outlined,
              size: 64, semanticLabel: typ.bezeichnung),
          Column(children: [Text(typ.bezeichnung), ...extensions])
        ]));
  }
}
