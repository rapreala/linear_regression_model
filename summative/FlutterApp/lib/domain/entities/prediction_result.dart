import 'package:equatable/equatable.dart';

class PredictionResult extends Equatable {
  final String matchedDistrict;
  final String marketTier;
  final String bostonProxy;
  final double distTocentroidKm;
  final double locationFactor;
  final double predictedUsdNight;
  final double peakSeasonUsd;
  final double inputLat;
  final double inputLon;

  const PredictionResult({
    required this.matchedDistrict,
    required this.marketTier,
    required this.bostonProxy,
    required this.distTocentroidKm,
    required this.locationFactor,
    required this.predictedUsdNight,
    required this.peakSeasonUsd,
    required this.inputLat,
    required this.inputLon,
  });

  @override
  List<Object?> get props => [
        matchedDistrict,
        marketTier,
        predictedUsdNight,
        peakSeasonUsd,
      ];
}
