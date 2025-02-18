class Environment {
  // api key
  static const apiKey = '6f926d5c19164cdfa95205814242202';

  // api urls
  // static const baseUrl = 'http://api.weatherapi.com/v1';
  static const baseUrl = 'https://pelaut.dephub.go.id';
  // static const baseUrl = 'https://localhost';
  static const apiUrl = '$baseUrl/trsea/trsea-api/api/';
  static const refreshUrl = '$baseUrl/trsea/trsea-api/api/auth/refresh';
  static const baseline = '$apiUrl/sync/baseline';

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

  static const weatherAnimation = 'assets/data/weather_animation.json';
}
