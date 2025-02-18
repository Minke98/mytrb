import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationProceedView extends GetView<AuthController> {
  RegistrationProceedView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments from previous route
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String nik = args['nik'] ?? '';
    final String? kodePelaut = args['kodePelaut']; // Optional, may be null
    final String typeReg = args['typeReg'] ?? '';

    if (kDebugMode) {
      print('Arguments received:');
    }
    if (kDebugMode) {
      print('NIK: $nik');
    }
    if (kDebugMode) {
      print('Kode Pelaut: $kodePelaut');
    }
    if (kDebugMode) {
      print('Type Registration: $typeReg');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Environment
                        .poltekpelBanten, // Replace with your actual image path
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
                      SizedBox(height: 8),
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
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Registration',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NIK'),
                    TextFormField(
                      initialValue: nik, // Set nik from arguments
                      decoration: const InputDecoration(
                        hintText: 'NIK',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your NIK';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Conditionally show Kode Pelaut field based on typeReg
                    if (typeReg != 'BP') ...[
                      const Text('Kode Pelaut'),
                      TextFormField(
                        initialValue:
                            kodePelaut, // Set kodePelaut from arguments if exists
                        decoration: const InputDecoration(
                          hintText: 'Kode Pelaut',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Kode Pelaut';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Other fields...
                    const Text('Nama Lengkap'),
                    TextFormField(
                      controller: controller.namaLengkapController,
                      decoration: const InputDecoration(
                        hintText: 'Nama Lengkap',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Tempat Lahir'),
                    TextFormField(
                      controller: controller.tempatLahirController,
                      decoration: const InputDecoration(
                        hintText: 'Tempat Lahir',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your place of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Tgl. Lahir'),
                    TextFormField(
                      controller: controller.tanggalLahirController,
                      decoration: const InputDecoration(
                        hintText: 'Tgl. Lahir',
                      ),
                      keyboardType: TextInputType.none, // Disable keyboard
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Dismiss keyboard
                        final DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (selectedDate != null) {
                          final formattedDate =
                              '${selectedDate.toLocal()}'.split(' ')[0];
                          controller.tanggalLahirController.text =
                              formattedDate;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Jenis Kelamin'),
                    Row(
                      children: [
                        Obx(() => Radio<String>(
                              value: '0',
                              groupValue: controller.gender.value,
                              onChanged: (value) {
                                controller.gender.value = value!;
                              },
                            )),
                        const Text('Pria'),
                        Obx(() => Radio<String>(
                              value: '1',
                              groupValue: controller.gender.value,
                              onChanged: (value) {
                                controller.gender.value = value!;
                              },
                            )),
                        const Text('Perempuan'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('No. Telepon/WhatsApp'),
                    TextFormField(
                      controller: controller.noTeleponController,
                      decoration: const InputDecoration(
                        hintText: 'No. Telepon/WhatsApp',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Email'),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!controller.isValidEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Alamat Sesuai KTP'),
                    TextFormField(
                      controller: controller.alamatController,
                      decoration: const InputDecoration(
                        hintText: 'Alamat Sesuai KTP',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
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
                          if (_formKey.currentState!.validate()) {
                            controller.regist();
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 180, minHeight: 40),
                            alignment: Alignment.center,
                            child: const Text(
                              'Daftar Akun',
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
          ],
        ),
      ),
    );
  }
}
