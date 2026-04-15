import 'package:flutter/material.dart';
import '../screens/route_placeholder.dart';

import 'nav_item.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int selectedIndex = 0;

  final List<Widget> _screens = const [
    MapScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(
                  icon: selectedIndex == 0 ? Icons.map_rounded : Icons.map_outlined,
                  label: "Map",
                  isSelected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
                NavItem(
                  icon: Icons.history_rounded,
                  label: "History",
                  isSelected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
                NavItem(
                  icon: selectedIndex == 2 ? Icons.person_rounded : Icons.person_outline_rounded,
                  label: "Profile",
                  isSelected: selectedIndex == 2,
                  onTap: () => onTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}