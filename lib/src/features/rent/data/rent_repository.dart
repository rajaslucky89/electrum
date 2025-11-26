import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electrum/src/features/rent/domain/rent_interest_model.dart';

import 'package:electrum/src/features/auth/data/auth_repository.dart';

final rentRepositoryProvider = Provider<RentRepository>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return RentRepository(sharedPreferences);
});

// Wait, I should write the class first.
class RentRepository {
  final SharedPreferences _sharedPreferences;

  RentRepository(this._sharedPreferences);

  static const _keyRentInterest = 'rent_interest';

  Future<void> saveRentInterest(RentInterest interest) async {
    final jsonString = jsonEncode(interest.toJson());
    await _sharedPreferences.setString(_keyRentInterest, jsonString);
  }

  RentInterest? getRentInterest() {
    final jsonString = _sharedPreferences.getString(_keyRentInterest);
    if (jsonString == null) return null;
    return RentInterest.fromJson(jsonDecode(jsonString));
  }
}
