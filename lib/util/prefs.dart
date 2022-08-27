import 'package:shared_preferences/shared_preferences.dart';

/// Utility-Klasse, welche das Speichern, Laden und Löschen von
/// Key-Value Paaren erlaubt.
///
/// Der öffentliche Zugriff auf die Instanz erfolgt über das
/// [instance]-Feld.
///
/// Diese Implementierung verwendet die SharedPreferences und
/// stellt quasi einen Wrapper dar.
class Prefs {
  /// Key, unter welchem das Token für die Rad-API abgelegt wird.
  static const String keyToken = "rad_api_token";

  // Singleton-Mechanik mit internem constructor
  static final Prefs instance = Prefs._internal();
  Prefs._internal();
  SharedPreferences? _preferences;

  /// Initialisiert die Prefs-Instanz.
  /// Muss vor Verwendung von weiteren Funktionen aufgerufen werden.
  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // API-Methoden...

  set(String key, String value) async{
    _checkInitialized();
    await _preferences?.setString(key, value);
  }

  String get(String key) {
    _checkInitialized();
    return _preferences?.get(key) as String;
  }

  String getOrDefault(String key, String fallback) {
    _checkInitialized();
    return (_preferences?.get(key) ?? fallback) as String;
  }

  remove(String key) {
    _checkInitialized();
    if(_preferences?.containsKey(key) ?? false) {
      _preferences?.remove(key);
    }
  }

  // Helfer-Funktion
  _checkInitialized() {
    if(_preferences == null) {
      throw Exception("Prefs-Instanz noch nicht initialisiert.");
    }
  }
}