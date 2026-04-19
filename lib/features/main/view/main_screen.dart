import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velouscambo/core/constants/app_colors.dart';
import 'package:velouscambo/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:velouscambo/features/history/viewmodel/history_viewmodel.dart';
import 'package:velouscambo/features/map/viewmodel/station_viewmodel.dart';
import 'package:velouscambo/features/map/view/home_screen.dart';
import 'package:velouscambo/features/history/view/history_screen.dart';
import 'package:velouscambo/features/profile/view/profile_screen.dart';
import 'package:velouscambo/shared/widgets/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthViewModel>().firebaseUser?.uid;
    if (uid != null) {
      context.read<StationViewModel>().init(uid);
      context.read<HistoryViewModel>().load(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasActive = context.watch<StationViewModel>().hasActiveRental;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: _currentIndex,
        hasActiveRental: hasActive,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
