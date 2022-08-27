import 'package:equatable/equatable.dart';

class LoginResult extends Equatable {
  final bool ok;
  final String token;

  const LoginResult({required this.ok, required this.token});

  @override
  List<Object?> get props => [ok, token];

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        ok: json["ok"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "token": token,
      };
}
