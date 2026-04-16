import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/bike_model.dart';
import '../../models/station_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/station_provider.dart';
import '../../widgets/custom_button.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late BikeModel _bike;
  late StationModel _station;
  bool _argumentsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsLoaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _bike = args['bike'] as BikeModel;
      _station = args['station'] as StationModel;
      _argumentsLoaded = true;
    }
  }

  Future<void> _confirmBooking() async {
    final auth = context.read<AuthProvider>();
    final sp = context.read<StationProvider>();
    final uid = auth.firebaseUser?.uid;
    if (uid == null) return;

    final rental = await sp.startRental(
      userId: uid,
      bike: _bike,
      station: _station,
    );

    if (rental != null && mounted) {
      Navigator.pushReplacementNamed(context, '/active-rental');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to start rental. Please try again.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_argumentsLoaded) return const SizedBox.shrink();
    final sp = context.watch<StationProvider>();
    final user = context.watch<AuthProvider>().userModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm Booking'),
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike card
            _SectionLabel(label: 'Your Bike'),
            const SizedBox(height: 10),
            _BikeDetailCard(bike: _bike)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.05),

            const SizedBox(height: 20),

            // Station card
            _SectionLabel(label: 'Pick-up Station'),
            const SizedBox(height: 10),
            _StationCard(station: _station)
                .animate()
                .fadeIn(delay: 80.ms)
                .slideY(begin: 0.05),

            const SizedBox(height: 20),

            // Plan info
            if (user != null) ...[
              _SectionLabel(label: 'Your Plan'),
              const SizedBox(height: 10),
              _PlanCard(user: user)
                  .animate()
                  .fadeIn(delay: 160.ms)
                  .slideY(begin: 0.05),
              const SizedBox(height: 20),
            ],

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'After booking, you will get a 30-second unlock window '
                      'where the alarm is turned off for your selected bike.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 240.ms),

            const SizedBox(height: 32),

            PrimaryButton(
              label: 'Book Bike',
              icon: Icons.pedal_bike_rounded,
              onPressed: _confirmBooking,
              isLoading: sp.isLoading,
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

            const SizedBox(height: 12),

            SecondaryButton(
              label: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ).animate().fadeIn(delay: 360.ms),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textMedium,
          letterSpacing: 0.3,
        ),
      );
}

// ─── Bike Detail Card ─────────────────────────────────────────────────────────

class _BikeDetailCard extends StatelessWidget {
  final BikeModel bike;
  const _BikeDetailCard({required this.bike});

  @override
  Widget build(BuildContext context) {
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.availableLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.pedal_bike_rounded,
                color: AppColors.available, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bike #${bike.code}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                _StarRow(rating: bike.condition),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.availableLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Available',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.available,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Station Card ─────────────────────────────────────────────────────────────

class _StationCard extends StatelessWidget {
  final StationModel station;
  const _StationCard({required this.station});

  @override
  Widget build(BuildContext context) {
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.location_on_rounded,
                color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  station.address,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMedium),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Plan Card ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final dynamic user;
  const _PlanCard({required this.user});

  @override
  Widget build(BuildContext context) {
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.card_membership_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.planDisplayName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  user.hasActivePlan ? 'Active subscription' : 'No active plan',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMedium),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: user.hasActivePlan
                  ? AppColors.availableLight
                  : AppColors.divider,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              user.hasActivePlan ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: user.hasActivePlan
                    ? AppColors.available
                    : AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Star Row ─────────────────────────────────────────────────────────────────

class _StarRow extends StatelessWidget {
  final double rating;
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
          (i) => Icon(
            i < rating.floor()
                ? Icons.star_rounded
                : (i < rating
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded),
            size: 14,
            color: const Color(0xFFFFC107),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${rating.toStringAsFixed(1)} condition',
          style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
        ),
      ],
    );
  }
}
