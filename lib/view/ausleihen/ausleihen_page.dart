import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/view/ausleihen/bloc/ausleihen_bloc.dart';
import 'package:fahrradverleih/view/ausleihen/widget/ausleihe_item.dart';
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
    return Scaffold(
        appBar: AppBar(title: const Text("Meine Ausleihen")),
        body: BlocBuilder<AusleihenBloc, AusleihenState>(
            buildWhen: (previous, current) =>
                previous.jobState != current.jobState,
            builder: (context, state) {
              switch (state.jobState) {
                case JobState.fetching:
                  return const Center(child: CircularProgressIndicator());
                case JobState.failed:
                  return _RetryPanel();
                case JobState.idle:
                  return _AusleihenList();
              }
            }));
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

  Widget _buildItem(BuildContext context, int index, List<Ausleihe> ausleihen) {
    if (index == ausleihen.length) {
      // Letztes Item ist immer End-of-List Label
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Text("Keine weiteren Elemente"),
      ));
    } else {
      // Normales item
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
