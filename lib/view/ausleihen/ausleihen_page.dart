import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/view/ausleihe_beenden/ausleihe_beenden_page.dart';
import 'package:fahrradverleih/view/ausleihen/bloc/ausleihen_bloc.dart';
import 'package:fahrradverleih/view/ausleihen/widget/ausleihe_item.dart';
import 'package:fahrradverleih/widget/end_of_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AusleihenPage extends StatelessWidget {
  const AusleihenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AusleihenBloc>(
      create: (context) =>
          AusleihenBloc(api: RepositoryProvider.of<RadApi>(context))
            ..add(const FirstConstructed()),
      child: _AusleihenView(),
    );
  }
}

class _AusleihenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AusleihenBloc, AusleihenState>(
        buildWhen: (p, c) => p.jobState != c.jobState,
        builder: (context, state) => Scaffold(
            appBar: AppBar(title: const Text("Meine Ausleihen")),
            body: _getWidget(context, state)),
        listenWhen: (p, c) => c.jobState == JobState.rueckgabe,
        listener: (p, c) {
          _handleNavigationEvent(context, c);
        });
  }

  _handleNavigationEvent(BuildContext context, AusleihenState state) async {
    if (state.jobState == JobState.rueckgabe && state.auswahl != null) {
      // Öffnet [AusleiheBeendenPage] mit der ausgewählten Ausleihe als
      // Argument, und emittiert ein Event, sobald der Anwender zurückkehrt
      final bloc = context.read<AusleihenBloc>();
      var result = await Navigator.of(context)
          .push(AusleiheBeendenPage.route(state.auswahl!));
      bloc.add(RueckgabeAbgeschlossen(result));
    }
  }

  _getWidget(BuildContext context, AusleihenState state) {
    switch (state.jobState) {
      case JobState.fetching:
        return const Center(child: CircularProgressIndicator());
      case JobState.failed:
        return _RetryPanel();
      case JobState.idle:
      case JobState.rueckgabe:
        return _AusleihenList();
    }
  }
}

/// Widget, welches eine Liste von Ausleihen anzeigt.
///
/// Ist außerdem für die "Pull-to-Refresh"-Mechanik zuständig (benachrichtigt
/// den Bloc, s. [ReloadRequested] Event).
class _AusleihenList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AusleihenBloc, AusleihenState>(
        buildWhen: (c, p) => c.ausleihen != p.ausleihen,
        builder: (context, state) => RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                BlocProvider.of<AusleihenBloc>(context)
                    .add(const ReloadRequested());
              },
              child: Scrollbar(
                  child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                // Bewirkt, dass Pull-to-Refresh auch funktioniert, wenn die
                // Liste noch nicht lang genug ist, um zu scrollen
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                // Anzahl Items = n Ausleihen + 1 für End-of-List Label
                itemCount: state.ausleihen.length + 1,
                itemBuilder: (context, index) =>
                    _buildItem(context, index, state.ausleihen),
              )),
            ));
  }

  /// Baut das Listen-Item an einem bestimmten [index].
  ///
  /// Regulär wird die [AusleiheItem]-Klasse verwendet. An der letzten Position
  /// wird allerdings ein "End-of-List" Label generiert.
  Widget _buildItem(BuildContext context, int index, List<Ausleihe> ausleihen) {
    if (index == ausleihen.length) {
      return const EndOfListItem();
    } else {
      final Ausleihe ausleihe = ausleihen[index];
      return AusleiheItem(
          ausleihe: ausleihe,
          onRueckgabe: () {
            context.read<AusleihenBloc>().add(AusleiheSelected(ausleihe));
          });
    }
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
            context.read<AusleihenBloc>().add(const ReloadRequested());
          },
          child: const Text("Neu Laden"))
    ]));
  }
}
