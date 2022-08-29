import 'package:shared_preferences/shared_preferences.dart';

/// Utility-Klasse, welche das Speichern, Laden und Löschen von
/// Key-Value Paaren erlaubt.
///
/// Diese Implementierung ist ein Wrapper um Flutter's [SharedPreferences].
class Prefs {
  /// Key, unter welchem das Token für die Rad-API abgelegt wird.
  static const String keyToken = "rad_api_token";

  Prefs._internal();

  // API-Methoden...

  static Future<void> set(String key, String value) async{
    await (await SharedPreferences.getInstance()).setString(key, value);
  }

  static Future<String> get(String key) async {
    return (await SharedPreferences.getInstance()).get(key) as String;
  }

  static Future<String> getOrDefault(String key, String fallback) async {
    return ((await SharedPreferences.getInstance()).get(key) ?? fallback) as String;
  }

  static Future<void> remove(String key) async {
    if((await SharedPreferences.getInstance()).containsKey(key)) {
      (await SharedPreferences.getInstance()).remove(key);
    }
  }
}
