class Bike {
  final String id;
  final String model;
  final String imageUrl;
  final int rangeKm;
  final int maxSpeedKm;
  final bool isAvailable;
  final String category; // e.g., "City", "Cargo", "Sport"
  final double pricePerDay;

  Bike({
    required this.id,
    required this.model,
    required this.imageUrl,
    required this.rangeKm,
    required this.maxSpeedKm,
    required this.isAvailable,
    required this.category,
    required this.pricePerDay,
  });
}
