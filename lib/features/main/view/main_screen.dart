import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velouscambo/core/constants/app_colors.dart';
import 'package:velouscambo/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:velouscambo/features/history/viewmodel/history_viewmodel.dart';
import 'package:velouscambo/features/map/viewmodel/station_viewmodel.dart';
import 'package:velouscambo/features/map/view/home_screen.dart';
import 'package:velouscambo/features/search/view/search_screen.dart';
import 'package:velouscambo/features/history/view/history_screen.dart';
import 'package:velouscambo/features/profile/view/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        hasActiveRental: hasActive,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final bool hasActiveRental;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.hasActiveRental,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.map_outlined,
                activeIcon: Icons.map_rounded,
                label: 'Map',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.search_rounded,
                activeIcon: Icons.search_rounded,
                label: 'Search',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.history_rounded,
                activeIcon: Icons.history_rounded,
                label: 'History',
                isActive: currentIndex == 2,
                badge: hasActiveRental,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    this.badge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? activeIcon : icon,
                    key: ValueKey(isActive),
                    color: isActive ? AppColors.primary : AppColors.textLight,
                    size: 24,
                  ),
                ),
                if (badge)
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.available,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textLight,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
