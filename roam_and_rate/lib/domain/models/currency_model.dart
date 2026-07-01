class CurrencyModel {
  final String code;
  final String name;
  final double rate;
  final int decimalDigits;
  final String symbol;
  final bool isCrypto;

  const CurrencyModel({
    required this.code,
    this.decimalDigits = 2,
    required this.name,
    required this.symbol,
    this.rate = 0,
    required this.isCrypto,
  });

  CurrencyModel copyWith({
    String? code,
    String? name,
    int? decimalDigits,
    double? rate,
    bool? isCrypto,
    String? symbol,
  }) {
    return CurrencyModel(
      code: code ?? this.code,
      name: name ?? this.name,
      isCrypto: isCrypto ?? this.isCrypto,
      symbol: symbol ?? this.symbol, decimalDigits: decimalDigits ?? this.decimalDigits,
    );
  }

  @override
  String toString() => '$code - $name';
}
