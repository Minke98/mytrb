import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationView extends GetView<AuthController> {
  RegistrationView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Environment.poltekpelBanten, // Ganti sesuai path logo Anda
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application Integrated',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Registration System',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Politeknik Pelayaran Banten',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Registration',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 80),
                    const Text(
                      'Sudah Punya BST?',
                      style: TextStyle(fontSize: 16),
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(
                              left: 0), // Pastikan padding luar sesuai
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Mengatur semua anak ke kiri
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Mengatur alignment vertikal
                                children: [
                                  SizedBox(
                                    width:
                                        150, // Sesuaikan dengan lebar yang diinginkan
                                    child: RadioListTile(
                                      value: "BP",
                                      groupValue: controller.typeReg.value,
                                      title: const Text(
                                        "Belum Punya",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      contentPadding: EdgeInsets
                                          .zero, // Hilangkan padding default
                                      onChanged: (value) {
                                        controller.typeReg.value =
                                            value.toString();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        150, // Sesuaikan dengan lebar yang diinginkan
                                    child: RadioListTile(
                                      value: "SP",
                                      groupValue: controller.typeReg.value,
                                      title: const Text(
                                        "Sudah Punya",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      contentPadding: EdgeInsets
                                          .zero, // Hilangkan padding default
                                      onChanged: (value) {
                                        controller.typeReg.value =
                                            value.toString();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.typeReg.value == "SP")
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller:
                                          controller.kodePelautController,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.badge_outlined),
                                        labelText: "Input Kode Pelaut",
                                        border: UnderlineInputBorder(),
                                        labelStyle: TextStyle(fontSize: 14),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Kode Pelaut harus diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: controller.nikController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.perm_identity),
                                  labelText: "Input Nomor Induk Kependudukan",
                                  border: UnderlineInputBorder(),
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'NIK harus diisi';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Adjust border radius as needed
                          ),
                          padding: const EdgeInsets.all(0), // No padding
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> arguments = {
                              'nik': controller.nikController.text,
                              'typeReg': controller.typeReg.value,
                            };

                            if (controller.typeReg.value == "SP") {
                              arguments['kodePelaut'] =
                                  controller.kodePelautController.text;
                            }

                            Get.toNamed(Routes.REGISTRATION_PROCEED,
                                arguments: arguments);
                          }
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
                            borderRadius: BorderRadius.circular(
                                8), // Adjust border radius as needed
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 180,
                                minHeight: 40), // Set min width and height
                            alignment: Alignment.center,
                            child: const Text(
                              'Lanjutkan',
                              style: TextStyle(
                                color: Colors.white, // Set text color to white
                                fontSize: 14, // Adjust font size as needed
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
        ],
      ),
    );
  }
}
