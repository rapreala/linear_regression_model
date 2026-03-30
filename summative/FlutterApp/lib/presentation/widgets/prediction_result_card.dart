import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../domain/entities/prediction_result.dart';

class PredictionResultCard extends StatelessWidget {
  final PredictionResult result;
  const PredictionResultCard({super.key, required this.result});

  Color _tierColor(String tier) => switch (tier) {
        'Luxury'    => const Color(0xFFD06224),
        'Premium'   => const Color(0xFF7C3AED),
        'Mid-range' => const Color(0xFF0891B2),
        'Budget'    => const Color(0xFF16A34A),
        _           => const Color(0xFF6B7280),
      };

  @override
  Widget build(BuildContext context) {
    final tierColor = _tierColor(result.marketTier);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.stone50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.stone200),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.auto_graph_rounded,
                  color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Price Prediction',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppTheme.textPrimary),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: tierColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  result.marketTier,
                  style: TextStyle(
                    color: tierColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Primary price ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Text(
                  'Recommended Nightly Rate',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${result.predictedUsdNight.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                  ),
                ),
                const Text(
                  'per night · USD',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Peak season ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                const Text(
                  'Peak Season (+25%)',
                  style: TextStyle(
                      color: AppTheme.primaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  '\$${result.peakSeasonUsd.toStringAsFixed(2)} / night',
                  style: const TextStyle(
                    color: AppTheme.primaryDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Detail rows ───────────────────────────────────────────────────
          const Divider(height: 1),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Matched District',
            value: result.matchedDistrict,
          ),
          _DetailRow(
            icon: Icons.map_outlined,
            label: 'Market Proxy',
            value: result.bostonProxy,
          ),
          _DetailRow(
            icon: Icons.near_me_outlined,
            label: 'Distance to Centre',
            value: '${result.distTocentroidKm.toStringAsFixed(1)} km',
          ),
          _DetailRow(
            icon: Icons.trending_up_rounded,
            label: 'Location Factor',
            value: '×${result.locationFactor.toStringAsFixed(2)}',
            valueColor: result.locationFactor >= 1.0
                ? const Color(0xFF16A34A)
                : const Color(0xFFDC2626),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
