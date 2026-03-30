class PredictionRequestModel {
  // --- Location (required) ---
  final double latitude;
  final double longitude;

  // --- Room profile (required) ---
  final int accommodates;
  final int bedrooms;
  final double bathrooms;
  final int beds;
  final int roomType; // 0=Entire home/apt | 1=Hotel room | 2=Private | 3=Shared

  // --- Host quality ---
  final int hostIsSuperhost;

  // --- Reviews ---
  final double reviewScoresRating;
  final double reviewsPerMonth;
  final int numberOfReviews;

  // --- Booking terms ---
  final int minimumNights;
  final int availability365;
  final int instantBookable;
  final int guestsIncluded;

  // --- Less-variable fields ---
  final int propertyType;
  final int bedType;
  final int hostResponseTime;
  final int calculatedHostListingsCount;
  final int cancellationPolicy;

  const PredictionRequestModel({
    required this.latitude,
    required this.longitude,
    required this.accommodates,
    required this.bedrooms,
    required this.bathrooms,
    required this.beds,
    required this.roomType,
    this.hostIsSuperhost = 0,
    this.reviewScoresRating = 90.0,
    this.reviewsPerMonth = 1.0,
    this.numberOfReviews = 10,
    this.minimumNights = 1,
    this.availability365 = 200,
    this.instantBookable = 1,
    this.guestsIncluded = 2,
    this.propertyType = 1,
    this.bedType = 0,
    this.hostResponseTime = 0,
    this.calculatedHostListingsCount = 1,
    this.cancellationPolicy = 1,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'accommodates': accommodates,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'beds': beds,
        'room_type': roomType,
        'host_is_superhost': hostIsSuperhost,
        'review_scores_rating': reviewScoresRating,
        'reviews_per_month': reviewsPerMonth,
        'number_of_reviews': numberOfReviews,
        'minimum_nights': minimumNights,
        'availability_365': availability365,
        'instant_bookable': instantBookable,
        'guests_included': guestsIncluded,
        'property_type': propertyType,
        'bed_type': bedType,
        'host_response_time': hostResponseTime,
        'calculated_host_listings_count': calculatedHostListingsCount,
        'cancellation_policy': cancellationPolicy,
      };
}
