import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:velouscambo/app.dart';
import 'package:velouscambo/firebase_options.dart';
import 'package:velouscambo/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:velouscambo/features/history/viewmodel/history_viewmodel.dart';
import 'package:velouscambo/features/map/viewmodel/station_viewmodel.dart';
import 'package:velouscambo/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:velouscambo/features/ride/viewmodel/ride_viewmodel.dart';
import 'package:velouscambo/features/search/viewmodel/search_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase does not support Linux desktop.
  // Run on Android: flutter run -d android --dart-define-from-file=.env
  // or Web:         flutter run -d chrome  --dart-define-from-file=.env
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
    runApp(const _UnsupportedPlatformApp());
    return;
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    runApp(_InitErrorApp(error: e.toString()));
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => StationViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
        ChangeNotifierProvider(create: (_) => RideViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: const VelousCamboApp(),
    ),
  );
}

class _InitErrorApp extends StatelessWidget {
  final String error;
  const _InitErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firebase initialization failed',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Run with your .env defines and a supported target:',
                      style: TextStyle(color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 12),
                    const SelectableText(
                      'flutter run -d android --dart-define-from-file=.env\n'
                      'flutter run -d chrome  --dart-define-from-file=.env\n'
                      'flutter run -d web-server --dart-define-from-file=.env',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF1E293B),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SelectableText(
                      error,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when the app is launched on a platform Firebase does not support
/// (currently Linux desktop). Run on Android or Web instead.
class _UnsupportedPlatformApp extends StatelessWidget {
  const _UnsupportedPlatformApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.pedal_bike_rounded,
                      color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                const Text(
                  'VelousCambo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Linux desktop is not supported by Firebase.\nPlease run on Android or Web:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const SelectableText(
                    'flutter run -d android --dart-define-from-file=.env\n'
                    'flutter run -d chrome  --dart-define-from-file=.env',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: Color(0xFF1E293B),
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
