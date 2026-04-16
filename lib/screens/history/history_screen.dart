import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/rental_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthProvider>().firebaseUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ride History'),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
      ),
      body: uid == null
          ? const Center(child: Text('Please sign in to view history.'))
          : StreamBuilder<List<RentalModel>>(
              stream: FirestoreService().getRentalHistory(uid),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                final rentals = snap.data ?? [];
                if (rentals.isEmpty) return const _EmptyHistory();
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rentals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) => _RentalCard(
                    rental: rentals[i],
                    index: i,
                  ),
                );
              },
            ),
    );
  }
}

// ─── Rental Card ──────────────────────────────────────────────────────────────

class _RentalCard extends StatelessWidget {
  final RentalModel rental;
  final int index;
  const _RentalCard({required this.rental, required this.index});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(rental.startTime);
    final timeStr = DateFormat('HH:mm').format(rental.startTime);
    final duration = rental.durationMinutes ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.pedal_bike_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rental.stationName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '$dateStr • $timeStr',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMedium),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.pedal_bike_rounded,
                        size: 12, color: AppColors.textLight),
                    const SizedBox(width: 3),
                    Text(
                      'Bike #${rental.bikeCode}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${duration}m',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Completed',
                style: TextStyle(fontSize: 11, color: AppColors.available),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 50).ms)
        .slideY(begin: 0.05, curve: Curves.easeOut);
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
