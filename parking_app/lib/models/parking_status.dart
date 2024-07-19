class ParkingStatus {
  final int availableSpots;
  final int occupiedSpots;

  ParkingStatus({required this.availableSpots, required this.occupiedSpots});

  factory ParkingStatus.fromJson(Map<String, dynamic> json) {
    return ParkingStatus(
      availableSpots: json['available_spots'],
      occupiedSpots: json['occupied_spots'],
    );
  }
}
