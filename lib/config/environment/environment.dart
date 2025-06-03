class Environment {
  // api key
  static const apiKey = '6f926d5c19164cdfa95205814242202';

  // api urls
  // static String baseUrl = "https://pelaut.dephub.go.id/trsea/trsea-api/api/";
  // static String refreshUrl =
  //     "https://pelaut.dephub.go.id/trsea/trsea-api/api/auth/refresh";
  // static const baseUrl = 'http://192.168.1.21';
  // static const apiUrl = '$baseUrl/trsea-api/api';
  static const baseUrl = 'https://pelaut.dephub.go.id';
  static const apiUrl = '$baseUrl/trsea/trsea-api/api';
  static const refreshUrl = '$apiUrl/auth/refresh';
  static const baseline = '$apiUrl/sync/baseline';
  static const checkSeafarer = '$apiUrl/auth/CheckSeafarer';
  static const claim = '$apiUrl/auth/ClaimSeaferer2';
  static const chatNewMsg = '$apiUrl/chat/newmessage';
  static const chatUpdate = '$apiUrl/chat/updatestatus';
  static const chatSend = '$apiUrl/chat/send';
  static const chatSaveToken = '$apiUrl/chat/savetoken';
  static const getRoomChat = '$apiUrl/chat/getroom';
  static const joinLecturerGroup = '$apiUrl/chat/joinLecturerGroup';
  static const getLecturerGroup = '$apiUrl/chat/getlecturergroup';
  static const leaveGroup = '$apiUrl/chat/leavegroup';
  static const contactSend = '$apiUrl/contact/send';
  static const examinationCourse = '$apiUrl/examination/course';
  static const examinationGo = '$apiUrl/examination/go';
  static const getNew = '$apiUrl/news/getnew';
  static const updateUser = '$apiUrl/auth/updateuser';
  static const login = '$apiUrl/auth/login';
  static const authCheck = '$apiUrl/auth/check';
  static const getUserData = '$apiUrl/auth/userdata';
  static const journalServer = '$apiUrl/journal/server';
  static const tabelEndpoint = '$apiUrl/tableendpoint/data';
  static const syncSign = '$apiUrl/sync/sign';
  static const syncSignAtt = '$apiUrl/sync/signatt';
  static const syncReportRoute = '$apiUrl/sync/reportroute';
  static const syncReportLog = '$apiUrl/sync/reportlog';
  static const syncReportLogAtt = '$apiUrl/sync/reportlogatt';
  static const syncTaskCheck = '$apiUrl/sync/techtaskcheck';
  static const syncTaskCheckDelete = '$apiUrl/sync/techtaskcheckdelete';
  static const syncTaskNewsStatus = '$apiUrl/sync/technewsstatus';
  static const syncLogbook = '$apiUrl/sync/logbook';
  // static const dataKapal = '$apiUrl/vessel/GetDetail';
  static const dataKapal =
      'https://pelaut.dephub.go.id/trsea/trsea-api/api/vessel/GetDetail';
  static const oneSignalApiUrl = 'https://onesignal.com/api/v1/notifications';
  static const oneSignalAppId = 'f8f6161c-7908-4cd2-9f3e-1ebc2a8ad21b';
  static const oneSignalRestApiKey =
      'YzVjYTc5YmYtYjBhMi00NTJmLTk3ZjctYmFmODkxNDBjNzg1';

  // api fields
  static const key = 'key';
  static const q = 'q';
  static const days = 'days';
  static const lang = 'lang';

  // assets
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
  static const poltekpelBanten = 'assets/images/logo2.png';
  static const stip = 'assets/images/LogoSTIP1.png';

  static const weatherAnimation = 'assets/data/weather_animation.json';
}
