import 'package:fahrradverleih/model/ausleihe.dart';
import 'package:fahrradverleih/model/benutzer.dart';
import 'package:fahrradverleih/model/fahrrad.dart';
import 'package:fahrradverleih/model/login_result.dart';
import 'package:fahrradverleih/model/station.dart';

/// Definitionen von Schnittstellen zu der Rad-API.
abstract class RadApi {
  const RadApi();

  /// Erstellt anhand der gegebenen Informationen eine neue Session.
  ///
  /// Gibt ein [LoginResult] zurück, welches das Token enthält.
  Future<LoginResult> login({required String email, required String secret});

  /// Prüft, ob der Anwender autorisiert ist.
  Future<void> auth();

  /// Ruft Detailinformationen zum Benutzer ab.
  Future<Benutzer> getBenutzer();

  /// Ändert Benutzer-Informationen.
  Future<Benutzer> setBenutzer({required Benutzer benutzer});

  /// Ruft eine Liste der letzten Ausleihen des Benutzers ab.
  Future<List<Ausleihe>> getAusleihen();

  /// Erstellt eine neue Ausleihe für das spezifizierte Fahrrad.
  Future<Ausleihe> neueAusleihe(
      {required String radId, required DateTime von, required DateTime bis});

  /// Beendet eine bestehende Ausleihe.
  /// Ein Fahrrad muss immer an einer Station zurückgegeben werden.
  Future<Ausleihe> beendeAusleihe(
      {required String ausleiheId, required String stationId});

  /// Ruft eine Liste von Stationen ab.
  Future<List<Station>> getStationen();

  /// Ruft eine Liste von Fahrrädern ab, die gerade an der
  /// spezifizierten Station verfügbar sind.
  Future<List<Fahrrad>> getRaeder({required String stationId});
}

class RadApiException implements Exception {
  const RadApiException(this.message);
  final String message;

  @override
  String toString() => "$message [API-Fehler]";
}
