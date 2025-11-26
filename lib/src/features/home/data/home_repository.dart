import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electrum/src/features/home/domain/promotion_model.dart';
import 'package:electrum/src/features/home/domain/rental_package_model.dart';

class HomeRepository {
  Future<List<Promotion>> getPromotions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Promotion(
        id: '1',
        title: 'Summer Sale',
        description: 'Get 20% off on weekly rentals!',
        imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&w=800&q=80',
        validity: 'Valid until Aug 31',
      ),
      Promotion(
        id: '2',
        title: 'New Rider Bonus',
        description: 'First day free for new users.',
        imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=800&q=80',
        validity: 'Valid for new signups',
      ),
    ];
  }

  Future<List<RentalPackage>> getRentalPackages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      RentalPackage(
        id: '1',
        name: 'Daily Commuter',
        price: 15.0,
        duration: 'Day',
        terms: ['Unlimited mileage', 'Insurance included'],
      ),
      RentalPackage(
        id: '2',
        name: 'Weekly Explorer',
        price: 80.0,
        duration: 'Week',
        terms: ['Unlimited mileage', 'Free charging at stations'],
      ),
      RentalPackage(
        id: '3',
        name: 'Monthly Pro',
        price: 250.0,
        duration: 'Month',
        terms: ['Premium support', 'Free maintenance'],
      ),
    ];
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});

final promotionsProvider = FutureProvider<List<Promotion>>((ref) async {
  return ref.watch(homeRepositoryProvider).getPromotions();
});

final rentalPackagesProvider = FutureProvider<List<RentalPackage>>((ref) async {
  return ref.watch(homeRepositoryProvider).getRentalPackages();
});
