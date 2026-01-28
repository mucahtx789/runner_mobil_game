import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data_manager.dart';
import '../localization_service.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  int currentLane = 1;
  bool isJumping = false;
  bool isInvincible = false;
  bool isGameOver = false;

  double score = 0;
  int goldCount = 0;
  double roadOffset = 0;

  List<Map<String, dynamic>> obstacles = [];
  List<Map<String, dynamic>> golds = [];
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      obstacles.clear();
      golds.clear();
      score = 0;
      goldCount = 0;
      isGameOver = false;
      currentLane = 1;
      roadOffset = 0;
      isJumping = false;
      isInvincible = false;
    });

    gameTimer?.cancel();
    gameTimer =
        Timer.periodic(const Duration(milliseconds: 16), (_) => _updateGame());
  }

  void _updateGame() {
    if (isGameOver) return;

    setState(() {
      score += 0.2;
      roadOffset += 0.02;
      if (roadOffset > 1) roadOffset = 0;

      for (var o in obstacles) {
        o['y'] += 0.02;
      }
      for (var g in golds) {
        g['y'] += 0.02;
      }

      obstacles.removeWhere((o) => o['y'] > 1.2);
      golds.removeWhere((g) => g['y'] > 1.2);

      if (Random().nextInt(100) < 2) {
        obstacles.add({'lane': Random().nextInt(3), 'y': -1.0});
      }

      if (Random().nextInt(100) < 3) {
        golds.add({'lane': Random().nextInt(3), 'y': -1.0});
      }

      _checkCollisions();
    });
  }

  void _checkCollisions() {
    if (isInvincible) return;

    for (var o in obstacles) {
      if (o['lane'] == currentLane &&
          o['y'] > 0.75 &&
          o['y'] < 0.85) {
        _endGame();
        return;
      }
    }

    golds.removeWhere((g) {
      if (g['lane'] == currentLane && g['y'] > 0.7 && g['y'] < 0.9) {
        goldCount++;
        return true;
      }
      return false;
    });
  }

  void _endGame() async {
    isGameOver = true;
    gameTimer?.cancel();
    await DataManager.addGold(goldCount);
    await DataManager.updateHighScore(score.toInt());
    if (mounted) setState(() {});
  }

  void _moveLeft() {
    if (currentLane > 0) setState(() => currentLane--);
  }

  void _moveRight() {
    if (currentLane < 2) setState(() => currentLane++);
  }

  void _jump() {
    if (isJumping) return;

    setState(() {
      isJumping = true;
      isInvincible = true;
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        isJumping = false;
        isInvincible = false;
      });
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (d) {
          final v = d.primaryVelocity ?? 0;
          if (v < -200) _moveLeft();
          if (v > 200) _moveRight();
        },
        onVerticalDragEnd: (d) {
          final v = d.primaryVelocity ?? 0;
          if (v < -200) _jump();
        },
        child: Stack(
          children: [
            /// DAĞ
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 0.3.sh,
              child: Image.asset(
                'assets/images/bg_mountain.jpg',
                fit: BoxFit.cover,
              ),
            ),

            /// YOL
            Positioned(
              top: 0.3.sh,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(
                        'assets/images/road_texture.jpg'),
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeatY,
                    alignment: Alignment(0, roadOffset),
                  ),
                ),
              ),
            ),

            /// ALTINLAR
            ...golds.map((g) => Align(
              alignment:
              Alignment((g['lane'] - 1).toDouble(), g['y']),
              child: Icon(Icons.star,
                  color: Colors.yellow, size: 28.sp),
            )),

            /// ENGELLER
            ...obstacles.map((o) => Align(
              alignment:
              Alignment((o['lane'] - 1).toDouble(), o['y']),
              child: Container(
                width: 50.w,
                height: 30.h,
                color: Colors.red,
              ),
            )),

            /// OYUNCU
            AnimatedAlign(
              duration: const Duration(milliseconds: 100),
              alignment:
              Alignment((currentLane - 1).toDouble(), 0.8),
              child: Container(
                width: 60.w,
                height: isJumping ? 120.h : 80.h,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.r)
                  ],
                ),
              ),
            ),

            /// ÜST UI
            Positioned(
              top: 40.h,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${LocalizationService.get('score')}: ${score.toInt()}",
                    style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        goldCount.toString(),
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.yellow),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.stars,
                          color: Colors.yellow, size: 18.sp),
                    ],
                  ),
                ],
              ),
            ),

            /// OYUN SONU EKRANI (DOKUNULMADI)
            if (isGameOver)
              Container(
                color: Colors.black.withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocalizationService.get('game_over')
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "${LocalizationService.get('score')}: ${score.toInt()}",
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars,
                              color: Colors.yellow, size: 26.sp),
                          SizedBox(width: 8.w),
                          Text(
                            goldCount.toString(),
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.refresh_rounded,
                                size: 60.sp,
                                color: Colors.greenAccent),
                            onPressed: _startGame,
                          ),
                          SizedBox(width: 40.w),
                          IconButton(
                            icon: Icon(Icons.home_rounded,
                                size: 60.sp,
                                color: Colors.white),
                            onPressed: () =>
                                Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
