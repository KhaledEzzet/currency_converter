import 'dart:convert';

import 'package:currency_converter/core/clients/network/network_client.dart';
import 'package:currency_converter/feature/convert/data/datasources/convert_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_client_adapter.dart';

ResponseBody _jsonResponse(String body) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

void main() {
  group('ConvertRemoteDataSourceImpl', () {
    test('fetchCurrencies parses response map', () async {
      final adapter = FakeHttpClientAdapter((options) {
        expect(options.path, '/currencies');
        final payload = <String, String>{
          'USD': 'United States Dollar',
          'EUR': 'Euro',
        };
        return _jsonResponse(jsonEncode(payload));
      });
      final dio = Dio()..httpClientAdapter = adapter;
      final client = NetworkClient(
        dio: dio,
        baseUrl: 'https://api.frankfurter.app',
      );
      final dataSource = ConvertRemoteDataSourceImpl(networkClient: client);

      final result = await dataSource.fetchCurrencies();

      expect(result, containsPair('USD', 'United States Dollar'));
      expect(result, containsPair('EUR', 'Euro'));
    });

    test('fetchLatestRates sends correct query and parses rates', () async {
      final adapter = FakeHttpClientAdapter((options) {
        expect(options.path, '/latest');
        expect(options.queryParameters['from'], 'USD');
        expect(options.queryParameters['to'], 'EUR,GBP');
        expect(options.queryParameters['amount'], anyOf(2, 2.0));
        final payload = <String, dynamic>{
          'amount': 2,
          'base': 'USD',
          'date': '2024-01-01',
          'rates': <String, num>{
            'EUR': 1.8,
            'GBP': 1.6,
          },
        };
        return _jsonResponse(jsonEncode(payload));
      });
      final dio = Dio()..httpClientAdapter = adapter;
      final client = NetworkClient(
        dio: dio,
        baseUrl: 'https://api.frankfurter.app',
      );
      final dataSource = ConvertRemoteDataSourceImpl(networkClient: client);

      final result = await dataSource.fetchLatestRates(
        from: 'USD',
        to: <String>['EUR', 'GBP'],
        amount: 2,
      );

      expect(result.base, 'USD');
      expect(result.rates['EUR'], 1.8);
      expect(result.rates['GBP'], 1.6);
    });
  });
}
