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
const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '8F2BD3A2-C3DA-4B11-A56D-0861CB0A8821';
class CoinData {
  Future getCoinData() async{
    Uri workingUrl = '$coinApiUrl/BTC/USD?apikey=$apiKey' as Uri;
    http.Response response = await http.get(workingUrl);
    if(response==200){
      var decodedData = jsonDecode(response.body);
      var latestPrice = decodedData['rate'];
      return latestPrice;
    }
    else{
      print(response.statusCode);
    }
  }

}