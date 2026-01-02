import 'package:currency_converter/app/router/app_shell.dart';
import 'package:currency_converter/app/router/custom_route_observer.dart';
import 'package:currency_converter/feature/charts/cubit/charts_cubit.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_charts_currencies_usecase.dart';
import 'package:currency_converter/feature/charts/domain/usecases/get_timeseries_rates_usecase.dart';
import 'package:currency_converter/feature/charts/view/charts_view.dart';
import 'package:currency_converter/feature/convert/cubit/convert_cubit.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_latest_rates_usecase.dart';
import 'package:currency_converter/feature/convert/view/convert_view.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/view/settings_view.dart';
import 'package:currency_converter/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Holds all the routes that are defined in the app.
final class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/convert',
    observers: [CustomRouteObserver()],
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (_) => SettingsCubit(
              getCurrenciesUseCase: Locator.instance<GetCurrenciesUseCase>(),
            )..initialize(),
            child: child,
          );
        },
        routes: <RouteBase>[
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return AppShell(navigationShell: navigationShell);
            },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/convert',
                    name: 'convert',
                    builder: (context, state) {
                      final settingsState =
                          context.read<SettingsCubit>().state;
                      return BlocProvider(
                        create: (_) => ConvertCubit(
                          getLatestRatesUseCase:
                              Locator.instance<GetLatestRatesUseCase>(),
                          getCurrenciesUseCase:
                              Locator.instance<GetCurrenciesUseCase>(),
                          preferredBaseCurrency:
                              settingsState.baseSelectionInitialized
                                  ? settingsState.baseCurrency
                                  : null,
                        )..initialize(),
                        child: const ConvertView(),
                      );
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/charts',
                    name: 'charts',
                    builder: (context, state) {
                      final settingsState =
                          context.read<SettingsCubit>().state;
                      return BlocProvider(
                        create: (_) => ChartsCubit(
                          getChartsCurrenciesUseCase:
                              Locator.instance<GetChartsCurrenciesUseCase>(),
                          getTimeseriesRatesUseCase:
                              Locator.instance<GetTimeseriesRatesUseCase>(),
                          preferredBaseCurrency:
                              settingsState.baseSelectionInitialized
                                  ? settingsState.baseCurrency
                                  : null,
                        )..initialize(),
                        child: const ChartsView(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) {
              return const SettingsView();
            },
          ),
        ],
      ),
    ],
  );
}
