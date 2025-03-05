part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const MAINTENANCE = _Paths.MAINTENANCE;
  static const LOGIN = _Paths.LOGIN;
  static const INDEX = _Paths.INDEX;
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
  static const NEWS = _Paths.NEWS;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
  static const EXAM = _Paths.EXAM;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const MAINTENANCE = '/maintenance';
  static const LOGIN = '/login';
  static const INDEX = '/index';
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
  static const NEWS = '/news';
  static const NEWS_DETAIL = '/news-detail';
  static const EXAM = '/exam';
}
