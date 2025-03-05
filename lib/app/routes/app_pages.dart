import 'package:mytrb/app/modules/auth/bindings/auth_binding.dart';
import 'package:mytrb/app/modules/auth/views/login_view.dart';
import 'package:mytrb/app/modules/claim/bindings/claim_binding.dart';
import 'package:mytrb/app/modules/claim/views/claim_view.dart';
import 'package:mytrb/app/modules/index/bindings/index_binding.dart';
import 'package:mytrb/app/modules/index/views/index_view.dart';
import 'package:mytrb/app/modules/report/bindings/report_binding.dart';
import 'package:mytrb/app/modules/report/views/report_add_view.dart';
import 'package:mytrb/app/modules/report/views/report_view.dart';
import 'package:mytrb/app/modules/report_route/bindings/report_route_binding.dart';
import 'package:mytrb/app/modules/report_route/views/report_route_view.dart';
import 'package:mytrb/app/modules/report_task/bindings/report_task_binding.dart';
import 'package:mytrb/app/modules/report_task/views/report_task_view.dart';
import 'package:mytrb/app/modules/report_task_add/bindings/report_task_add_binding.dart';
import 'package:mytrb/app/modules/report_task_add/views/report_task_add_view.dart';
import 'package:mytrb/app/modules/report_task_add/views/report_task_result_view.dart';
import 'package:mytrb/app/modules/report_task_approval/bindings/report_task_approval_binding.dart';
import 'package:mytrb/app/modules/report_task_approval/views/report_task_approval_view.dart';
import 'package:mytrb/app/modules/report_task_form/bindings/report_task_form_binding.dart';
import 'package:mytrb/app/modules/report_task_form/views/report_task_form_view..dart';
import 'package:mytrb/app/modules/sign_off/bindings/sign_off_binding.dart';
import 'package:mytrb/app/modules/sign_off/views/sign_off_view.dart';
import 'package:mytrb/app/modules/sign_on/bindings/sign_on_binding.dart';
import 'package:mytrb/app/modules/sign_on/views/sign_on_view.dart';
// import 'package:mytrb/app/modules/exam/bindings/exam_binding.dart';
// import 'package:mytrb/app/modules/exam/views/exam_view.dart';

import 'package:mytrb/app/modules/splash/views/maintenance_view.dart';
import 'package:get/get.dart';
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
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.INDEX,
      page: () => IndexView(),
      binding: IndexBinding(),
    ),
    GetPage(
      name: _Paths.CLAIM,
      page: () => ClaimView(),
      binding: ClaimBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_ON,
      page: () => SignOnView(),
      binding: SignBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_OFF,
      page: () => const SignoffView(),
      binding: SignoffBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_ADD,
      page: () => const ReportAddView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_ROUTE,
      page: () => const ReportRouteView(),
      binding: ReportRouteBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_TASK,
      page: () => const ReportTaskView(),
      binding: ReportTaskBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_TASK_ADD,
      page: () => const ReportTaskAddView(),
      binding: ReportTaskAddBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_TASK_ADD_FORM,
      page: () => const ReportTaskAddFormView(),
      binding: ReportTaskAddFormBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_TASK_RESULT,
      page: () => const ReportTaskResultView(),
      binding: ReportTaskAddBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_TASK_APPROVAL,
      page: () => ReportTaskApprovalView(),
      binding: ReportTaskApprovalBinding(),
    ),
    // GetPage(
    //   name: _Paths.EXAM,
    //   page: () => const ExamView(),
    //   binding: ExamBinding(),
    // ),
  ];
}
