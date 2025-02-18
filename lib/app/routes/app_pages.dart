import 'package:mytrb/app/modules/auth/views/registration_proceed_view.dart';
import 'package:mytrb/app/modules/auth/views/registration_view.dart';
import 'package:mytrb/app/modules/billing/bindings/billing_binding.dart';
import 'package:mytrb/app/modules/billing/views/billing_detail_view.dart';
import 'package:mytrb/app/modules/billing/views/billing_view.dart';
import 'package:mytrb/app/modules/billing/views/card_web_view.dart';
import 'package:mytrb/app/modules/billing/views/invoice_web_view.dart';
import 'package:mytrb/app/modules/biodata/bindings/biodata_binding.dart';
import 'package:mytrb/app/modules/biodata/views/biodata_view.dart';
import 'package:mytrb/app/modules/biodata/views/parent_view.dart';
import 'package:mytrb/app/modules/certificate_delivery/bindings/certificate_delivery_binding.dart';
import 'package:mytrb/app/modules/certificate_delivery/views/certificate_delivery_view.dart';
import 'package:mytrb/app/modules/certificate_delivery/views/certificate_detail_view.dart';
import 'package:mytrb/app/modules/history/bindings/history_binding.dart';
import 'package:mytrb/app/modules/history/views/history_views.dart';
import 'package:mytrb/app/modules/news/bindings/news_binding.dart';
import 'package:mytrb/app/modules/news/views/news_detail_view.dart';
import 'package:mytrb/app/modules/news/views/news_view.dart';
import 'package:mytrb/app/modules/news_certificate/bindings/news_certificate_binding.dart';
import 'package:mytrb/app/modules/news_certificate/views/news_certificate_detail_view.dart';
import 'package:mytrb/app/modules/news_certificate/views/news_certificate_view.dart';
import 'package:mytrb/app/modules/profile/views/change_password_view.dart';
import 'package:mytrb/app/modules/profile/views/change_picture_profile_view.dart';
import 'package:mytrb/app/modules/questionnaire/bindings/questionnaire_binding.dart';
import 'package:mytrb/app/modules/questionnaire/views/questionnaire_view.dart';
import 'package:mytrb/app/modules/report_evaluation/bindings/report_evaluation_binding.dart';
import 'package:mytrb/app/modules/report_evaluation/views/report_evaluation_detail_view.dart';
import 'package:mytrb/app/modules/report_evaluation/views/report_evaluation_view.dart';
import 'package:mytrb/app/modules/schedule_change/bindings/schedule_change_binding.dart';
import 'package:mytrb/app/modules/schedule_change/views/schedule_change_view.dart';
import 'package:mytrb/app/modules/seat_information/bindings/seat_information_binding.dart';
import 'package:mytrb/app/modules/seat_information/views/seat_information_view.dart';
import 'package:mytrb/app/modules/splash/views/maintenance_view.dart';
import 'package:mytrb/app/modules/training/bindings/training_binding.dart';
import 'package:mytrb/app/modules/training/views/registration_failed.dart';
import 'package:mytrb/app/modules/training/views/registration_success.dart';
import 'package:mytrb/app/modules/training/views/training_proceed_view.dart';
import 'package:mytrb/app/modules/training/views/training_view.dart';
import 'package:mytrb/app/modules/index/bindings/index_binding.dart';
import 'package:mytrb/app/modules/index/views/index_view.dart';
import 'package:mytrb/app/modules/upload_requirements/bindings/upload_requirements_bindings.dart';
import 'package:mytrb/app/modules/upload_requirements/views/requirement_detail_live_view.dart';
import 'package:mytrb/app/modules/upload_requirements/views/requirement_detail_view.dart';
import 'package:mytrb/app/modules/upload_requirements/views/upload_requirements_view.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/auth/bindings/auth_binding.dart';
import 'package:mytrb/app/modules/auth/views/login_view.dart';
import 'package:mytrb/app/modules/profile/bindings/profile_binding.dart';
// import 'package:mytrb/app/modules/profile/views/profile_views.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MAINTENANCE,
      page: () => const MaintenanceView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION_PROCEED,
      page: () => RegistrationProceedView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => RegistrationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.INDEX,
      page: () => IndexView(),
      binding: IndexBinding(),
    ),
    GetPage(
      name: _Paths.DIKLAT,
      page: () => const TrainingView(),
      binding: TrainingBinding(),
    ),
    GetPage(
      name: _Paths.DIKLAT_PROCEED,
      page: () => TrainingProceedView(),
      binding: TrainingBinding(),
    ),
    GetPage(
      name: _Paths.DIKLAT_REGISTRATION_SUCCESS,
      page: () => RegistrationSuccessView(),
      binding: TrainingBinding(),
    ),
    GetPage(
      name: _Paths.DIKLAT_REGISTRATION_FAILED,
      page: () => const RegistrationFailedView(),
      binding: TrainingBinding(),
    ),
    GetPage(
      name: _Paths.QUESTIONNAIRE,
      page: () => const QuestionnaireView(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_EVALUATION,
      page: () => ReportEvaluationView(),
      binding: ReportEvaluationBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_EVALUATION_DETAIL,
      page: () => const ReportEvaluationDetailView(),
      binding: ReportEvaluationBinding(),
    ),
    GetPage(
      name: _Paths.UPLOAD_REQUIREMENTS,
      page: () => const UploadRequirementsView(),
      binding: UploadRequirementsBinding(),
    ),
    GetPage(
      name: _Paths.REQUIREMENTS_DETAIL,
      page: () => const RequirementDetailsView(),
      binding: UploadRequirementsBinding(),
    ),
    GetPage(
      name: _Paths.REQUIREMENTS_DETAIL_LIVE,
      page: () => const RequirementDetailsLiveView(),
      binding: UploadRequirementsBinding(),
    ),
    GetPage(
      name: _Paths.BILLING,
      page: () => const BillingView(),
      binding: BillingBinding(),
    ),
    GetPage(
      name: _Paths.BILLING_DETAIL,
      page: () => const BillingDetailView(),
      binding: BillingBinding(),
    ),
    GetPage(
      name: _Paths.BILLING_WEB_VIEW,
      page: () => const InvoiceWebView(),
      binding: BillingBinding(),
    ),
    GetPage(
      name: _Paths.BILLING_CARD_WEB_VIEW,
      page: () => const CardWebView(),
      binding: BillingBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULE_CHANGE,
      page: () => const ScheduleChangeView(),
      binding: ScheduleChangeBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () => ProfileView(),
    //   binding: ProfileBinding(),
    // ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PICTURE_PROFILE,
      page: () => ChangePictureProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.BIODATA,
      page: () => const BiodataView(),
      binding: BiodataBinding(),
    ),
    GetPage(
      name: _Paths.BIODATA_PARENT,
      page: () => const BiodataParentView(),
      binding: BiodataBinding(),
    ),
    GetPage(
      name: _Paths.NEWS,
      page: () => const NewsView(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => NewsDetailView(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_CERTIFICATE,
      page: () => const NewsCertficateView(),
      binding: NewsCertificateBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_CERTIFICATE_DETAIL,
      page: () => NewsCertficateDetailView(),
      binding: NewsCertificateBinding(),
    ),
    GetPage(
      name: _Paths.SEAT_INFORMATION,
      page: () => SeatInformationView(),
      binding: SeatInformationBinding(),
    ),
    GetPage(
      name: _Paths.CERTIFICATE_DELIVERY,
      page: () => const CertificateDeliveryView(),
      binding: CertificateDeliveryBinding(),
    ),
    GetPage(
      name: _Paths.CERTIFICATE_DETAIL,
      page: () => const CertificateDetailView(),
      binding: CertificateDeliveryBinding(),
    ),
  ];
}
