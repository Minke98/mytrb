import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mytrb/config/theme/theme_data.dart';
import 'package:mytrb/utils/colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/routes/app_pages.dart';
import 'config/translations/localization_service.dart';

void main() async {
  // Tunggu hingga binding selesai
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('f8f6161c-7908-4cd2-9f3e-1ebc2a8ad21b');
  OneSignal.Notifications.requestPermission(true);

  await Geolocator.requestPermission();

  // Inisialisasi shared preference
  await MySharedPref.init();

  // Inisialisasi format tanggal untuk bahasa lokal saat ini
  await initializeDateFormatting(
      LocalizationService.getCurrentLocal().languageCode);

  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OneSignal.Notifications.addClickListener((event) async {
      EasyLoading.show(status: 'Loading...');

      // final data = event.notification.additionalData;
      // String? type = data?['type'];
      // String? uc = data?['uc'];
      // String? ucPendaftaran = data?['uc_pendaftaran'];

      // if (type != null) {
      //   switch (type) {
      //     case 'news':
      //       NewsController newsController = Get.find<NewsController>();
      //       await newsController.fetchNews();
      //       if (uc != null) {
      //         var selectedNews = newsController.newsList.firstWhereOrNull(
      //           (news) => news.uc == uc,
      //         );
      //         if (selectedNews != null) {
      //           Get.toNamed(Routes.NEWS_DETAIL, arguments: selectedNews);
      //         } else {
      //           Get.toNamed(Routes.NEWS);
      //         }
      //       } else {
      //         Get.toNamed(Routes.NEWS);
      //       }
      //       break;

      //     case 'news_certificate':
      //       NewsCertificateController newsCertificateController =
      //           Get.find<NewsCertificateController>();
      //       await newsCertificateController.fetchNewsCertificate();
      //       if (uc != null) {
      //         var selectedNewsCert = newsCertificateController
      //             .newsCertificateList
      //             .firstWhereOrNull(
      //           (cert) => cert.uc == uc,
      //         );
      //         if (selectedNewsCert != null) {
      //           Get.toNamed(Routes.NEWS_CERTIFICATE_DETAIL,
      //               arguments: selectedNewsCert);
      //         } else {
      //           Get.toNamed(Routes.NEWS_CERTIFICATE);
      //         }
      //       } else {
      //         Get.toNamed(Routes.NEWS_CERTIFICATE);
      //       }
      //       break;

      //     case 'billing':
      //       BillingController billingDetailController =
      //           Get.find<BillingController>();
      //       if (ucPendaftaran != null) {
      //         await billingDetailController.fetchBillingDetail(ucPendaftaran);
      //         Get.toNamed(Routes.BILLING_DETAIL, arguments: ucPendaftaran);
      //       } else {
      //         Get.toNamed(Routes.BILLING);
      //       }
      //       break;

      //     default:
      //       IndexController indexController = Get.find<IndexController>();
      //       await indexController.loadUserInfo();
      //       if (indexController.isLoggedIn.value) {
      //         Get.toNamed(Routes.INDEX);
      //       } else {
      //         Get.toNamed(Routes.LOGIN);
      //       }
      //       break;
      //   }
      // }

      EasyLoading.dismiss();
    });

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          title: 'mytrb',
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fade,
          smartManagement: SmartManagement.keepFactory,
          theme: ThemeConfig.lightTheme,
          initialBinding: SplashBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          locale: MySharedPref.getCurrentLocal(),
          translations: LocalizationService.getInstance(),
          builder: EasyLoading.init(),
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
