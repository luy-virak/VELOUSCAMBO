import 'package:flutter/material.dart';
import 'package:velouscambo/core/constants/app_colors.dart';
import 'nav_item.dart';

class AppNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool hasActiveRental;

  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.hasActiveRental = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: selectedIndex == 0
                    ? Icons.map_rounded
                    : Icons.map_outlined,
                label: "Map",
                isSelected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              NavItem(
                icon: Icons.history_rounded,
                label: "History",
                isSelected: selectedIndex == 1,
                badge: hasActiveRental,
                onTap: () => onTap(1),
              ),
              NavItem(
                icon: selectedIndex == 2
                    ? Icons.person_rounded
                    : Icons.person_outline_rounded,
                label: "Profile",
                isSelected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
