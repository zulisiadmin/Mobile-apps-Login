import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String isFirstLaunchKey = 'is_first_launch';
const String isLoggedInKey = 'is_logged_in';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAppStatus();
  }

  Future<void> _checkAppStatus() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(isFirstLaunchKey) ?? true;
    final isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;

    if (!mounted) return;

    if (isFirstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Splash Screen',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mobile_friendly, size: 88, color: Colors.indigo),
          SizedBox(height: 24),
          Text(
            'Mohon tunggu sebentar...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finishOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstLaunchKey, false);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Selamat Datang',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.explore, size: 88, color: Colors.indigo),
          const SizedBox(height: 24),
          const Text(
            'Mulai pengalaman baru',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Aplikasi ini membantu Anda mengakses layanan dengan lebih mudah.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => _finishOnboarding(context),
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, true);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Masuk',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_open, size: 88, color: Colors.indigo),
          const SizedBox(height: 24),
          const Text(
            'Masuk ke akun Anda',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gunakan akun Anda untuk melanjutkan ke halaman utama.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => _login(context),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, false);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _resetApp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstLaunchKey, true);
    await prefs.setBool(isLoggedInKey, false);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Beranda',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.home, size: 88, color: Colors.indigo),
          const SizedBox(height: 24),
          const Text(
            'Selamat datang di Beranda',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Anda sudah berhasil masuk dan dapat menggunakan aplikasi.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          FilledButton.tonal(
            onPressed: () => _logout(context),
            child: const Text('Logout'),
          ),
          TextButton(
            onPressed: () => _resetApp(context),
            child: const Text('Mulai ulang aplikasi'),
          ),
        ],
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: child),
        ),
      ),
    );
  }
}
