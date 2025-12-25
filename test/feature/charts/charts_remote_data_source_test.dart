import 'dart:convert';

import 'package:currency_converter/core/clients/network/network_client.dart';
import 'package:currency_converter/feature/charts/data/datasources/charts_remote_data_source.dart';
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
  group('ChartsRemoteDataSourceImpl', () {
    test('fetchTimeseries hits range endpoint and parses rates', () async {
      final adapter = FakeHttpClientAdapter((options) {
        expect(options.path, '/2024-01-01..2024-01-07');
        expect(options.queryParameters['from'], 'USD');
        expect(options.queryParameters['to'], 'EUR');
        final payload = <String, dynamic>{
          'base': 'USD',
          'start_date': '2024-01-01',
          'end_date': '2024-01-07',
          'rates': <String, dynamic>{
            '2024-01-01': <String, num>{'EUR': 0.9},
            '2024-01-02': <String, num>{'EUR': 0.91},
          },
        };
        return _jsonResponse(jsonEncode(payload));
      });
      final dio = Dio()..httpClientAdapter = adapter;
      final client = NetworkClient(
        dio: dio,
        baseUrl: 'https://api.frankfurter.app',
      );
      final dataSource = ChartsRemoteDataSourceImpl(networkClient: client);

      final result = await dataSource.fetchTimeseries(
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 7),
        from: 'USD',
        to: 'EUR',
      );

      expect(result.base, 'USD');
      expect(result.rates[DateTime.parse('2024-01-01')], 0.9);
      expect(result.rates[DateTime.parse('2024-01-02')], 0.91);
    });
  });
}
