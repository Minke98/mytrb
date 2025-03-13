import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/components/image_picker_widget.dart';
import 'package:mytrb/app/modules/sign_off/controllers/sign_off_controller.dart';
import 'package:mytrb/utils/dialog.dart';

class SignoffView extends GetView<SignoffController> {
  const SignoffView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          "Sign Off",
          style: TextStyle(fontSize: 16),
        )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 50,
                        color: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8), // Padding hanya kiri & kanan
                        child: const Align(
                          alignment: Alignment
                              .centerLeft, // Center secara vertikal, start secara horizontal
                          child: Text(
                            "Sign On data",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      signOnData(context),
                      signOnFotoPreview(),
                    ],
                  ),
                ),
                mySpacer(),
                Card(
                  elevation: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 50,
                        color: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8), // Padding hanya kiri & kanan
                        child: const Align(
                          alignment: Alignment
                              .centerLeft, // Center secara vertikal, start secara horizontal
                          child: Text(
                            "Sign Off data",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      _signOffForm(context),
                    ],
                  ),
                ),
                mySpacer(),
                signOffButton(context),
                mySpacer(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signOnData(BuildContext context) {
    return Obx(() {
      if (controller.signData.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(0.3),
            2: FlexColumnWidth(7.7),
          },
          children: [
            tableRow(
                "Sign On Date", controller.signData['sign_on_date_formated']),
            tableRow("Lecturer", controller.signData['full_name']),
            tableRow("Type Vessel", controller.signData['type_vessel']),
            tableRow("Vessel Name", controller.signData['vessel_name']),
            tableRow("Company Name", controller.signData['company_name']),
            tableRow("IMO NUMBER", controller.signData['imo_number']),
            tableRow("MMSI", controller.signData['mmsi_number']),
            tableRow("Sign On Foto", ""),
          ],
        ),
      );
    });
  }

  Widget signOnFotoPreview() {
    return Obx(() {
      if (controller.signData.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: FutureBuilder<ImageProvider<Object>>(
            future: controller.loadImage(
              controller.signData['sign_on_foto'] ?? '',
              controller.signData['sign_on_foto_url'],
            ),
            builder: (BuildContext context,
                AsyncSnapshot<ImageProvider<Object>> snapshot) {
              if (snapshot.hasData) {
                return Image(image: snapshot.data!);
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error!.toString()));
              } else {
                return const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Loading Image")
                    ],
                  ),
                );
              }
            },
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  TableRow tableRow(String label, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(label,
            style: const TextStyle(color: Colors.black, fontSize: 14)),
      ),
      const Text(":", style: TextStyle(color: Colors.black, fontSize: 14)),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(value,
            style: const TextStyle(color: Colors.black, fontSize: 14)),
      ),
    ]);
  }

  Widget signOffButton(BuildContext context) {
    final SignoffController controller = Get.find<SignoffController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            minimumSize: const Size.fromHeight(55),
          ),
          onPressed: () async {
            // Validasi foto
            bool imagesValid = true;
            if (controller.signOffImoFoto.value == null) {
              imagesValid = false;
              MyDialog.showError(context, "Masukkan Gambar Depan Imo");
            }
            if (controller.signOffPelabuhanFoto.value == null) {
              imagesValid = false;
              MyDialog.showError(context, "Masukkan Gambar Pelabuhan");
            }
            if (controller.crewListFoto.value == null) {
              imagesValid = false;
              MyDialog.showError(context, "Masukkan Gambar Crew List");
            }

            if (!imagesValid) return;

            // Konfirmasi Sign Off
            bool doSignOff = await _showConfirmSignOff();
            log("DO SIGN OFF: $doSignOff");

            if (doSignOff) {
              // Lakukan Sign Off dengan GetX
              await controller.signOff();
            }
          },
          child: const Text("Sign Off",
              style: TextStyle(color: Colors.white, fontSize: 14)),
        ),
      );
    });
  }

  Widget signOffImoFoto(BuildContext context) {
    return ImagePickerWidget(
      title: "Front Photo IMO",
      imageFile: controller.signOffImoFoto,
      error: controller.signOffImoFotoError,
    );
  }

  Widget signOffPelabuhanFoto(BuildContext context) {
    return ImagePickerWidget(
      title: "Port Photo",
      imageFile: controller.signOffPelabuhanFoto,
      error: controller.signOffPelabuhanFotoError,
    );
  }

  Widget crewListFoto(BuildContext context) {
    return ImagePickerWidget(
      title: "Photo of Crew List",
      imageFile: controller.crewListFoto,
      error: controller.crewListFotoError,
    );
  }

  Widget _errorFoto(BuildContext context, String? testVal) {
    return testVal == null
        ? const SizedBox.shrink()
        : Text(
            testVal,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          );
  }

  Widget _signOffForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mySpacer(height: 4.0),
          Obx(() => _errorFoto(context, controller.signOffImoFotoError.value)),
          signOffImoFoto(context),
          mySpacer(height: 8.0),
          mySpacer(height: 4.0),
          Obx(() =>
              _errorFoto(context, controller.signOffPelabuhanFotoError.value)),
          signOffPelabuhanFoto(context),
          mySpacer(height: 8.0),
          mySpacer(height: 4.0),
          Obx(() => _errorFoto(context, controller.crewListFotoError.value)),
          crewListFoto(context),
        ],
      ),
    );
  }

  Future<bool> _showConfirmSignOff() async {
    return await Get.defaultDialog<bool>(
          title: "Confirm Sign Off",
          titleStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.error,
          ),
          middleText: "Are you sure you want to sign off?",
          middleTextStyle: const TextStyle(fontSize: 14, color: Colors.black87),
          backgroundColor: Colors.white,
          barrierDismissible: false,
          radius: 8,
          textCancel: "No",
          textConfirm: "Yes",
          confirmTextColor: Colors.white,
          cancelTextColor: Colors.red,
          buttonColor: Colors.blue.shade900,
          onCancel: () => Get.back(result: false),
          onConfirm: () => Get.back(result: true),
        ) ??
        false; // Default return false jika dialog ditutup tanpa memilih
  }

  Widget mySpacer({double height = 10, double width = 10}) {
    return SizedBox(height: height, width: width);
  }
}
