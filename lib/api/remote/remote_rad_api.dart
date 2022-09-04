import 'dart:convert';

import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/benutzer.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/login_result.dart';
import 'package:fahrradverleih/model/station.dart';
import 'package:fahrradverleih/util/prefs.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

/// Implementierung der Rad-API, welche die Daten von dem REST-Backend
/// über HTTP empfängt und verarbeitet.
///
/// Ein vorhandenes Token wird standardmäßig im entsprechenden Header
/// mit übermittelt.
class RemoteRadApi extends RadApi {
  // Singleton-Mechanik mit internem Constructor
  static final RemoteRadApi instance = RemoteRadApi._internal();

  RemoteRadApi._internal();

  final String _baseUrl = FlutterConfig.get("RAD_API_URL");
  String _token = "";

  /// Initialisiert die API-Instanz.
  /// Sollte vor der Verwendung und nach Veränderung des Tokens in
  /// den [Prefs] aufgerufen werden.
  Future<void> init(String token) async {
    _token = token;
  }

  // --- API-Methoden

  @override
  Future<void> auth() => get("/benutzer/auth");

  @override
  Future<Ausleihe> beendeAusleihe(
          {required String ausleiheId, required String stationId}) async =>
      Ausleihe.fromJson(await post("/benutzer/ausleihen/ende", {
        "ausleihe": {"id": ausleiheId},
        "station": {"id": stationId}
      }) as Map<String, dynamic>);

  @override
  Future<List<Ausleihe>> getAusleihen() async => _processList<Ausleihe>(
      await get("/benutzer/ausleihen"), (e) => Ausleihe.fromJson(e));

  @override
  Future<Benutzer> getBenutzer() async =>
      Benutzer.fromJson(await get("/benutzer/details"));

  @override
  Future<Benutzer> setBenutzer({required Benutzer benutzer}) async =>
      Benutzer.fromJson(await post("/benutzer/details", benutzer.toJson()));

  @override
  Future<List<Fahrrad>> getRaeder({required String stationId}) async =>
      _processList(await get("/stationen/$stationId/raeder"),
          (e) => Fahrrad.fromJson(e));

  @override
  Future<List<Station>> getStationen() async =>
      _processList(await get("/stationen"), (e) => Station.fromJson(e));

  @override
  Future<LoginResult> login(
          {required String email, required String secret}) async =>
      LoginResult.fromJson(
          await post("/benutzer/login", {"email": email, "secret": secret}));

  @override
  Future<Ausleihe> neueAusleihe(
          {required String radId,
          required DateTime von,
          required DateTime bis}) async =>
      Ausleihe.fromJson(await post("/benutzer/ausleihen/neu", {
        "fahrrad": {"id": radId},
        "von": von.toIso8601String(),
        "bis": bis.toIso8601String()
      }));

  // --- Utility für HTTP-Requests

  Future<dynamic> get(String path) async {
    try {
      var response = await http.get(Uri.parse(_baseUrl + path),
          headers: {"token": _token, "content-type": "application/json"});
      _checkStatusCode(response.statusCode);
      return jsonDecode(response.body);
    } catch (e) {
      throw RadApiException("Fehler bei der Anfrage: $e");
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      var response = await http.post(Uri.parse(_baseUrl + path),
          headers: {"token": _token, "content-type": "application/json"},
          body: jsonEncode(body));
      _checkStatusCode(response.statusCode);
      return jsonDecode(response.body);
    } catch (e) {
      throw RadApiException("Fehler bei der Anfrage: $e");
    }
  }

  List<T> _processList<T>(
      List<dynamic> source, Function(Map<String, dynamic>) deserializer) {
    List<T> res = [];
    for (var e in source) {
      res.add(deserializer(e));
    }
    return res;
  }

  _checkStatusCode(int statusCode) {
    if (statusCode == 400) {
      throw Exception("Ungültige Anfrage (400)");
    } else if (statusCode == 401) {
      throw Exception("Nicht autorisiert (401)");
    }
  }
}
