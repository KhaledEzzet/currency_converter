import 'package:currency_converter/app/environment/production_environment.dart';
import 'package:currency_converter/app/view/app.dart';
import 'package:currency_converter/bootstrap.dart';

Future<void> main() async {
  await bootstrap(builder: App.new, environment: ProductionEnvironment());
}
