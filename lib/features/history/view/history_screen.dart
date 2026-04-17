import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:velouscambo/core/constants/app_colors.dart';
import 'package:velouscambo/features/history/viewmodel/history_viewmodel.dart';
import 'package:velouscambo/features/history/widgets/rental_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ride History'),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(HistoryViewModel vm) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }
    if (vm.rentals.isEmpty) {
      return const _EmptyHistory();
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.rentals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => RentalCard(rental: vm.rentals[i], index: i),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.history_rounded,
                color: AppColors.textLight, size: 38),
          ),
          const SizedBox(height: 18),
          const Text(
            'No rides yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your completed rides will appear here',
            style: TextStyle(fontSize: 14, color: AppColors.textMedium),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}
