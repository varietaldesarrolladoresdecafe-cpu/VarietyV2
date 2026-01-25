import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'core/services/service_locator.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/calibration/presentation/pages/home_page.dart';
import 'features/calibration/presentation/viewmodels/calibration_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Inicializar inyección de dependencias
  runApp(const VarietyCoffeeApp());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class VarietyCoffeeApp extends StatelessWidget {
  const VarietyCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Registrar ViewModels aquí
        ChangeNotifierProvider(create: (_) => di.sl<CalibrationViewModel>()),
      ],
      child: MaterialApp(
        title: 'Variety Coffee Developers',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        scrollBehavior: AppScrollBehavior(),
        home: const HomePage(),
      ),
    );
  }
}
