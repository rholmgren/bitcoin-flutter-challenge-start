import 'dart:io' show Platform;

import 'package:bitcoin_ticker/crypto_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double bitcoinValue;
  double ethValue;
  double ltcValue;

  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    try {
      dynamic btcData = await CoinData().getCoinData(selectedCurrency, 'BTC');
      dynamic ethData = await CoinData().getCoinData(selectedCurrency, 'ETH');
      dynamic ltcData = await CoinData().getCoinData(selectedCurrency, 'LTC');
      setState(() {
        bitcoinValue = btcData['rate'];
        ethValue = ethData['rate'];
        ltcValue = ltcData['rate'];
      });
    } catch (e) {
      print(e);
    }
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                  cryptoCurrency: 'BTC',
                  selectedCurrency: selectedCurrency,
                  value: bitcoinValue.toString()),
              CryptoCard(
                  cryptoCurrency: 'ETH',
                  selectedCurrency: selectedCurrency,
                  value: ethValue.toString()),
              CryptoCard(
                  cryptoCurrency: 'LTC',
                  selectedCurrency: selectedCurrency,
                  value: ltcValue.toString()),
            ],
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown()),
        ],
      ),
    );
  }
}
