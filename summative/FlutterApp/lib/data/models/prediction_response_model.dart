import '../../domain/entities/prediction_result.dart';

class PredictionResponseModel {
  final String matchedDistrict;
  final String marketTier;
  final String bostonProxy;
  final double distTocentroidKm;
  final double locationFactor;
  final double predictedUsdNight;
  final double peakSeasonUsd;
  final double inputLat;
  final double inputLon;

  const PredictionResponseModel({
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

  factory PredictionResponseModel.fromJson(Map<String, dynamic> json) {
    return PredictionResponseModel(
      matchedDistrict: json['matched_district'] as String,
      marketTier: json['market_tier'] as String,
      bostonProxy: json['boston_proxy'] as String,
      distTocentroidKm: (json['dist_to_centroid_km'] as num).toDouble(),
      locationFactor: (json['location_factor'] as num).toDouble(),
      predictedUsdNight: (json['predicted_usd_night'] as num).toDouble(),
      peakSeasonUsd: (json['peak_season_usd'] as num).toDouble(),
      inputLat: (json['input_lat'] as num).toDouble(),
      inputLon: (json['input_lon'] as num).toDouble(),
    );
  }

  PredictionResult toEntity() => PredictionResult(
        matchedDistrict: matchedDistrict,
        marketTier: marketTier,
        bostonProxy: bostonProxy,
        distTocentroidKm: distTocentroidKm,
        locationFactor: locationFactor,
        predictedUsdNight: predictedUsdNight,
        peakSeasonUsd: peakSeasonUsd,
        inputLat: inputLat,
        inputLon: inputLon,
      );
}
