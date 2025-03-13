import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticateUser(String reason) async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Biometric error: $e");
    }

    return isAuthenticated;
  }
}
