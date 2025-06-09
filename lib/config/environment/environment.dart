import 'package:get_storage/get_storage.dart';

class Environment {
  static final storage = GetStorage();
  static const baseUrlPUKP =
      'https://stip.trsea.artimu.co.id/trb-api/api/pukp/getData';
  static const baseUrlUPT =
      'https://stip.trsea.artimu.co.id/trb-api/api/upt/getData';
  static String get baseUrl => storage.read('base_url') ?? '';
  static String get apiUrl => '$baseUrl/trb-api/api';

  static String get refreshUrl => '$apiUrl/auth/refresh';
  static String get baseline => '$apiUrl/sync/baseline';
  static String get checkSeafarer => '$apiUrl/auth/CheckSeafarer';
  static String get claim => '$apiUrl/auth/ClaimSeaferer2';
  static String get chatNewMsg => '$apiUrl/chat/newmessage';
  static String get chatUpdate => '$apiUrl/chat/updatestatus';
  static String get chatSend => '$apiUrl/chat/send';
  static String get chatSaveToken => '$apiUrl/chat/savetoken';
  static String get getRoomChat => '$apiUrl/chat/getroom';
  static String get joinLecturerGroup => '$apiUrl/chat/joinLecturerGroup';
  static String get getLecturerGroup => '$apiUrl/chat/getlecturergroup';
  static String get leaveGroup => '$apiUrl/chat/leavegroup';
  static String get contactSend => '$apiUrl/contact/send';
  static String get examinationCourse => '$apiUrl/examination/course';
  static String get examinationGo => '$apiUrl/examination/go';
  static String get getNew => '$apiUrl/news/getnew';
  static String get updateUser => '$apiUrl/auth/updateuser';
  static String get login => '$apiUrl/auth/login';
  static String get authCheck => '$apiUrl/auth/check';
  static String get getUserData => '$apiUrl/auth/userdata';
  static String get journalServer => '$apiUrl/journal/server';
  static String get tabelEndpoint => '$apiUrl/tableendpoint/data';
  static String get syncSign => '$apiUrl/sync/sign';
  static String get syncSignAtt => '$apiUrl/sync/signatt';
  static String get syncReportRoute => '$apiUrl/sync/reportroute';
  static String get syncReportLog => '$apiUrl/sync/reportlog';
  static String get syncReportLogAtt => '$apiUrl/sync/reportlogatt';
  static String get syncTaskCheck => '$apiUrl/sync/techtaskcheck';
  static String get syncTaskCheckDelete => '$apiUrl/sync/techtaskcheckdelete';
  static String get syncTaskNewsStatus => '$apiUrl/sync/technewsstatus';
  static String get syncLogbook => '$apiUrl/sync/logbook';
  static String get dataKapal => '$apiUrl/vessel/GetDetail';

  // OneSignal
  static const oneSignalApiUrl = 'https://onesignal.com/api/v1/notifications';
  static const oneSignalAppId = 'f8f6161c-7908-4cd2-9f3e-1ebc2a8ad21b';
  static const oneSignalRestApiKey =
      'YzVjYTc5YmYtYjBhMi00NTJmLTk3ZjctYmFmODkxNDBjNzg1';

  // API fields
  static const key = 'key';
  static const q = 'q';
  static const days = 'days';
  static const lang = 'lang';

  // Assets
  static const logo = 'assets/images/app_icon.png';
  static const welcome = 'assets/images/welcome.png';
  static const world = 'assets/images/world.png';
  static const world2 = 'assets/images/world2.png';
  static const noData = 'assets/images/no_data.png';
  static const search = 'assets/vectors/search.svg';
  static const language = 'assets/vectors/language.svg';
  static const category = 'assets/vectors/category.svg';
  static const downArrow = 'assets/vectors/down_arrow.svg';
  static const wind = 'assets/vectors/wind.svg';
  static const pressure = 'assets/vectors/pressure.svg';
  static const kemenhub = 'assets/images/logokemenhub.png';
  static const trsea = 'assets/images/logo2.png';
  static const stip = 'assets/images/LogoSTIP1.png';
  static const weatherAnimation = 'assets/data/weather_animation.json';
}
