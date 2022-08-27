import 'package:fahrradverleih/api/remote/remote_rad_api.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testet die Bereitschaft und einige Methoden der Remote-API.
void main() {
  const _testing_token = "Test";

  test("Instanz wird korrekt initialisiert", () async {
    await RemoteRadApi.instance.init(_testing_token);
  });

  test("Login-Methode", () async {
    await RemoteRadApi.instance.init(_testing_token);
    await RemoteRadApi.instance.login(
        email: "u3@test.mail", secret: "Test");
  });

  test("Get Stationen", () async {
    await RemoteRadApi.instance.init(_testing_token);
    await RemoteRadApi.instance.getStationen();
  });
}
