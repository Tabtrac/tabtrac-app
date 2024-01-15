import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workmanager/workmanager.dart';
import 'constants/app_routes.dart';
import 'constants/theme.dart';
import 'helpers/notification_helpers.dart';
import 'l10n/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'helpers/app_router.dart';
import 'providers/providers.dart';

// TODO: need to work on the background notifications
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // switch (task) {
    //   case "fetchBackground":
    //     print(inputData!['name']);
    //     break;
    //   case "testTask":
    //     LocalNotifications.showNotification(
    //         title: 'Welcome notification',
    //         body: 'Welcome to tabtrac our extemed guest',
    //         payload: 'payload');
    //     break;
    // }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  // Workmanager().cancelAll();
  // Workmanager().registerOneOffTask(
  //   "2",
  //   "testTask",
  //   initialDelay: const Duration(seconds: 10),
  // );

  // await Workmanager().registerPeriodicTask(
  //   "1",
  //   "fetchBackground",
  //   inputData: {
  //     'name': "kelly",
  //   },
  //   frequency: const Duration(minutes: 15),
  //   constraints: Constraints(
  //     networkType: NetworkType.connected,
  //   ),
  // );
  await LocalNotifications.init();
  await Hive.initFlutter();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final languageProvider = ref.watch(languageNotifierProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Tabtrac',
          theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          supportedLocales: L10n.all,
          locale: languageProvider,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splashRoute,
          routes: AppRouter.routes,
        );
      },
    );
  }
}
