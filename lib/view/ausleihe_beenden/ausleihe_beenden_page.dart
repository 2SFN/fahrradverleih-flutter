import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/station.dart';
import 'package:fahrradverleih/util/button_styles.dart';
import 'package:fahrradverleih/view/ausleihe_beenden/bloc/ausleihe_beenden_bloc.dart';
import 'package:fahrradverleih/widget/error_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AusleiheBeendenPage extends StatelessWidget {
  const AusleiheBeendenPage({Key? key}) : super(key: key);

  static const routeName = "/ausleihen/beenden";

  /// Route, mit welcher diese Seite erzeugt werden kann.
  ///
  /// Erfordert eine [Ausleihe] als Argument, welches der Seite mithilfe der
  /// [RouteSettings] übergeben wird.
  ///
  /// Wird die gegebene Ausleihe erfolgreich beendet, gibt die Route außerdem
  /// das aktualisierte [Ausleihe]-Objekt als Ergebnis zurück.
  /// Bei Fehlern oder Abbruch wird stattdessen ```null``` zurückgegeben.
  static Route<Ausleihe?> route(Ausleihe ausleihe) {
    return CupertinoModalPopupRoute(
        builder: (_) => const AusleiheBeendenPage(),
        barrierLabel: "Abbrechen",
        barrierDismissible: false,
        settings: RouteSettings(name: routeName, arguments: ausleihe));
  }

  @override
  Widget build(BuildContext context) {
    // Argument auslesen, um dieses im Bloc zur Verfügung stellen zu können
    final ausleihe = ModalRoute.of(context)!.settings.arguments as Ausleihe;

    return BlocProvider<AusleiheBeendenBloc>(
        create: (context) =>
            AusleiheBeendenBloc(api: RepositoryProvider.of<RadApi>(context))
              ..add(FirstConstructed(ausleihe)),
        child: _AusleiheBeendenView());
  }
}

class _AusleiheBeendenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AusleiheBeendenBloc, AusleiheBeendenState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case AusleiheBeendenStatus.fetching:
            case AusleiheBeendenStatus.succeeded:
            case AusleiheBeendenStatus.cancelled:
              return const Center(child: CircularProgressIndicator());
            case AusleiheBeendenStatus.idle:
              return _StationAuswahlPanel();
            case AusleiheBeendenStatus.failed:
              return _getRetryPanel(context);
          }
        },
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (p, c) => _handleNavEvents(context, c));
  }

  _handleNavEvents(BuildContext context, AusleiheBeendenState current) {
    if (current.status == AusleiheBeendenStatus.succeeded) {
      Navigator.pop(context, current.ausleihe);
    } else if (current.status == AusleiheBeendenStatus.cancelled) {
      Navigator.pop(context, null);
    }
  }

  _getRetryPanel(BuildContext context) => ErrorPanel(
        onRetry: () =>
            context.read<AusleiheBeendenBloc>().add(const RetryRequested()),
      );
}

class _StationAuswahlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AusleiheBeendenBloc, AusleiheBeendenState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
              elevation: 1,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              titleTextStyle: const TextStyle(color: Colors.black),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Rückgabestation auswählen",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const Padding(padding: EdgeInsets.all(2)),
                  Text("Rad-ID: ${state.ausleihe!.fahrrad.id}"),
                ],
              )),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [..._buildRadioTiles(context, state)],
          ),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CancelButton(),
                    const Padding(padding: EdgeInsets.all(3)),
                    _RueckgabeButton(),
                  ]),
            ),
          ]);
    });
  }

  List<Widget> _buildRadioTiles(
      BuildContext context, AusleiheBeendenState state) {
    final bloc = context.read<AusleiheBeendenBloc>();
    List<Widget> items = [];

    for (var station in state.stationen) {
      items.add(RadioListTile<Station>(
          title: Text(station.bezeichnung),
          value: station,
          groupValue: state.auswahl,
          onChanged: (auswahl) {
            bloc.add(StationSelected(auswahl!));
          }));
    }

    return items;
  }
}

class _RueckgabeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AusleiheBeendenBloc>();
    return BlocBuilder<AusleiheBeendenBloc, AusleiheBeendenState>(
        builder: (context, state) => OutlinedButton(
          style: ButtonStyles.primaryButtonStyle(context, compact: true),
            child: const Text("Rückgabe Bestätigen"),
            onPressed: () {
              bloc.add(const BeendenRequested());
            }));
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AusleiheBeendenBloc>();
    return BlocBuilder<AusleiheBeendenBloc, AusleiheBeendenState>(
        builder: (context, state) => OutlinedButton(
          style: ButtonStyles.secondaryButtonStyle(context, compact: true),
            child: const Text("Abbrechen"),
            onPressed: () {
              bloc.add(const AusleiheBeendenCancelled());
            }));
  }
}
