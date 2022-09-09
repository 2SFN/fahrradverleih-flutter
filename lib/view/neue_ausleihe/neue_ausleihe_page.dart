import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/station.dart';
import 'package:fahrradverleih/model/tarif.dart';
import 'package:fahrradverleih/util/button_styles.dart';
import 'package:fahrradverleih/view/neue_ausleihe/bloc/neue_ausleihe_bloc.dart';
import 'package:fahrradverleih/widget/rad_item_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NeueAusleiheArguments {
  const NeueAusleiheArguments({
    required this.station,
    required this.rad,
  });

  final Station station;
  final Fahrrad rad;
}

class NeueAusleihePage extends StatelessWidget {
  const NeueAusleihePage({Key? key}) : super(key: key);

  static const routeName = "/ausleihen/neu";

  static Route<Ausleihe?> route(NeueAusleiheArguments arguments) =>
      CupertinoModalPopupRoute(
          builder: (_) => const NeueAusleihePage(),
          barrierDismissible: false,
          settings: RouteSettings(name: routeName, arguments: arguments));

  @override
  Widget build(BuildContext context) {
    // Argument Auslesen
    final args =
        ModalRoute.of(context)!.settings.arguments as NeueAusleiheArguments;

    return BlocProvider<NeueAusleiheBloc>(
      create: (context) =>
          NeueAusleiheBloc(api: RepositoryProvider.of<RadApi>(context))
            ..add(FirstConstructed(rad: args.rad, station: args.station)),
      child: _NeueAusleiheView(),
    );
  }
}

class _NeueAusleiheView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NeueAusleiheBloc, NeueAusleiheState>(
        buildWhen: (p, c) => p.rad != c.rad,
        builder: (context, state) => Scaffold(
              appBar: _buildAppBar(state),
              body: Column(children: [
                _InfoRadItem(rad: state.rad),
                const Divider(),
                const _ZeitAuswahlPanel()
              ]),
              persistentFooterButtons: [_buildFooter()],
            ),
        listenWhen: (p, c) => p.status != c.status,
        listener: (p, c) => _handleSateChanges(context, c));
  }

  AppBar _buildAppBar(NeueAusleiheState state) {
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
            const Text("Fahrrad buchen",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
          ]),
      automaticallyImplyLeading: false,
      titleSpacing: 4,
      leading: const Icon(Icons.location_on, color: Colors.white, size: 38),
    );
  }

  Column _buildFooter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _SubmitButton(),
        Padding(padding: EdgeInsets.all(2)),
        _CancelButton()
      ],
    );
  }

  _handleSateChanges(BuildContext context, NeueAusleiheState state) {
    if (state.status == NeueAusleiheStatus.cancelled ||
        state.status == NeueAusleiheStatus.success) {
      Navigator.of(context).pop(state.ausleihe);
    } else if (state.status == NeueAusleiheStatus.failure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text("Fehler bei der Ausleihe")));
    }
  }
}

class _ZeitAuswahlPanel extends StatelessWidget {
  const _ZeitAuswahlPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NeueAusleiheBloc, NeueAusleiheState>(
      builder: (context, state) {
        return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Text("Rad ausleihen für", style: _textInfo),
              const Padding(padding: EdgeInsets.all(10)),
              // Zeit-Anzeige
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.dauer.toString(), style: _textTimePrimary),
                    const Padding(padding: EdgeInsets.all(8)),
                    const Text("h", style: _textTimeSecondary)
                  ]),
              const Padding(padding: EdgeInsets.all(10)),
              Text(_infoText(state),
                  style: _textInfo, textAlign: TextAlign.center),
              const Padding(padding: EdgeInsets.all(10)),
              // Plus/Minus Buttons
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: ButtonStyles.primaryButtonStyle(context),
                          onPressed: () => context
                              .read<NeueAusleiheBloc>()
                              .add(const MinusClicked()),
                          child: const Text("−")),
                    ),
                    const Padding(padding: EdgeInsets.all(8)),
                    Expanded(
                      child: OutlinedButton(
                          style: ButtonStyles.primaryButtonStyle(context),
                          onPressed: () => context
                              .read<NeueAusleiheBloc>()
                              .add(const PlusClicked()),
                          child: const Text("+")),
                    )
                  ])
            ]));
      },
    );
  }

  String _infoText(NeueAusleiheState state) {
    final preis = ((state.dauer / state.rad.typ.tarif.taktung) *
            state.rad.typ.tarif.preis.betrag)
        .toInt();
    final zeit = DateFormat("H:mm")
        .format(DateTime.now().add(Duration(hours: state.dauer)));
    return "Gesamtpreis ${state.rad.typ.tarif.preis.iso4217} $preis\n"
        "Rückgabe bis $zeit Uhr";
  }

  static const _textInfo = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);

  static const _textTimePrimary =
      TextStyle(fontSize: 36, fontWeight: FontWeight.w600);

  static const _textTimeSecondary =
      TextStyle(fontSize: 36, fontWeight: FontWeight.w300, color: Colors.grey);
}

class _InfoRadItem extends StatelessWidget {
  const _InfoRadItem({
    Key? key,
    required this.rad,
  }) : super(key: key);

  final Fahrrad rad;

  @override
  Widget build(BuildContext context) {
    return RadItemBase(
      padding: const EdgeInsets.all(16),
      typ: rad.typ,
      extensions: [
        Text(_tarifInfo(rad.typ.tarif), style: RadItemBase.secondaryTextStyle),
        RadItemBase.spacing,
        Text("ID: ${rad.id}", style: RadItemBase.secondaryTextStyle)
      ],
    );
  }

  String _tarifInfo(TarifT t) {
    return "Tarif: ${t.preis.iso4217} ${t.preis.betrag} "
        "für ${t.taktung} Stunde(n)";
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NeueAusleiheBloc, NeueAusleiheState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        if (state.status == NeueAusleiheStatus.fetching) {
          return const CircularProgressIndicator();
        } else {
          return OutlinedButton(
              style: ButtonStyles.primaryButtonStyle(context, compact: true),
              onPressed: () =>
                  context.read<NeueAusleiheBloc>().add(const BuchenClicked()),
              child: const Text("Buchung Bestätigen"));
        }
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyles.secondaryButtonStyle(context, compact: true),
        onPressed: () =>
            context.read<NeueAusleiheBloc>().add(const CancelClicked()),
        child: const Text("Zurück"));
  }
}
