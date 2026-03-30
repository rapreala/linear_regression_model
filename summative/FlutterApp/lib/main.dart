import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const KigaliLodgeApp());
}

class KigaliLodgeApp extends StatelessWidget {
  const KigaliLodgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kigali Lodge Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const DashboardScreen(),
    );
  }
}
