import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../localization_service.dart';
import 'home_menu.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor'ı sildik çünkü Container içinde decoration var.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // HATA BURADAYDI: radialGradient değil, sadece "gradient" yazmalısın.
          gradient: RadialGradient(
            colors: [Color(0xFF222222), Color(0xFF000000)],
            radius: 1.0,
            center: Alignment.center,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch_rounded,
              size: 80.w,
              color: Colors.orangeAccent,
            ),
            SizedBox(height: 24.h),
            Text(
              "Runner",
              style: TextStyle(
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 60.h),
            Text(
              LocalizationService.get('loading'),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: 220.w,
              height: 4.h,
              child: const LinearProgressIndicator(
                color: Colors.orangeAccent,
                backgroundColor: Colors.white10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}