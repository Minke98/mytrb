class Environment {
  // api key
  static const apiKey = '6f926d5c19164cdfa95205814242202';

  // api urls
  // static const baseUrl = 'https://registration.poltekpel-banten.ac.id';
  static const baseUrl = 'http://192.168.1.19';
  static const apiUrl = '$baseUrl/trsea-api/api';
  // static const apiUrlTRB = '$baseUrlTRB/mytrb-api/api';
  // static const refreshUrl = '$baseUrlTRB/mytrb-api/api/auth/refresh';
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
  static const regist = '$apiUrl/auth/registration';
  static const jenisDiklat = '$apiUrl/master/JenisDiklat';
  static const diklat = '$apiUrl/master/Diklat';
  static const jadwalDiklat = '$apiUrl/master/JadwalDiklat';
  static const jadwalPelaksanaan = '$apiUrl/master/ListInfoJadwalPelaksana';
  static const infoJadwalDiklat = '$apiUrl/master/DetailInfoJadwalDiklat';
  static const persyaratanDiklat = '$apiUrl/master/PersyaratanDiklat';
  static const detailInfoJadwalDiklat = '$apiUrl/master/DetailInfoJadwalDiklat';
  static const uploadPersyaratan = '$apiUrl/persyaratan/DataDiklat';
  static const dataPersyaratan = '$apiUrl/persyaratan/DataPersyaratan';
  static const getFormPersyaratan = '$apiUrl/persyaratan/GetFormPersyaratan';
  static const uploadsDoc = '$apiUrl/persyaratan/UploadsDoc';
  static const updateDoc = '$apiUrl/persyaratan/UpdateDoc';
  static const sendDoc = '$apiUrl/persyaratan/SendDoc';
  static const registDiklat = '$apiUrl/registration/Store';
  static const registDiklatIII = '$apiUrl/registration/Store';
  static const registDiklatEndors = '$apiUrl/registration/Store';
  static const news = '$apiUrl/news/getData';
  static const newsCertificate = '$apiUrl/certificate/getData';
  static const oneSignalApiUrl = 'https://onesignal.com/api/v1/notifications';
  static const oneSignalAppId = 'f8f6161c-7908-4cd2-9f3e-1ebc2a8ad21b';
  static const oneSignalRestApiKey =
      'YzVjYTc5YmYtYjBhMi00NTJmLTk3ZjctYmFmODkxNDBjNzg1';
  static const dataDiklat = '$apiUrl/Reschedule/DataDiklat';
  static const getForm = '$apiUrl/reschedule/getForm';
  static const infoKursi = '$apiUrl/kuota/infoKursi';
  static const billingDetail = '$apiUrl/tagihan/getDetail';
  static const billing = '$apiUrl/tagihan/getData';
  static const reschedule = '$apiUrl/reschedule/DataDiklat';
  static const saveReschedule = '$apiUrl/reschedule/UpdateSchedule';
  static const urlDocument = '$baseUrl/uploads/document/';
  static const urlPengumuman = '$baseUrl/uploads/pengumuman/';
  static const urlPengaduan = '$baseUrl/uploads/pengaduan/';
  static const urlfoto = '$baseUrl/uploads/image/';
  static const history = '$apiUrl/history/getData';
  static const kuesioner = '$baseUrl/3.1/kuesioner/index/';
  static const biodata = '$apiUrl/person/dataPerson';
  static const updateBiodata = '$apiUrl/person/updatePerson';
  static const changeFoto = '$apiUrl/person/updateFoto';
  static const changePassword = '$apiUrl/person/updateChangePassword';
  static const getListCertificate = '$apiUrl/senderCert/getData';
  static const getFormCert = '$apiUrl/senderCert/getForm';
  static const getListCert = '$apiUrl/senderCert/listCert';
  static const pengajuanCert = '$apiUrl/senderCert/store';
  static const getDetailCert = '$apiUrl/senderCert/detailSender';
  static const updateStatusCert = '$apiUrl/senderCert/updateStatus';
  static const getListReport = '$apiUrl/pengaduan/getData';
  static const getTypeReport = '$apiUrl/pengaduan/typeAduan';
  static const getDiklatReport = '$apiUrl/pengaduan/ListDiklat';
  static const sendPengaduan = '$apiUrl/pengaduan/storeAduan';
  static const getDetailPengaduan = '$apiUrl/pengaduan/DetailAduan';

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
