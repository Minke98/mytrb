import 'package:geolocator/geolocator.dart';

class Location {
  static Future getLocation({bool useDelay = false}) async {
    Map finalRes = {"status": true};
    try {
      if (useDelay == true) {
        await Future.delayed(const Duration(seconds: 10));
      }
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled == false) {
        throw ('Silahkan Hidupkan Lokasi Untuk Melanjutkan');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw ('Silahkan Hidupkan Izin Lokasi Untuk Melanjutkan');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw ('Izin lokasi ditolak secara permanen, Silahkan Izinkan Akses Lokasi Untuk Melanjutkan');
      }

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 60));
      if (pos.isMocked) {
        throw ("Lokasi Palsu Terdeteksi, silahkan perbaiki");
      }
      finalRes['position'] = pos;
    } catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    }
    return finalRes;
  }
}
