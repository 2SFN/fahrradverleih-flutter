import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/station.dart';
import 'package:fahrradverleih/model/tarif.dart';
import 'package:fahrradverleih/util/button_styles.dart';
import 'package:fahrradverleih/view/ausleihe_beenden/ausleihe_beenden_page.dart';
import 'package:fahrradverleih/view/rad_auswahl/bloc/rad_auswahl_bloc.dart';
import 'package:fahrradverleih/view/rad_auswahl/model/rad_kategorie.dart';
import 'package:fahrradverleih/widget/end_of_list_item.dart';
import 'package:fahrradverleih/widget/error_panel.dart';
import 'package:fahrradverleih/widget/rad_item_base.dart';
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
              appBar: _buildAppBar(state),
              body: _getWidget(context, state),
              persistentFooterButtons: [_buildFooter(context)],
            ),
        listenWhen: (p, c) => p.status != c.status,
        listener: (p, c) => _handleNavEvents(context, c));
  }

  AppBar _buildAppBar(RadAuswahlState state) {
    return AppBar(
      titleTextStyle: const TextStyle(color: Colors.white),
      title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.station.bezeichnung,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            const Padding(padding: EdgeInsets.all(2)),
            Text(_getAppBarTitle(state.status),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
          ]),
      automaticallyImplyLeading: false,
      titleSpacing: 4,
      leading: const Icon(Icons.location_on, color: Colors.white, size: 38),
    );
  }

  Column _buildFooter(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
            style: ButtonStyles.secondaryButtonStyle(context),
            onPressed: () =>
                context.read<RadAuswahlBloc>().add(const CancelClicked()),
            child: const Text("Zurück")),
      ],
    );
  }

  /// Führt einmalige Aktionen bei Änderung des [RadAuswahlStatus] aus.
  _handleNavEvents(BuildContext context, RadAuswahlState state) {
    if (state.status == RadAuswahlStatus.cancelled) {
      Navigator.pop(context, null);
    } else if (state.status == RadAuswahlStatus.done) {
      Navigator.pop(context, state.auswahlRad);
    }
  }

  /// Entscheidet basieren auf dem [RadAuswahlStatus] das anzuzeigende Widget.
  Widget _getWidget(BuildContext context, RadAuswahlState state) {
    switch (state.status) {
      case RadAuswahlStatus.fetching:
      case RadAuswahlStatus.cancelled:
        return const Center(child: CircularProgressIndicator());
      case RadAuswahlStatus.failed:
        return _buildRetryPanel(context);
      case RadAuswahlStatus.done:
      case RadAuswahlStatus.auswahlRad:
        return _RadAuswahlPanel();
      case RadAuswahlStatus.auswahlTyp:
        return _TypAuswahlPanel();
    }
  }

  String _getAppBarTitle(RadAuswahlStatus status) {
    return (status == RadAuswahlStatus.auswahlTyp)
        ? "Radtyp auswählen"
        : "Fahrrad auswählen";
  }

  Widget _buildRetryPanel(BuildContext context) {
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
    return RadItemBase(
      typ: kategorie.typ,
      extensions: [
        Text("Verfügbar: ${kategorie.verfuegbar}",
            style: RadItemBase.secondaryTextStyle),
        RadItemBase.spacing,
        OutlinedButton(
            style: ButtonStyles.primaryButtonStyle(context, compact: true),
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
    return RadItemBase(
      typ: rad.typ,
      extensions: [
        Text(_tarifInfo(rad.typ.tarif)),
        RadItemBase.spacing,
        Text("ID: ${rad.id}", style: RadItemBase.secondaryTextStyle),
        RadItemBase.spacing,
        OutlinedButton(
            onPressed: null,
            style: ButtonStyles.primaryButtonStyle(context, compact: true),
            child: const Text("Reservieren")),
        RadItemBase.spacing,
        OutlinedButton(
            onPressed: () {
              context.read<RadAuswahlBloc>().add(RadSelected(rad));
            },
            style: ButtonStyles.primaryButtonStyle(context, compact: true),
            child: const Text("Jetzt Buchen")),
      ],
    );
  }

  String _tarifInfo(TarifT t) {
    return "Tarif: ${t.preis.iso4217} ${t.preis.betrag} "
        "für ${t.taktung} Stunde(n)";
  }
}
