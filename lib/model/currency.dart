import 'package:equatable/equatable.dart';

class CurrencyT extends Equatable {
  static const zero = CurrencyT(betrag: 0, iso4217: "EUR");

  const CurrencyT({
    required this.betrag,
    required this.iso4217,
  });

  final int betrag;
  final String iso4217;

  CurrencyT copyWith({
    int? betrag,
    String? iso4217,
  }) =>
      CurrencyT(
        betrag: betrag ?? this.betrag,
        iso4217: iso4217 ?? this.iso4217,
      );

  factory CurrencyT.fromJson(Map<String, dynamic> json) =>
      CurrencyT(
        betrag: json["betrag"],
        iso4217: json["iso4217"],
      );

  Map<String, dynamic> toJson() =>
      {
        "betrag": betrag,
        "iso4217": iso4217,
      };

  @override
  List<Object?> get props => [betrag, iso4217];

  @override
  String toString() => "$iso4217 $betrag";
}