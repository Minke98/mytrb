import 'package:mytrb/app/modules/training/controllers/training_controller.dart';
import 'package:mytrb/app/modules/upload_requirements/controllers/upload_requirements_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationSuccessView extends GetView<TrainingController> {
  RegistrationSuccessView({super.key});
  final UploadRequirementsController uploadRequiremenController =
      Get.put(UploadRequirementsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.INDEX, predicate: (route) {
          return route.settings.name == Routes.INDEX;
        });
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Pendaftaran Berhasil!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No. Pendaftaran : ',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      controller.registration?.dataPendaftaran?.noPendaftaran ??
                          '',
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Siapkan File/Scan PDF untuk melengkapi Persyaratan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {
                      uploadRequiremenController.fetchListPersyaratan(
                          controller.registration!.dataPendaftaran!.uc!);
                      Get.toNamed(Routes.REQUIREMENTS_DETAIL_LIVE);
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF002171),
                            Color(0xFF1565C0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 180,
                          minHeight: 40,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Upload Persyaratan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
