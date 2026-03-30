class KigaliDistrict {
  final String name;
  final String tier;
  final double lat;
  final double lon;
  final int bostonMedianUsd;

  const KigaliDistrict({
    required this.name,
    required this.tier,
    required this.lat,
    required this.lon,
    required this.bostonMedianUsd,
  });
}

const List<KigaliDistrict> kKigaliDistricts = [
  KigaliDistrict(name: 'Rebero',      tier: 'Luxury',    lat: -1.9784, lon: 30.0887, bostonMedianUsd: 229),
  KigaliDistrict(name: 'Nyarutarama', tier: 'Luxury',    lat: -1.9271, lon: 30.1025, bostonMedianUsd: 209),
  KigaliDistrict(name: 'Kagugu',      tier: 'Luxury',    lat: -1.9200, lon: 30.0800, bostonMedianUsd: 206),
  KigaliDistrict(name: 'Kiyovu',      tier: 'Luxury',    lat: -1.9530, lon: 30.0589, bostonMedianUsd: 199),
  KigaliDistrict(name: 'Kimihurura',  tier: 'Luxury',    lat: -1.9441, lon: 30.0869, bostonMedianUsd: 195),
  KigaliDistrict(name: 'Kacyiru',     tier: 'Premium',   lat: -1.9442, lon: 30.0621, bostonMedianUsd: 190),
  KigaliDistrict(name: 'Kibagabaga',  tier: 'Premium',   lat: -1.9173, lon: 30.1115, bostonMedianUsd: 179),
  KigaliDistrict(name: 'Remera',      tier: 'Mid-range', lat: -1.9567, lon: 30.1119, bostonMedianUsd: 150),
  KigaliDistrict(name: 'Nyamirambo',  tier: 'Budget',    lat: -1.9782, lon: 30.0489, bostonMedianUsd: 100),
  KigaliDistrict(name: 'Kanombe',     tier: 'Budget',    lat: -1.9734, lon: 30.1431, bostonMedianUsd: 99),
  KigaliDistrict(name: 'Gikondo',     tier: 'Budget',    lat: -1.9870, lon: 30.0609, bostonMedianUsd: 90),
  KigaliDistrict(name: 'Gatenga',     tier: 'Budget',    lat: -2.0097, lon: 30.0703, bostonMedianUsd: 85),
  KigaliDistrict(name: 'Gisozi',      tier: 'Budget',    lat: -1.9306, lon: 30.1067, bostonMedianUsd: 85),
  KigaliDistrict(name: 'Kicukiro',    tier: 'Budget',    lat: -2.0033, lon: 30.0722, bostonMedianUsd: 76),
  KigaliDistrict(name: 'Masaka',      tier: 'Economy',   lat: -2.0363, lon: 30.0820, bostonMedianUsd: 72),
  KigaliDistrict(name: 'Kanombe Far', tier: 'Economy',   lat: -1.9950, lon: 30.1600, bostonMedianUsd: 58),
];

const Map<String, String> kTierColors = {
  'Luxury': '#C9A84C',
  'Premium': '#6B7FD7',
  'Mid-range': '#4CBBAC',
  'Budget': '#78A55A',
  'Economy': '#A0A0A0',
};
