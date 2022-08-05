import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropDown(){
    List<DropdownMenuItem<String>> dropDownItems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(child: Text(currency),value: currency,);
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState((){
            selectedCurrency=value!;
            getData();
          });
        },);
  }
  CupertinoPicker IOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
        backgroundColor: Color(0xFF409998),

        itemExtent: 32.0, onSelectedItemChanged: (selectedIndex) {
      setState(() {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      });
    },
        children: pickerItems);
  }
  Map<String, String> coinValues = {};
  bool isWaiting = false;


  void getData()async{
    isWaiting=true;

    try{
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting=false;
      setState((){
        coinValues= data;
      });
    }
    catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Hub'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoCurrency: 'BTC',
            value: isWaiting ? '?': coinValues['BTC'].toString(),
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'ETH',
            value: isWaiting ? '?': coinValues['ETH'].toString(),
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'LTC',
            value: isWaiting ? '?': coinValues['LTC'].toString(),
            selectedCurrency: selectedCurrency,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Color(0xFF409998),
            child: Platform.isIOS ? IOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Color(0xFF409090),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1$cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
