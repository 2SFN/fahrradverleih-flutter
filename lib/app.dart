import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/view/startup/startup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Anwendungsklasse.
///
/// Stellt dem untergeordnetem Baum Repositories (wie [RadApi]) zur
/// Verfügung.
class App extends StatelessWidget {
  const App({Key? key, required this.radApi}) : super(key: key);

  final RadApi radApi;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: radApi,
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      onGenerateRoute: (_) => StartupPage.route(),
    );
  }
}
