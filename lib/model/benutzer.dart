import 'package:equatable/equatable.dart';

class Benutzer extends Equatable {
  static const Benutzer empty =
      Benutzer(id: "", name: "", vorname: "", email: "");

  final String id;
  final String name;
  final String vorname;
  final String email;

  const Benutzer(
      {required this.id,
      required this.name,
      required this.vorname,
      required this.email});

  @override
  List<Object> get props => [id, name, vorname, email];

  @override
  String toString() => "Benutzer $email [$id]";

  Benutzer copyWith({
    String? id,
    String? name,
    String? vorname,
    String? email,
  }) =>
      Benutzer(
        id: id ?? this.id,
        name: name ?? this.name,
        vorname: vorname ?? this.vorname,
        email: email ?? this.email,
      );

  factory Benutzer.fromJson(Map<String, dynamic> json) => Benutzer(
        id: json["id"],
        name: json["name"],
        vorname: json["vorname"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "vorname": vorname,
        "email": email,
      };
}
