class RentInterest {
  final DateTime preferredStartDate;
  final String pickupArea;
  final String contact;

  RentInterest({
    required this.preferredStartDate,
    required this.pickupArea,
    required this.contact,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferredStartDate': preferredStartDate.toIso8601String(),
      'pickupArea': pickupArea,
      'contact': contact,
    };
  }

  factory RentInterest.fromJson(Map<String, dynamic> json) {
    return RentInterest(
      preferredStartDate: DateTime.parse(json['preferredStartDate']),
      pickupArea: json['pickupArea'],
      contact: json['contact'],
    );
  }
}
