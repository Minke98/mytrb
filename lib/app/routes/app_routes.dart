part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const MAINTENANCE = _Paths.MAINTENANCE;
  static const LOGIN = _Paths.LOGIN;
  static const INDEX = _Paths.INDEX;
  static const PROFILE = _Paths.PROFILE;
  static const CLAIM = _Paths.CLAIM;
  static const SIGN_ON = _Paths.SIGN_ON;
  static const SIGN_OFF = _Paths.SIGN_OFF;
  static const REPORT = _Paths.REPORT;
  static const REPORT_ADD = _Paths.REPORT_ADD;
  static const REPORT_ROUTE = _Paths.REPORT_ROUTE;
  static const REPORT_TASK = _Paths.REPORT_TASK;
  static const REPORT_TASK_ADD = _Paths.REPORT_TASK_ADD;
  static const REPORT_TASK_ADD_FORM = _Paths.REPORT_TASK_ADD_FORM;
  static const REPORT_TASK_RESULT = _Paths.REPORT_TASK_RESULT;
  static const REPORT_TASK_APPROVAL = _Paths.REPORT_TASK_APPROVAL;
  static const CHAT = _Paths.CHAT;
  static const CHAT_WEB = _Paths.CHAT_WEB;
  static const CHAT_MESSAGE = _Paths.CHAT_MESSAGE;
  static const TASK = _Paths.TASK;
  static const TASK_SUB = _Paths.TASK_SUB;
  static const TASK_CHECK = _Paths.TASK_CHECK;
  static const TASK_APPROVAL = _Paths.TASK_APPROVAL;
  static const LOGBOOK = _Paths.LOGBOOK;
  static const LOGBOOK_ADD = _Paths.LOGBOOK_ADD;
  static const LOGBOOK_APPROVAL = _Paths.LOGBOOK_APPROVAL;
  static const CONTACT = _Paths.CONTACT;
  static const NEWS = _Paths.NEWS;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
  static const EXAM = _Paths.EXAM;
  static const EXAM_WEB = _Paths.EXAM_WEB;
  static const FAQ = _Paths.FAQ;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const MAINTENANCE = '/maintenance';
  static const LOGIN = '/login';
  static const INDEX = '/index';
  static const PROFILE = '/profile';
  static const CLAIM = '/claim';
  static const SIGN_ON = '/sign-on';
  static const SIGN_OFF = '/sign-off';
  static const REPORT = '/report';
  static const REPORT_ADD = '/report-add';
  static const REPORT_ROUTE = '/report-route';
  static const REPORT_TASK = '/report-task';
  static const REPORT_TASK_ADD = '/report-task-add';
  static const REPORT_TASK_ADD_FORM = '/report-task-add-form';
  static const REPORT_TASK_RESULT = '/report-task-result';
  static const REPORT_TASK_APPROVAL = '/report-task-approval';
  static const CHAT = '/chat';
  static const CHAT_WEB = '/chat-web';
  static const CHAT_MESSAGE = '/chat-message';
  static const TASK = '/task';
  static const TASK_SUB = '/task-sub';
  static const TASK_CHECK = '/task-check';
  static const TASK_APPROVAL = '/task-approval';
  static const LOGBOOK = '/logbook';
  static const LOGBOOK_ADD = '/logbook-add';
  static const LOGBOOK_APPROVAL = '/logbook-approval';
  static const CONTACT = '/contact';
  static const NEWS = '/news';
  static const NEWS_DETAIL = '/news-detail';
  static const EXAM = '/exam';
  static const EXAM_WEB = '/exam-web';
  static const FAQ = '/faq';
}
