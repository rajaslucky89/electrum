import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electrum/src/features/bikes/domain/bike_model.dart';

class BikesRepository {
  final List<Bike> _bikes = [
    Bike(
      id: '1',
      model: 'Electrum City X',
      imageUrl: 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&w=800&q=80',
      rangeKm: 60,
      maxSpeedKm: 25,
      isAvailable: true,
      category: 'City',
      pricePerDay: 15.0,
    ),
    Bike(
      id: '2',
      model: 'Electrum Cargo Pro',
      imageUrl: 'https://images.unsplash.com/photo-1626847037657-fd34d2eb3b44?auto=format&fit=crop&w=800&q=80',
      rangeKm: 50,
      maxSpeedKm: 25,
      isAvailable: true,
      category: 'Cargo',
      pricePerDay: 20.0,
    ),
    Bike(
      id: '3',
      model: 'Electrum Sport S',
      imageUrl: 'https://images.unsplash.com/photo-1507035895480-2b3156c3112c?auto=format&fit=crop&w=800&q=80',
      rangeKm: 80,
      maxSpeedKm: 45,
      isAvailable: false,
      category: 'Sport',
      pricePerDay: 25.0,
    ),
    Bike(
      id: '4',
      model: 'Electrum Mini',
      imageUrl: 'https://images.unsplash.com/photo-1485965120184-e224f723d621?auto=format&fit=crop&w=800&q=80',
      rangeKm: 40,
      maxSpeedKm: 20,
      isAvailable: true,
      category: 'City',
      pricePerDay: 12.0,
    ),
  ];

  Future<List<Bike>> getBikes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bikes;
  }

  Future<Bike?> getBike(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _bikes.firstWhere((bike) => bike.id == id);
    } catch (e) {
      return null;
    }
  }
}

final bikesRepositoryProvider = Provider<BikesRepository>((ref) {
  return BikesRepository();
});

final bikesProvider = FutureProvider<List<Bike>>((ref) async {
  return ref.watch(bikesRepositoryProvider).getBikes();
});

final bikeProvider = FutureProvider.family<Bike?, String>((ref, id) async {
  return ref.watch(bikesRepositoryProvider).getBike(id);
});
