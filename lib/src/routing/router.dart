import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:electrum/src/features/auth/data/auth_repository.dart';
import 'package:electrum/src/features/auth/presentation/login_screen.dart';
import 'package:electrum/src/features/auth/presentation/register_screen.dart';
import 'package:electrum/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:electrum/src/features/home/presentation/home_screen.dart';
import 'package:electrum/src/features/bikes/presentation/bike_details_screen.dart';
import 'package:electrum/src/features/rent/presentation/rent_interest_form_screen.dart';

// Placeholder screens
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

enum AppRoute {
  onboarding,
  login,
  register,
  home,
  bikeDetails,
  rentInterest,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoggingIn = state.uri.path == '/login';
      final isRegistering = state.uri.path == '/register';
      final isOnboarding = state.uri.path == '/onboarding';

      if (isLoggedIn) {
        if (isLoggingIn || isRegistering || isOnboarding) {
          return '/';
        }
      } else {
        if (!isLoggingIn && !isRegistering && !isOnboarding) {
          return '/onboarding';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'bike/:id',
            name: AppRoute.bikeDetails.name,
            builder: (context, state) => BikeDetailsScreen(bikeId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'rent-interest',
            name: AppRoute.rentInterest.name,
            builder: (context, state) => const RentInterestFormScreen(),
          ),
        ],
      ),
    ],
  );
});
