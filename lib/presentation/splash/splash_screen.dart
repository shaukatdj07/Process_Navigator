import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/process_provider.dart';
import '../../providers/profile_provider.dart';
import '../home/home_screen.dart';

/// First screen shown on launch. Loads bundled content and the saved
/// profile while showing the brand mark, then routes to Home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final process = context.read<ProcessProvider>();
    final profile = context.read<ProfileProvider>();

    final loadFuture = Future.wait([
      process.loadHome(),
      profile.load(),
    ]);

    // Keep the brand moment visible for a minimum, comfortable duration.
    final minDelay = Future.delayed(const Duration(milliseconds: 1100));

    await Future.wait([loadFuture, minDelay]);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: AppColors.surface,
                  size: 44,
                ),
              ),
              const SizedBox(height: 20),
              const Text(AppConstants.appName, style: AppTextStyles.displayLarge),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  AppConstants.tagline,
                  style: AppTextStyles.bodyMuted,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
