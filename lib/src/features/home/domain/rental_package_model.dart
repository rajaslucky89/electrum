class RentalPackage {
  final String id;
  final String name;
  final double price;
  final String duration; // e.g., "Day", "Week", "Month"
  final List<String> terms;

  RentalPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.terms,
  });
}
