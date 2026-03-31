import 'package:currency_converter/models/allCurrencies.dart';
import 'package:http/http.dart' as http;

import 'package:currency_converter/utils/key.dart';

import '../models/ratesModelFromJson.dart';

Future<RatesModel> fetchRates() async {
  final response = await http.get(
    Uri.parse(
      'https://openexchangerates.org/api/latest.json?app_id=$key',
    ),
  );
  print(response.body);
  final result = ratesModelFromJson(response.body);
  return result;
}

Future<Map> fetchcurrencies() async {
  final response = await http.get(
    Uri.parse(
      'https://openexchangerates.org/api/currencies.json?app_id=$key',
    ),
  );
  final allCurrencies = allCurrenciesFromJson(response.body);
  return allCurrencies;
}
