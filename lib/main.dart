import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'localization_service.dart';
import 'screens/loading_screen.dart';
import 'data_manager.dart'; // HATA BURADAYDI: Bu import eksikti

void main() async {
  // Flutter motorunu hazır hale getirir
  WidgetsFlutterBinding.ensureInitialized();

  // Önce yerel hafızayı (Para, Seviye vb.) başlatıyoruz
  await DataManager.init();

  // Sonra dil servislerini yüklüyoruz
  await LocalizationService.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Tasarımın baz alındığı boyutlar
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nebula Quest',
          theme: ThemeData(
            brightness: Brightness.dark, // Oyunlar için genelde karanlık tema tercih edilir
            primarySwatch: Colors.orange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // Uygulama ilk açıldığında child (yani LoadingScreen) ile başlar
          home: child,
        );
      },
      // Uygulama ilk açıldığında gösterilecek olan ekran
      child: const LoadingScreen(),
    );
  }
}