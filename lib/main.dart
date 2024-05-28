import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thimar_app/core/logic/cache_helper.dart';
import 'package:thimar_app/core/logic/firebase_notifications.dart';
import 'package:thimar_app/core/logic/helper_methods.dart';
import 'package:thimar_app/generated/codegen_loader.g.dart';
import 'package:thimar_app/views/auth/splash.dart';
import 'core/logic/kiwi.dart';
import 'core/logic/main_data.dart';

GetIt getIt = GetIt.instance;

late SharedPreferences Prefs;
void initServiceLocator() {
  getIt.registerLazySingleton<AppGlobals>(() => AppGlobals());
   }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initKiwi();
  initServiceLocator();
  await EasyLocalization.ensureInitialized();
  Prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await GlobalNotification().setUpFirebase();
  CacheHelper.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: getMaterialColor(),
    ),
  );
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale("ar",),
        saveLocale: true,
        assetLoader: const CodegenLoader(),
        child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(
              0xffFFFFFF,
            ),
            centerTitle: true,
            elevation: 0.0,
            titleTextStyle: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: getMaterialColor(),
            ),
          ),
          primarySwatch: getMaterialColor(),
          platform: TargetPlatform.iOS,
          fontFamily: "Tajawal",
          scaffoldBackgroundColor: Colors.white,
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(
                  15.r,
                ),
              ),
              side: const BorderSide(
                color: Color(0xFF4C8613),
              ),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(
                  15.r,
                ),
              ),
              side: const BorderSide(
                color: Color(0xFFFFE1E1),
              ),
              backgroundColor: const Color(0xFFFFE1E1),
            ),
          ),
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const SplashScreen(),
      ),
    );
  }
}
