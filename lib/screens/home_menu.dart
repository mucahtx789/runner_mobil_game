import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../localization_service.dart';
import '../data_manager.dart';
import '../screens/game_play_screen.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  bool isGoogleConnected = false;

  void _updateLanguage(String langCode) async {
    await LocalizationService.changeLanguage(langCode);
    if (mounted) setState(() {});
  }

  void _toggleGooglePlay() {
    setState(() {
      isGoogleConnected = !isGoogleConnected;
    });
  }

  Future<void> _handlePlay() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GamePlayScreen()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ARKA PLAN RESMİ
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_mountain.jpg',
              fit: BoxFit.cover,
            ),
          ),

          /// KARARTMA (okunabilirlik için)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          /// İÇERİK
          SafeArea(
            child: Stack(
              children: [
                /// ÜST BAR
                Positioned(
                  top: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusChip(
                        "${DataManager.getHighScore()}",
                        Icons.emoji_events,
                        Colors.orangeAccent,
                      ),
                      _statusChip(
                        "${DataManager.getGold()}",
                        Icons.stars,
                        Colors.yellow,
                      ),
                    ],
                  ),
                ),

                /// ORTA MENÜ
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Runner",
                        style: TextStyle(
                          fontSize: 38.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 20.r,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),

                      _menuButton(
                        LocalizationService.get('play'),
                        Icons.play_arrow_rounded,
                        _handlePlay,
                      ),
                      _menuButton(
                        LocalizationService.get('settings'),
                        Icons.settings_rounded,
                            () {},
                      ),
                      _menuButton(
                        LocalizationService.get('language'),
                        Icons.language_rounded,
                        _showLanguageDialog,
                      ),

                      SizedBox(height: 30.h),
                      _googlePlayButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          width: 260.w,
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF0D47A1), // koyu mavi
                Color(0xFF42A5F5), // açık mavi
                Color(0xFF0D47A1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22.sp),
              SizedBox(width: 10.w),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _googlePlayButton() {
    return InkWell(
      onTap: _toggleGooglePlay,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isGoogleConnected ? Colors.green : Colors.white24,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGoogleConnected ? Icons.check_circle : Icons.sports_esports,
              color: isGoogleConnected ? Colors.green : Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              isGoogleConnected ? "Connected" : "Connect Play Games",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D47A1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          LocalizationService.get('language'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite, // Genişliği belirle
          child: ListView(
            shrinkWrap: true, // Listeyi içeriği kadar küçült
            children: LocalizationService.supportedLanguages
                .map(
                  (lang) => ListTile(
                leading: const Icon(Icons.language, color: Colors.white70),
                title: Text(
                  lang.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _updateLanguage(lang);
                  Navigator.pop(context);
                },
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}
