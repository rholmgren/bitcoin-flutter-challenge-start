import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '47FCAEBE-4809-4881-9A85-0C91BD916A89';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      var url = Uri.parse('$coinAPIURL/$crypto/$selectedCurrency');
      var response = await http.get(url, headers: {'X-CoinAPI-Key': apiKey});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print("status code is ${response.statusCode}");
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
