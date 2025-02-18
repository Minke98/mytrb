import 'package:mytrb/app/modules/biodata/controllers/biodata_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiodataParentView extends GetView<BiodataController> {
  const BiodataParentView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.formType.value = 'ortu';
    return WillPopScope(
      onWillPop: () async {
        Get.close(2);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perbaharui Data Orang Tua'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.noKKController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Kartu Keluarga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.namaAyahController,
                  decoration: InputDecoration(
                    labelText: 'Nama Ayah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.pekerjaanAyahController,
                  decoration: InputDecoration(
                    labelText: 'Pekerjaan Ayah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.namaIbuController,
                  decoration: InputDecoration(
                    labelText: 'Nama Ibu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.pekerjaanIbuController,
                  decoration: InputDecoration(
                    labelText: 'Pekerjaan Ibu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.noTeleponOrangTuaController,
                  decoration: InputDecoration(
                    labelText: 'No. Telepon Orang Tua',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: controller.isFormChanged.value
                  ? () {
                      controller.simpanForm();
                    }
                  : () {
                      Get.snackbar(
                        'Info',
                        'Tidak ada perubahan yang dilakukan!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
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
                  constraints:
                      const BoxConstraints(minWidth: 180, minHeight: 40),
                  alignment: Alignment.center,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
