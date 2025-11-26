import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electrum/src/features/auth/data/auth_repository.dart';
import 'package:electrum/src/features/bikes/data/bikes_repository.dart';
import 'package:electrum/src/features/bikes/domain/bike_model.dart';
import 'package:electrum/src/features/home/data/home_repository.dart';
import 'package:electrum/src/features/home/domain/promotion_model.dart';
import 'package:electrum/src/features/home/domain/rental_package_model.dart';
import 'package:electrum/src/routing/router.dart';

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String>(() {
  return SelectedCategoryNotifier();
});

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'All';
  }

  void setCategory(String category) {
    state = category;
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final promotionsValue = ref.watch(promotionsProvider);
    final packagesValue = ref.watch(rentalPackagesProvider);
    final bikesValue = ref.watch(bikesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(promotionsProvider);
          ref.invalidate(rentalPackagesProvider);
          ref.invalidate(bikesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hello, ${user?.name ?? 'Rider'}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildSectionTitle(context, 'Promotions'),
              SizedBox(
                height: 180,
                child: promotionsValue.when(
                  data: (promotions) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: promotions.length,
                    itemBuilder: (context, index) => PromotionCard(promotion: promotions[index]),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Rental Packages'),
              SizedBox(
                height: 140,
                child: packagesValue.when(
                  data: (packages) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: packages.length,
                    itemBuilder: (context, index) => RentalPackageCard(package: packages[index]),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Available Bikes'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(context, ref, 'All', selectedCategory == 'All'),
                      _buildFilterChip(context, ref, 'City', selectedCategory == 'City'),
                      _buildFilterChip(context, ref, 'Cargo', selectedCategory == 'Cargo'),
                      _buildFilterChip(context, ref, 'Sport', selectedCategory == 'Sport'),
                    ],
                  ),
                ),
              ),
              bikesValue.when(
                data: (bikes) {
                  final filteredBikes = selectedCategory == 'All'
                      ? bikes
                      : bikes.where((bike) => bike.category == selectedCategory).toList();
                  
                  if (filteredBikes.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: Text('No bikes found in this category')),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredBikes.length,
                    itemBuilder: (context, index) => BikeCard(bike: filteredBikes[index]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.rentInterest.name),
        label: const Text('Interested to Rent'),
        icon: const Icon(Icons.directions_bike),
        backgroundColor: const Color(0xFF0066CC),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, WidgetRef ref, String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (bool value) {
          ref.read(selectedCategoryProvider.notifier).setCategory(label);
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF0066CC).withOpacity(0.1),
        labelStyle: TextStyle(
          color: selected ? const Color(0xFF0066CC) : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selected ? const Color(0xFF0066CC) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class PromotionCard extends StatelessWidget {
  final Promotion promotion;
  const PromotionCard({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(promotion.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              promotion.title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              promotion.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              promotion.validity,
              style: const TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class RentalPackageCard extends StatelessWidget {
  final RentalPackage package;
  const RentalPackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '\$${package.price}/${package.duration}',
            style: const TextStyle(color: Color(0xFF0066CC), fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Spacer(),
          Text(
            package.terms.first,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class BikeCard extends StatelessWidget {
  final Bike bike;
  const BikeCard({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () => context.goNamed(AppRoute.bikeDetails.name, pathParameters: {'id': bike.id}),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                bike.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bike.model,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bike.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          bike.isAvailable ? 'Available' : 'Booked',
                          style: TextStyle(
                            color: bike.isAvailable ? Colors.green.shade800 : Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(Icons.battery_charging_full, '${bike.rangeKm} km'),
                      const SizedBox(width: 16),
                      _buildInfoChip(Icons.speed, '${bike.maxSpeedKm} km/h'),
                      const Spacer(),
                      Text(
                        '\$${bike.pricePerDay}/day',
                        style: const TextStyle(
                          color: Color(0xFF0066CC),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }
}
