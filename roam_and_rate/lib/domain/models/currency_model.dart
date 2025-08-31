class CurrencyModel {
  final String code;
  final String name;
  final double rate;
  final String symbol;
  final bool isCrypto;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    this.rate = 0,
    required this.isCrypto,
  });

  CurrencyModel copyWith({
    String? code,
    String? name,
    double? rate,
    bool? isCrypto,
    String? symbol,
  }) {
    return CurrencyModel(
      code: code ?? this.code,
      name: name ?? this.name,
      isCrypto: isCrypto ?? this.isCrypto,
      symbol: symbol ?? this.symbol,
    );
  }

  @override
  String toString() => '$code - $name';
}
