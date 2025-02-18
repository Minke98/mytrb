import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/profile/controllers/profile_controllers.dart';

class ChangePasswordView extends GetView<ProfileController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.close(2);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Ubah PIN")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChangePasswordSection(context),
                const SizedBox(height: 20),
                _buildSaveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.changePassController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: 'PIN Baru',
            labelStyle: const TextStyle(
              fontSize: 13.0,
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.retypePassController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: 'Konfirmasi PIN Baru',
            labelStyle: const TextStyle(
              fontSize: 13.0,
            ),
          ),
          obscureText: true,
          cursorColor: Colors.black,
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Adjust border radius as needed
          ),
          padding: const EdgeInsets.all(0), // No padding
        ),
        onPressed: () {
          controller.changePassword(context);
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
            borderRadius:
                BorderRadius.circular(8), // Adjust border radius as needed
          ),
          child: Container(
            constraints: const BoxConstraints(
                minWidth: 180, minHeight: 40), // Set min width and height
            alignment: Alignment.center,
            child: const Text(
              'Simpan Perubahan',
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 14, // Adjust font size as needed
              ),
            ),
          ),
        ),
      ),
    );
  }
}
