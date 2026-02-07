import 'package:flutter/material.dart';
import 'package:pump_shield_bharat/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/engineer_dashboard.dart';
import 'screens/manager_dashboard.dart';
import 'screens/technician_dashboard.dart';
import 'screens/machine_history_screen.dart';

void main() {
  runApp(const PumpShieldApp());
}

class PumpShieldApp extends StatelessWidget {
  const PumpShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PumpShield Bharat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/qr_scanner': (context) => const QRScannerScreen(),
        '/engineer_dashboard': (context) => const EngineerDashboard(),
        '/manager_dashboard': (context) => const ManagerDashboard(),
        '/technician_dashboard': (context) => const TechnicianDashboard(),
        '/machine_history': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return MachineHistoryScreen(pumpId: args?['pumpId'] ?? '001');
        },
      },
    );
  }
}
