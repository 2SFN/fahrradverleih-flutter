import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/tarif.dart';
import 'package:fahrradverleih/view/neue_ausleihe/bloc/neue_ausleihe_bloc.dart';
import 'package:fahrradverleih/widget/rad_item_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NeueAusleihePage extends StatelessWidget {
  const NeueAusleihePage({Key? key}) : super(key: key);

  static const routeName = "/ausleihen/neu";

  static Route<Ausleihe?> route(Fahrrad rad) => CupertinoModalPopupRoute(
      builder: (_) => const NeueAusleihePage(),
      barrierDismissible: false,
      settings: RouteSettings(name: routeName, arguments: rad));

  @override
  Widget build(BuildContext context) {
    // Argument Auslesen
    final rad = ModalRoute.of(context)!.settings.arguments as Fahrrad;

    return BlocProvider<NeueAusleiheBloc>(
      create: (context) =>
          NeueAusleiheBloc(api: RepositoryProvider.of<RadApi>(context))
            ..add(FirstConstructed(rad)),
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
              appBar: AppBar(title: const Text("Rad Buchen")),
              body: Column(children: [
                _InfoRadItem(rad: state.rad),
                const _ZeitAuswahlPanel()
              ]),
              persistentFooterButtons: const [_SubmitButton(), _CancelButton()],
            ),
        listenWhen: (p, c) => p.status != c.status,
        listener: (p, c) => _handleSateChanges(context, c));
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
              const Text("Rad ausleihen für"),
              Row(children: [Text(state.dauer.toString()), const Text("h")]),
              Text(_infoText(state)),
              Row(children: [
                OutlinedButton(
                    onPressed: () => context
                        .read<NeueAusleiheBloc>()
                        .add(const MinusClicked()),
                    child: const Text("-")),
                OutlinedButton(
                    onPressed: () => context
                        .read<NeueAusleiheBloc>()
                        .add(const PlusClicked()),
                    child: const Text("+"))
              ])
            ]));
      },
    );
  }

  String _infoText(NeueAusleiheState state) {
    final preis = ((state.dauer / state.rad.typ.tarif.taktung) *
        state.rad.typ.tarif.preis.betrag).toInt();
    final zeit = DateFormat("H:mm")
        .format(DateTime.now().add(Duration(hours: state.dauer)));
    return "Gesamtpreis ${state.rad.typ.tarif.preis.iso4217} $preis\n"
        "Rückgabe bis $zeit Uhr";
  }
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
      typ: rad.typ,
      extensions: [Text(_tarifInfo(rad.typ.tarif)), Text("ID: ${rad.id}")],
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
        onPressed: () =>
            context.read<NeueAusleiheBloc>().add(const CancelClicked()),
        child: const Text("Zurück"));
  }
}
