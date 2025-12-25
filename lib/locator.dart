import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:currency_converter/app/environment/app_environment.dart';
import 'package:currency_converter/core/clients/network/network_client.dart';
import 'package:currency_converter/feature/convert/data/datasources/convert_remote_data_source.dart';
import 'package:currency_converter/feature/convert/data/repositories/convert_repository_impl.dart';
import 'package:currency_converter/feature/convert/domain/repositories/convert_repository.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_latest_rates_usecase.dart';

/// [Locator] is responsible for locating and registering all the
/// services of the application.
abstract final class Locator {
  /// [GetIt] instance
  @visibleForTesting
  static final instance = GetIt.instance;

  /// Returns instance of [NetworkClient]
  static NetworkClient get networkClient => instance<NetworkClient>();

  /// Responsible for registering all the dependencies
  static Future<void> locateServices({required AppEnvironment environment}) async {
    instance
      // Clients
      ..registerLazySingleton(() => NetworkClient(dio: instance(), baseUrl: environment.baseUrl))
      // Client Dependencies
      ..registerFactory(Dio.new)
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
