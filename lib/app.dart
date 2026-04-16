import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/booking/active_rental_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/search/search_screen.dart';

class VelousCamboApp extends StatelessWidget {
  const VelousCamboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VelousCambo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const MainScreen(),
        '/search': (_) => const SearchScreen(),
        '/booking': (_) => const BookingScreen(),
        '/active-rental': (_) => const ActiveRentalScreen(),
        '/edit-profile': (_) => const EditProfileScreen(),
      },
    );
  }
}
