import 'package:roam_and_rate/models/currency_model.dart';

class CurrencyData {
  static final List<CurrencyModel> currencies = [
    // Fiat Currencies
    CurrencyModel(code: 'USD', name: 'US Dollar', rate: 1.0, isCrypto: false),
    CurrencyModel(
      code: 'EUR',
      name: 'Euro',
      rate: 0.8648983835373871,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'GBP',
      name: 'British Pound',
      rate: 0.7523176289190756,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'JPY',
      name: 'Japanese Yen',
      rate: 147.36925252568113,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'CAD',
      name: 'Canadian Dollar',
      rate: 1.377739932574114,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'AUD',
      name: 'Australian Dollar',
      rate: 1.5456248239077894,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'CHF',
      name: 'Swiss Franc',
      rate: 0.8082209731954647,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'CNY',
      name: 'Chinese Yuan',
      rate: 7.183680333233653,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'INR',
      name: 'Indian Rupee',
      rate: 87.82375827116908,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'KRW',
      name: 'South Korean Won',
      rate: 1387.5999292953304,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'BRL',
      name: 'Brazilian Real',
      rate: 5.501992878934752,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'MXN',
      name: 'Mexican Peso',
      rate: 18.830048120768343,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'RUB',
      name: 'Russian Ruble',
      rate: 79.93254463913381,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'ZAR',
      name: 'South African Rand',
      rate: 17.913323146801424,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'SGD',
      name: 'Singapore Dollar',
      rate: 1.2878857842701539,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'HKD',
      name: 'Hong Kong Dollar',
      rate: 7.84990798098952,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'NOK',
      name: 'Norwegian Krone',
      rate: 10.265041575890582,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'SEK',
      name: 'Swedish Krona',
      rate: 9.669840532323665,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'THB',
      name: 'Thai Baht',
      rate: 32.36806295619501,
      isCrypto: false,
    ),
    CurrencyModel(
      code: 'NZD',
      name: 'New Zealand Dollar',
      rate: 1.6935523810983488,
      isCrypto: false,
    ),

    // Major Cryptocurrencies
    CurrencyModel(
      code: 'BTC',
      name: 'Bitcoin',
      rate: 0.000009000000000000002,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'ETH',
      name: 'Ethereum',
      rate: 0.00027493900284455926,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'BNB',
      name: 'Binance Coin',
      rate: 0.0013079999999999997,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'SOL',
      name: 'Solana',
      rate: 0.006022374481362504,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'ADA',
      name: 'Cardano',
      rate: 1.345222234324632,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'AVAX',
      name: 'Avalanche',
      rate: 0.04479508852220941,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'DOGE',
      name: 'Dogecoin',
      rate: 4.914213374907768,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'MATIC',
      name: 'Polygon',
      rate: 4.702971353159646,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'DOT',
      name: 'Polkadot',
      rate: 0.27419323365238535,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'SHIB',
      name: 'Shiba Inu',
      rate: 81706.66059214591,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'LTC',
      name: 'Litecoin',
      rate: 0.008330449896327316,
      isCrypto: true,
    ),
    CurrencyModel(code: 'TRX', name: 'Tron', rate: 2.992744, isCrypto: true),
    CurrencyModel(
      code: 'UNI',
      name: 'Uniswap',
      rate: 0.1029406290268296,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'LINK',
      name: 'Chainlink',
      rate: 0.060127119100481234,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'XRP',
      name: 'Ripple',
      rate: 0.3328611470812977,
      isCrypto: true,
    ),

    // Stablecoins
    CurrencyModel(
      code: 'USDT',
      name: 'Tether',
      rate: 1.0002287738799431,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'USDC',
      name: 'USD Coin',
      rate: 0.9993173267382818,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'BUSD',
      name: 'Binance USD',
      rate: 0.9999258295460781,
      isCrypto: true,
    ),
    CurrencyModel(
      code: 'DAI',
      name: 'Dai',
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
