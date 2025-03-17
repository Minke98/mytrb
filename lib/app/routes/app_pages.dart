import 'package:mytrb/app/modules/auth/bindings/auth_binding.dart';
import 'package:mytrb/app/modules/auth/views/login_view.dart';
import 'package:mytrb/app/modules/chat/bindings/chat_binding.dart';
import 'package:mytrb/app/modules/chat/views/chat_view.dart';
import 'package:mytrb/app/modules/chat_message/bindings/chat_message_binding.dart';
import 'package:mytrb/app/modules/chat_message/views/chat_message_view.dart';
import 'package:mytrb/app/modules/claim/bindings/claim_binding.dart';
import 'package:mytrb/app/modules/claim/views/claim_view.dart';
import 'package:mytrb/app/modules/contact/bindings/contact_binding.dart';
import 'package:mytrb/app/modules/contact/views/contact_view.dart';
import 'package:mytrb/app/modules/exam/bindings/exam_binding.dart';
import 'package:mytrb/app/modules/exam/views/exam_view.dart';
import 'package:mytrb/app/modules/exam/views/exam_web_view.dart';
import 'package:mytrb/app/modules/faq/bindings/faq_binding.dart';
import 'package:mytrb/app/modules/faq/views/faq_view.dart';
import 'package:mytrb/app/modules/index/bindings/index_binding.dart';
// import 'package:mytrb/app/modules/index/views/chat_web.dart';
import 'package:mytrb/app/modules/index/views/index_view.dart';
import 'package:mytrb/app/modules/logbook/bindings/logbook_binding.dart';
import 'package:mytrb/app/modules/logbook/views/logbook_view.dart';
import 'package:mytrb/app/modules/logbook_add/bindings/logbook_add_binding.dart';
import 'package:mytrb/app/modules/logbook_add/views/logbook_add_view.dart';
import 'package:mytrb/app/modules/logbook_approval/bindings/logbook_approval_binding.dart';
import 'package:mytrb/app/modules/logbook_approval/views/logbook_approval_view.dart';
import 'package:mytrb/app/modules/news/bindings/news_binding.dart';
import 'package:mytrb/app/modules/news/views/news_detail_view.dart';
import 'package:mytrb/app/modules/news/views/news_view.dart';
import 'package:mytrb/app/modules/profile/bindings/profile_binding.dart';
import 'package:mytrb/app/modules/profile/views/profile_view.dart';
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
import 'package:mytrb/app/modules/task/bindings/task_binding.dart';
import 'package:mytrb/app/modules/task/views/task_view.dart';
import 'package:mytrb/app/modules/task_approval/bindings/task_approval_binding.dart';
import 'package:mytrb/app/modules/task_approval/views/task_approval_view.dart';
import 'package:mytrb/app/modules/task_checklist/bindings/task_checklist_binding.dart';
import 'package:mytrb/app/modules/task_checklist/views/task_checklist_view.dart';
import 'package:mytrb/app/modules/task_sub/bindings/task_sub_binding.dart';
import 'package:mytrb/app/modules/task_sub/views/task_sub_view.dart';
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
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
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
      page: () => const ReportTaskApprovalView(),
      binding: ReportTaskApprovalBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_MESSAGE,
      page: () => const ChatMessageView(),
      binding: ChatMessageBinding(),
    ),
    GetPage(
      name: _Paths.TASK,
      page: () => const TaskView(),
      binding: TaskBinding(),
    ),
    GetPage(
      name: _Paths.TASK_SUB,
      page: () => const TaskSubView(),
      binding: TaskSubBinding(),
    ),
    GetPage(
      name: _Paths.TASK_CHECK,
      page: () => const TaskChecklistView(),
      binding: TaskChecklistBinding(),
    ),
    GetPage(
      name: _Paths.TASK_APPROVAL,
      page: () => TaskApprovalView(),
      binding: TaskApprovalBinding(),
    ),
    GetPage(
      name: _Paths.LOGBOOK,
      page: () => const LogbookView(),
      binding: LogbookBinding(),
    ),
    GetPage(
      name: _Paths.LOGBOOK_ADD,
      page: () => LogBookAddView(),
      binding: LogbookAddBinding(),
    ),
    GetPage(
      name: _Paths.LOGBOOK_APPROVAL,
      page: () => LogbookApprovalView(),
      binding: LogbookApprovalBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT,
      page: () => ContactView(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: _Paths.EXAM,
      page: () => const ExamView(),
      binding: ExamBinding(),
    ),
    GetPage(
      name: _Paths.EXAM_WEB,
      page: () => const ExamWebView(),
      binding: ExamBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.NEWS,
      page: () => const NewsView(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => const NewsDetailView(),
      binding: NewsBinding(),
    ),
  ];
}
