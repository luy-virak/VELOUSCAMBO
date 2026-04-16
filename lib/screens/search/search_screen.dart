import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/station_model.dart';
import '../../providers/station_provider.dart';
import '../home/widgets/station_detail_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stations = context.watch<StationProvider>().stations;
    final filtered = stations.where((s) {
      final q = _query.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.address.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Stations'),
        backgroundColor: AppColors.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _ctrl,
              autofocus: false,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(fontSize: 15, color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: 'Search by name or address...',
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textLight, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.textLight, size: 18),
                        onPressed: () {
                          _ctrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? _EmptySearch(query: _query)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) => _StationListTile(
                station: filtered[i],
                index: i,
              ),
            ),
    );
  }
}

class _StationListTile extends StatelessWidget {
  final StationModel station;
  final int index;
  const _StationListTile({required this.station, required this.index});

  @override
  Widget build(BuildContext context) {
    final available = station.availableBikes;
    final isGood = available > 3;

    return GestureDetector(
      onTap: () {
        final sp = context.read<StationProvider>();
        sp.selectStation(station);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ChangeNotifierProvider.value(
            value: sp,
            child: const StationDetailSheet(),
          ),
        ).whenComplete(sp.clearSelectedStation);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.location_on_rounded,
                  color: AppColors.primary, size: 22),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pedal_bike_rounded,
                        size: 14,
                        color: isGood ? AppColors.available : AppColors.rented),
                    const SizedBox(width: 3),
                    Text(
                      '$available bikes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isGood ? AppColors.available : AppColors.rented,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${station.totalDocks} docks',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textLight),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (index * 40).ms)
          .slideY(begin: 0.05, curve: Curves.easeOut),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.search_off_rounded,
                color: AppColors.textLight, size: 34),
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No stations available' : 'No results for "$query"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different search term',
            style: TextStyle(fontSize: 13, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}
