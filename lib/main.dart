import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:mytrb/app/Repository/news_repository.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';
import 'package:mytrb/config/theme/theme_data.dart';
import 'package:mytrb/main_binding.dart';
import 'package:mytrb/utils/colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';
import 'config/translations/localization_service.dart';

void main() async {
  // Tunggu hingga binding selesai
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('4284524e-f812-4080-9898-e321ab1b31d4');
  OneSignal.Notifications.requestPermission(true);

  await Geolocator.requestPermission();

  // Inisialisasi shared preference
  await MySharedPref.init();

  // Inisialisasi format tanggal untuk bahasa lokal saat ini
  await initializeDateFormatting(
      LocalizationService.getCurrentLocal().languageCode);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OneSignal.Notifications.addClickListener((event) async {
      EasyLoading.show(status: 'Loading...');

      try {
        final data = event.notification.additionalData;
        if (Get.isRegistered<NewsController>()) {
          NewsController newsController = Get.find<NewsController>();
          await newsController.fetchNewsData();
        }
        if (Get.isRegistered<IndexController>()) {
          IndexController indexController = Get.find<IndexController>();
          await indexController.initializeHome();
        }
        if (data == null) {
          log("OneSignal: No additional data found");
          EasyLoading.dismiss();
          return;
        }

        String? type = data['type'];
        String? uc = data['uc'];

        if (type != null) {
          switch (type) {
            case 'news':
              if (uc != null && Get.isRegistered<NewsController>()) {
                NewsController newsController = Get.find<NewsController>();

                var selectedNews = newsController.newsList.firstWhereOrNull(
                  (news) => news['uc'] == uc,
                );

                if (selectedNews != null) {
                  EasyLoading.dismiss();
                  var status =
                      await Get.toNamed(Routes.NEWS_DETAIL, arguments: {
                    "uc": selectedNews['uc'],
                    "title": selectedNews['title'],
                    "created_at": selectedNews['created_at_formated'],
                    "description": selectedNews['descriptionfull'],
                  })?.then((value) async {
                    if (Get.isRegistered<IndexController>()) {
                      IndexController indexController =
                          Get.find<IndexController>();
                      await indexController.initializeHome();
                    }
                    return value;
                  });

                  if (status is int && status == 1) {
                    newsController.markAsRead(uc);
                  }
                } else {
                  EasyLoading.dismiss();
                  Get.toNamed(Routes.NEWS);
                }
              } else {
                EasyLoading.dismiss();
                Get.toNamed(Routes.NEWS);
              }
              break;

            default:
              if (Get.isRegistered<AuthController>()) {
                AuthController authController = Get.find<AuthController>();
                var authResult = await authController.checkAuth();

                EasyLoading.dismiss();
                if (authResult) {
                  Get.toNamed(Routes.LOGIN);
                } else {
                  Get.toNamed(Routes.INDEX);
                }
              } else {
                log("OneSignal: AuthController not registered");
              }
              break;
          }
        } else {
          log("OneSignal: Type not found in notification");
        }
      } catch (e) {
        log("OneSignal Error: $e");
      }

      EasyLoading.dismiss();
    });

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return ResponsiveWrapper.builder(
          GetMaterialApp(
            title: 'TRSea',
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.fade,
            smartManagement: SmartManagement.keepFactory,
            theme: ThemeConfig.lightTheme,
            initialBinding: MainBinding(),
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            locale: MySharedPref.getCurrentLocal(),
            translations: LocalizationService.getInstance(),
            builder: EasyLoading.init(),
          ),
          breakpoints: [
            const ResponsiveBreakpoint.resize(350, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(600, name: TABLET),
            const ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
          ],
        );
      },
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..radius = 10.0
    ..backgroundColor = ColorEnvironment.colorBackground
    ..indicatorColor = Colors.black
    ..textColor = Colors.black
    // ..indicatorColor = hexToColor('#64DEE0')
    // ..textColor = hexToColor('#64DEE0')
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}
