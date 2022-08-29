import 'package:fahrradverleih/api/remote/remote_rad_api.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testet die Bereitschaft und einige Methoden der Remote-API.
void main() {
  const _testingToken = "Test";

  test("Instanz wird korrekt initialisiert", () async {
    await RemoteRadApi.instance.init(_testingToken);
  });

  test("Benutzer: Login", () async {
    await RemoteRadApi.instance.init(_testingToken);
    await RemoteRadApi.instance.login(
        email: "u3@test.mail", secret: "Test");
  });

  test("Stationen: Liste", () async {
    await RemoteRadApi.instance.init(_testingToken);
    await RemoteRadApi.instance.getStationen();
  });
}
