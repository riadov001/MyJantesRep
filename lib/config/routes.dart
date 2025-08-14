import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/services_screen.dart';
import '../screens/service_detail_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/quote_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/reservations_screen.dart';
import '../screens/profile/quotes_screen.dart';
import '../screens/legal/terms_screen.dart';
import '../screens/legal/privacy_screen.dart';
import '../models/service.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.isLoggedIn;
      
      // Redirect logic for protected routes
      if (state.matchedLocation.startsWith('/profile') || 
          state.matchedLocation.startsWith('/booking') ||
          state.matchedLocation.startsWith('/quotes')) {
        if (!isLoggedIn) return '/login';
      }
      
      if (state.matchedLocation == '/login' || state.matchedLocation == '/register') {
        if (isLoggedIn) return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: '/service/:id',
        builder: (context, state) {
          final serviceId = state.pathParameters['id']!;
          return ServiceDetailScreen(serviceId: serviceId);
        },
      ),
      GoRoute(
        path: '/booking/:serviceId',
        builder: (context, state) {
          final serviceId = state.pathParameters['serviceId']!;
          return BookingScreen(serviceId: serviceId);
        },
      ),
      GoRoute(
        path: '/quote',
        builder: (context, state) => const QuoteScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/reservations',
        builder: (context, state) => const ReservationsScreen(),
      ),
      GoRoute(
        path: '/quotes-history',
        builder: (context, state) => const QuotesScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
    ],
  );
}
