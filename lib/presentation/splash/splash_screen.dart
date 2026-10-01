import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/process_provider.dart';
import '../../providers/profile_provider.dart';
import '../home/home_screen.dart';

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
  WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
}

  Future<void> _bootstrap() async {
    final process = context.read<ProcessProvider>();
    final profile = context.read<ProfileProvider>();

    final loadFuture = Future.wait([
      process.loadHome(),
      profile.load(),
    ]);

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
    final t = AppStrings.of(context);
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
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppColors.highlight, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Color(0x400B6E4F), blurRadius: 24, offset: Offset(0, 10)),
                  ],
                ),
                child: const Icon(Icons.explore_rounded, color: Colors.white, size: 44),
              ),
              const SizedBox(height: 20),
              Text(t('app_name'), style: AppTextStyles.displayLarge),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  t('app_tagline'),
                  style: AppTextStyles.bodyMuted,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
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
