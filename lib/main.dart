
import 'package:fahrradverleih/api/remote/remote_rad_api.dart';
import 'package:fahrradverleih/app.dart';
import 'package:fahrradverleih/util/prefs.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Stellt sicher, dass (unter anderem) die SharedPreferences nach diesem
  // Aufruf verfügbar sind
  WidgetsFlutterBinding.ensureInitialized();

  await RemoteRadApi.instance
      .init(await Prefs.getOrDefault(Prefs.keyToken, ""));

  runApp(App(radApi: RemoteRadApi.instance));
}