class CurrencyModel {
  final String code;
  final String name;
  final double rate;
  final bool isCrypto;

  const CurrencyModel({
    required this.code,
    required this.name,
    this.rate = 0,
    required this.isCrypto,
  });

  CurrencyModel copyWith({
    String? code,
    String? name,
    double? rate,
    bool? isCrypto,
  }) {
    return CurrencyModel(
      code: code ?? this.code,
      name: name ?? this.name,
      isCrypto: isCrypto ?? this.isCrypto,
    );
  }

  @override
  String toString() => '$code - $name';
}
