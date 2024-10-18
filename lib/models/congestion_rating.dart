class CongestionRating {
  final String docId;
  final double latitude;
  final double longitude;
  final double value;
  final String capturedOn;
  final String imageUrl; // Add this line for the image URL

  CongestionRating({
    required this.docId,
    required this.latitude,
    required this.longitude,
    required this.value,
    required this.capturedOn,
    required this.imageUrl, // Update constructor to include image URL
  });
}

