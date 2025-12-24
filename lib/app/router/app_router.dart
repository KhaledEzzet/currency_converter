import 'package:currency_converter/app/router/custom_route_observer.dart';
import 'package:currency_converter/feature/home/view/home_view.dart';
import 'package:go_router/go_router.dart';

/// Holds all the routes that are defined in the app.
final class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    observers: [CustomRouteObserver()],
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
