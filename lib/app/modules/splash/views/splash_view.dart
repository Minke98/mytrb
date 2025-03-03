import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:mytrb/app/components/footer_copyright.dart';
import 'package:mytrb/app/components/footer_copyright_login.dart';
import 'package:mytrb/config/environment/environment.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetWidget<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const Spacer(flex: 3), // Ruang atas sedikit lebih kecil
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 1000),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Image.asset(
                          Environment.stip,
                          height: 180,
                          width: 180,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'MyTRB',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(
                    flex: 6), // Kurangi tinggi spacer ini agar teks bawah naik
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  duration: const Duration(milliseconds: 1200),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: Text(
                          'Sekolah Tinggi Ilmu Pelayaran Jakarta',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 30.0),
                      //   child: Text(
                      //     'Jakarta',
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //       color: Colors.white,
                      //     ),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // const SizedBox(
                //     height: 30), // Tambahkan sedikit ruang sebelum footer
                // const Padding(
                //   padding: EdgeInsets.only(bottom: 16.0),
                //   child: FooterCopyrightLogin(),
                // ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const FooterCopyrightLogin());
  }
}
