import 'package:roam_and_rate/domain/models/currency_model.dart';

class CurrencyData {
  static final List<CurrencyModel> currencies = [
    CurrencyModel(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      rate: 1.0,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      rate: 0.8648983835373871,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      rate: 0.7523176289190756,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      rate: 147.36925252568113,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      rate: 1.377739932574114,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      rate: 1.5456248239077894,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'CHF',
      rate: 0.8082209731954647,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      rate: 7.183680333233653,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      rate: 87.82375827116908,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      rate: 1387.5999292953304,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      rate: 5.501992878934752,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: 'MX\$',
      rate: 18.830048120768343,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      rate: 79.93254463913381,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      rate: 17.913323146801424,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'SGD',
      name: 'Singapore Dollar',
      symbol: 'S\$',
      rate: 1.2878857842701539,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'HKD',
      name: 'Hong Kong Dollar',
      symbol: 'HK\$',
      rate: 7.84990798098952,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'NOK',
      name: 'Norwegian Krone',
      symbol: 'kr',
      rate: 10.265041575890582,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'SEK',
      name: 'Swedish Krona',
      symbol: 'kr',
      rate: 9.669840532323665,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'THB',
      name: 'Thai Baht',
      symbol: '฿',
      rate: 32.36806295619501,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'NZD',
      name: 'New Zealand Dollar',
      symbol: 'NZ\$',
      rate: 1.6935523810983488,
      isCrypto: false,
    ),

    // Major Cryptocurrencies
    CurrencyModel(
      code: 'BTC',
      name: 'Bitcoin',
      symbol: '₿',
      rate: 0.000009000000000000002,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'ETH',
      name: 'Ethereum',
      symbol: 'Ξ',
      rate: 0.00027493900284455926,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'BNB',
      name: 'Binance Coin',
      symbol: 'BNB',
      rate: 0.0013079999999999997,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'SOL',
      name: 'Solana',
      symbol: '◎',
      rate: 0.006022374481362504,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'ADA',
      name: 'Cardano',
      symbol: '₳',
      rate: 1.345222234324632,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'AVAX',
      name: 'Avalanche',
      symbol: 'AVAX',
      rate: 0.04479508852220941,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'DOGE',
      name: 'Dogecoin',
      symbol: 'Ð',
      rate: 4.914213374907768,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'MATIC',
      name: 'Polygon',
      symbol: 'MATIC',
      rate: 4.702971353159646,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'DOT',
      name: 'Polkadot',
      symbol: 'DOT',
      rate: 0.27419323365238535,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'SHIB',
      name: 'Shiba Inu',
      symbol: 'SHIB',
      rate: 81706.66059214591,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'LTC',
      name: 'Litecoin',
      symbol: 'Ł',
      rate: 0.008330449896327316,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'TRX',
      name: 'Tron',
      symbol: 'TRX',
      rate: 2.992744,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'UNI',
      name: 'Uniswap',
      symbol: 'UNI',
      rate: 0.1029406290268296,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'LINK',
      name: 'Chainlink',
      symbol: 'LINK',
      rate: 0.060127119100481234,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'XRP',
      name: 'Ripple',
      symbol: 'XRP',
      rate: 0.3328611470812977,
      isCrypto: true,
    ),

    // Stablecoins
    CurrencyModel(
      code: 'USDT',
      name: 'Tether',
      symbol: '₮',
      rate: 1.0002287738799431,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'USDC',
      name: 'USD Coin',
      symbol: 'USDC',
      rate: 0.9993173267382818,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'BUSD',
      name: 'Binance USD',
      symbol: 'BUSD',
      rate: 0.9999258295460781,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'DAI',
      name: 'Dai',
      symbol: 'DAI',
      rate: 1.0002424067376035,
      isCrypto: true,
    ),
  ];

  // Get currencies sorted by name
  static List<CurrencyModel> get sortedCurrencies {
    List<CurrencyModel> sorted = List.from(currencies);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  static List<String> get fiatCurrenciesCodes {
    return currencies.where((c) => !c.isCrypto).map((c) => c.code).toList();
  }

  // static List<String> get currenciesSymbols {
  //   return currencies.where((c) => !c.).map((c) => c.).toList();
  // }

  static String currencySymbol(String name) {
    return currencies.firstWhere((c) => c.name == name).symbol;
  }

  static List<String> get fiatCurrenciesNames {
    return currencies.where((c) => !c.isCrypto).map((c) => c.name).toList();
  }

  // Get popular currencies (most commonly used)
  static List<CurrencyModel> get popularCurrencies {
    return currencies
        .where(
          (c) => [
            'USD',
            'EUR',
            'GBP',
            'JPY',
            'CAD',
            'AUD',
            'BTC',
            'ETH',
            'USDT',
          ].contains(c.code),
        )
        .toList();
  }
}
