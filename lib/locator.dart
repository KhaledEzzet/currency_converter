import 'package:currency_converter/app/environment/app_environment.dart';
import 'package:currency_converter/core/clients/network/network_client.dart';
import 'package:currency_converter/feature/charts/data/datasources/charts_remote_data_source.dart';
import 'package:currency_converter/feature/charts/data/repositories/charts_repository_impl.dart';
import 'package:currency_converter/feature/charts/domain/repositories/charts_repository.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_charts_currencies_usecase.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_timeseries_rates_usecase.dart';
import 'package:currency_converter/feature/convert/data/datasources/convert_remote_data_source.dart';
import 'package:currency_converter/feature/convert/data/repositories/convert_repository_impl.dart';
import 'package:currency_converter/feature/convert/domain/repositories/convert_repository.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_latest_rates_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// [Locator] is responsible for locating and registering all the
/// services of the application.
abstract final class Locator {
  /// [GetIt] instance
  @visibleForTesting
  static final instance = GetIt.instance;

  /// Returns a registered dependency of type [T].
  static T resolve<T extends Object>() => instance<T>();

  /// Returns instance of [NetworkClient]
  static NetworkClient get networkClient => instance<NetworkClient>();

  /// Responsible for registering all the dependencies
  static Future<void> locateServices({
    required AppEnvironment environment,
  }) async {
    instance
      // Clients
      ..registerLazySingleton(
        () => NetworkClient(dio: instance(), baseUrl: environment.baseUrl),
      )
      // Client Dependencies
      ..registerFactory(Dio.new)
      // Charts Datasources
      ..registerLazySingleton<ChartsRemoteDataSource>(
        () => ChartsRemoteDataSourceImpl(networkClient: instance()),
      )
      // Charts Repositories
      ..registerLazySingleton<ChartsRepository>(
        () => ChartsRepositoryImpl(remoteDataSource: instance()),
      )
      // Charts Use Cases
      ..registerLazySingleton(
        () => GetChartsCurrenciesUseCase(repository: instance()),
      )
      ..registerLazySingleton(
        () => GetTimeseriesRatesUseCase(repository: instance()),
      )
      // Datasources
      ..registerLazySingleton<ConvertRemoteDataSource>(
        () => ConvertRemoteDataSourceImpl(networkClient: instance()),
      )
      // Repositories
      ..registerLazySingleton<ConvertRepository>(
        () => ConvertRepositoryImpl(remoteDataSource: instance()),
      )
      // Use Cases
      ..registerLazySingleton(
        () => GetLatestRatesUseCase(repository: instance()),
      )
      ..registerLazySingleton(
        () => GetCurrenciesUseCase(repository: instance()),
      );
  }
}
