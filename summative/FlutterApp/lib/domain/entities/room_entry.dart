/// Represents a saved room in the PMS.
///
/// [finalPrice] is the owner's confirmed nightly rate — either the raw
/// AI prediction or a manually adjusted value on top of it.
class RoomEntry {
  final String name;
  final String type;
  final int accommodates;
  final int bedrooms;
  final String district;
  final double finalPrice;
  final double? predictedPrice; // AI baseline — kept for reference

  const RoomEntry({
    required this.name,
    required this.type,
    required this.accommodates,
    required this.bedrooms,
    required this.district,
    required this.finalPrice,
    this.predictedPrice,
  });
}
