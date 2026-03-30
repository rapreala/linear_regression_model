import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme/app_theme.dart';
import 'presentation/blocs/rooms/rooms_bloc.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const KigaliLodgeApp());
}

class KigaliLodgeApp extends StatelessWidget {
  const KigaliLodgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // RoomsBloc lives at the root — survives any navigation push/pop.
    return BlocProvider(
      create: (_) => RoomsBloc(),
      child: MaterialApp(
        title: 'Kigali Lodge Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const DashboardScreen(),
      ),
    );
  }
}
