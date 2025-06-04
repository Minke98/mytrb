import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/components/image_picker_widget.dart';
import 'package:mytrb/app/data/models/instructor.dart';
import 'package:mytrb/app/data/models/type_vessel.dart';
import 'package:mytrb/app/data/models/vessel_info.dart';
import 'package:mytrb/app/modules/sign_on/controllers/sign_on_controller.dart';

class SignOnView extends GetView<SignController> {
  final formKey = GlobalKey<FormState>();
  SignOnView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          "Sign On",
          style: TextStyle(fontSize: 16),
        )),
        body: SingleChildScrollView(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dateInput(context),
                    mySpacer(),
                    dosenInput(context),
                    mySpacer(),
                    vesselInput2(context),
                    mySpacer(),
                    // vesselInput(context),
                    // mySpacer(),
                    // namaKapalInput(),
                    // mySpacer(),
                    // namaPerusahaanInput(),
                    // mySpacer(),
                    // imoNumberInput(),
                    // mySpacer(),
                    // mmsiNumberInput(),
                    // mySpacer(),
                    errorFoto(context, controller.signOnError.value),
                    signOnFotoWidget(context),
                    mySpacer(),
                    errorFoto(context, controller.mutasiOnError.value),
                    mutasiOnWidget(context),
                    mySpacer(),
                    errorFoto(context, controller.imoFotoError.value),
                    imoFotoWidget(context),
                    mySpacer(),
                    errorFoto(context, controller.crewListFotoError.value),
                    crewListFotoWidget(context),
                    mySpacer(),
                    errorFoto(context, controller.bukuPelautFotoError.value),
                    bukuPelautFotoWidget(context),
                    mySpacer(height: 30),
                    Obx(() {
                      bool isFormValid = controller.isFormValid();
                      return ElevatedButton(
                        onPressed: isFormValid
                            ? () => controller.submitSignForm()
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(55),
                          backgroundColor:
                              isFormValid ? Colors.blue.shade900 : Colors.grey,
                          splashFactory: controller.isSubmitting.value
                              ? NoSplash.splashFactory
                              : InkSplash.splashFactory,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isSubmitting.value
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                            : const Text(
                                "Sign On",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                      );
                    }),
                    mySpacer(height: 30),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget mySpacer({double height = 20, double width = 10}) {
    return SizedBox(height: height, width: width);
  }

  Widget dateInput(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black, // Warna teks input
      ),
      readOnly: true,
      onTap: () => controller.pickDate(context),
      controller: controller.dateController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill in the Sign On date";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Sign On Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.black), // Ganti warna fokus
        ),
      ),
    );
  }

  Widget dosenInput(BuildContext context) {
    return Obx(() {
      return DropdownButtonHideUnderline(
        child: DropdownButton2<Instructor>(
          isExpanded: true,
          hint: const Text(
            "Select Lecturer",
            style: TextStyle(color: Colors.grey),
          ),
          value: controller.dosenSelected.value,
          items: controller.dosenList.map((instructor) {
            return DropdownMenuItem<Instructor>(
              value: instructor,
              child: Text(instructor.fullName!),
            );
          }).toList(),
          onChanged: (Instructor? value) {
            controller.dosenSelected.value = value;
            controller.dosenController.text = value?.fullName ?? "";
          },
          buttonStyleData: ButtonStyleData(
            height: 56,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black38),
            ),
            elevation: 0,
          ),
          iconStyleData: IconStyleData(
            icon: Obx(() => Icon(
                  controller.isDropdownOpened.value
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                )),
            iconSize: 24,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200, // Batasi tinggi dropdown agar tidak menutupi form
            width: null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black26),
              color: Colors.white,
            ),
            offset: const Offset(0, 5), // Geser dropdown ke bawah
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
          onMenuStateChange: (isOpen) {
            controller.isDropdownOpened.value = isOpen;
          },
        ),
      );
    });
  }

  Widget vesselInput(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<TypeVessel>(
        isExpanded: true,
        hint: const Text(
          "Select a Type of Vessel",
          style: TextStyle(color: Colors.grey),
        ),
        value: controller.selectedVessel.value,
        items: controller.vesselList.map((value) {
          return DropdownMenuItem<TypeVessel>(
            value: value,
            child: Text(value.typeVessel!, overflow: TextOverflow.fade),
          );
        }).toList(),
        onChanged: (value) => controller.selectedVessel.value = value,
        buttonStyleData: ButtonStyleData(
          height: 56,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black38),
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: Obx(() => Icon(
                controller.isDropdownOpened.value
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
              )),
          iconSize: 24,
          iconEnabledColor: Colors.black,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200, // Batasi tinggi dropdown agar tidak menutupi form
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black26),
            color: Colors.white,
          ),
          offset: const Offset(0, 5), // Geser dropdown sedikit ke bawah
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        onMenuStateChange: (isOpen) {
          controller.isDropdownOpened.value = isOpen;
        },
      ),
    );
  }

  Widget vesselInput2(BuildContext context) {
    return Obx(() {
      final isIndonesia = controller.selectedVesselType.value == "indonesian";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vessel Category (Indonesian/Foreign)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  activeColor: Colors.black,
                  title: const Text("Indonesian"),
                  value: "indonesian",
                  groupValue: controller.selectedVesselType.value,
                  onChanged: (value) {
                    controller.selectedVesselType.value = value!;
                    controller.imoNumberController.clear();
                    controller.namaKapalController.clear();
                    controller.noRegistrasiController.clear();
                    controller.namaPerusahaanController.clear();
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  activeColor: Colors.black,
                  title: const Text("Foreign"),
                  value: "foreign",
                  groupValue: controller.selectedVesselType.value,
                  onChanged: (value) {
                    controller.selectedVesselType.value = value!;
                    controller.imoNumberController.clear();
                    controller.namaKapalController.clear();
                    controller.noRegistrasiController.clear();
                    controller.namaPerusahaanController.clear();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isIndonesia
              ? Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black, // Warna teks input
                        ),
                        controller: controller.noRegistrasiController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: "Nomor Registrasi Kapal",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: Colors.black), // Ganti warna fokus
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nomor Registrasi wajib diisi";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final noReg =
                            controller.noRegistrasiController.text.trim();

                        if (noReg.isEmpty) {
                          Get.snackbar(
                            'Peringatan',
                            'Nomor Registrasi tidak boleh kosong',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Menampilkan loading dengan GetX
                        EasyLoading.show(status: "Mencari Data Kapal");

                        final signRepo = SignRepository();
                        final result = await signRepo.getVesselTypeOnline(
                          noPendaftaran: noReg,
                        );

                        // Menghilangkan loading setelah mendapatkan hasil
                        EasyLoading.dismiss();

                        if (result['status'] == true &&
                            result['vessel'] != null) {
                          final VesselInfo vessel = result['vessel'];
                          controller.imoNumberController.text =
                              vessel.nomorIMO ?? '';
                          controller.namaKapalController.text =
                              vessel.namaKapal ?? '';
                          controller.namaPerusahaanController.text =
                              vessel.namaPemilik ?? '';
                        } else {
                          Get.snackbar(
                            'Terjadi Kesalahan',
                            result['message'] ?? 'Terjadi kesalahan',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Tambahan jika ingin sudut melengkung
                        ),
                        foregroundColor: Colors.white, // Warna teks
                      ),
                      child: const Text("Cari"),
                    ),
                  ],
                )
              : TextFormField(
                  style: const TextStyle(
                    color: Colors.black, // Warna teks input
                  ),
                  controller: controller.noRegistrasiController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Nomor Registrasi Kapal",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.black), // Ganti warna fokus
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nomor Registrasi wajib diisi";
                    }
                    return null;
                  },
                ),
          const SizedBox(height: 16),
          TextFormField(
            style: const TextStyle(
              color: Colors.black, // Warna teks input
            ),
            controller: controller.imoNumberController,
            cursorColor: Colors.black,
            enabled: !isIndonesia,
            decoration: InputDecoration(
              labelText: "No IMO",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "No IMO wajib diisi";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: const TextStyle(
              color: Colors.black, // Warna teks input
            ),
            controller: controller.namaKapalController,
            cursorColor: Colors.black,
            enabled: !isIndonesia,
            decoration: InputDecoration(
              labelText: "Nama Kapal",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vessel Name wajib diisi";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: const TextStyle(
              color: Colors.black, // Warna teks input
            ),
            controller: controller.namaPerusahaanController,
            cursorColor: Colors.black,
            enabled: !isIndonesia,
            decoration: InputDecoration(
              labelText: "Nama Perusahaan",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama Perusahaan wajib diisi";
              }
              return null;
            },
          ),
        ],
      );
    });
  }

  Widget namaKapalInput() {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller.namaKapalController,
      decoration: InputDecoration(
        labelText: "Vessel Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill in the name of the vessel";
        }
        return null;
      },
    );
  }

  Widget namaPerusahaanInput() {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller.namaPerusahaanController,
      decoration: InputDecoration(
        labelText: "Company Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill in the name of the company";
        }
        return null;
      },
    );
  }

  Widget imoNumberInput() {
    return TextFormField(
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      controller: controller.imoNumberController,
      decoration: InputDecoration(
        labelText: "IMO Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill in the IMO (International Maritime Organization) number";
        }
        return null;
      },
    );
  }

  Widget mmsiNumberInput() {
    return TextFormField(
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      controller: controller.mmsiNumberController,
      decoration: InputDecoration(
        labelText: "MMSI Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill in the MMSI (Maritime Mobile Service Identity) number";
        }
        return null;
      },
    );
  }

  Widget signOnFotoWidget(BuildContext context) {
    return ImagePickerWidget(
      title: "Photo of Sign On",
      imageFile: controller.signOnFoto,
      error: controller.signOnError,
    );
  }

  Widget mutasiOnWidget(BuildContext context) {
    return ImagePickerWidget(
      title: "Photo of Mutasi On",
      imageFile: controller.mutasiOnFoto,
      error: controller.mutasiOnError,
    );
  }

  Widget imoFotoWidget(BuildContext context) {
    return ImagePickerWidget(
      title: "Photo of IMO",
      imageFile: controller.imoFoto,
      error: controller.imoFotoError,
    );
  }

  Widget crewListFotoWidget(BuildContext context) {
    return ImagePickerWidget(
      title: "Photo of Crew List",
      imageFile: controller.crewListFoto,
      error: controller.crewListFotoError,
    );
  }

  Widget bukuPelautFotoWidget(BuildContext context) {
    return ImagePickerWidget(
      title: "Photo of Seafarer's Book",
      imageFile: controller.bukuPelautFoto,
      error: controller.bukuPelautFotoError,
    );
  }

  // Widget _imageInput(BuildContext context, String title, Rx<XFile?> imageFile,
  //     RxString error) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(title, style: Theme.of(context).textTheme.bodyLarge),
  //       const SizedBox(height: 8),
  //       if (error.value.isNotEmpty)
  //         Text(
  //           error.value,
  //           style: TextStyle(color: Theme.of(context).colorScheme.error),
  //         ),
  //       const SizedBox(height: 4),
  //       InkWell(
  //         onTap: () async {
  //           FocusScope.of(context).unfocus();
  //           XFile? tmp = await _showImagePicker(context);

  //           if (tmp != null) {
  //             imageFile.value = tmp;
  //             error.value = "";
  //           }
  //         },
  //         child: Ink(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.grey[800],
  //               border: Border.all(
  //                 color: error.value.isNotEmpty
  //                     ? Theme.of(context).colorScheme.error
  //                     : Colors.transparent,
  //               ),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             width: double.infinity,
  //             height: (30 / 100) * Get.height,
  //             child: Center(
  //               child: imageFile.value == null
  //                   ? _displayUpload(context)
  //                   : ClipRRect(
  //                       borderRadius: BorderRadius.circular(8),
  //                       child: SizedBox(
  //                         width: double.infinity, // atau berikan ukuran minimal
  //                         height: double.infinity,
  //                         child: FittedBox(
  //                           fit: BoxFit.contain,
  //                           child: Image.file(
  //                             File(imageFile.value!.path),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // /// Fungsi untuk menampilkan modal pemilihan gambar
  // Future<XFile?> _showImagePicker(BuildContext context) async {
  //   final ImagePicker picker = ImagePicker();

  //   return await showModalBottomSheet<XFile?>(
  //     useRootNavigator: false,
  //     backgroundColor: Colors.transparent, // Set agar bisa melihat efek rounded
  //     isDismissible: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ClipRRect(
  //         borderRadius: const BorderRadius.vertical(
  //             top: Radius.circular(20)), // Rounded di atas
  //         child: Container(
  //           color: Colors.white, // Warna background tetap putih
  //           child: Wrap(
  //             children: [
  //               ListTile(
  //                 leading: const Icon(Icons.camera_alt),
  //                 title: const Text('Ambil Foto'),
  //                 onTap: () async {
  //                   XFile? pickedFile =
  //                       await picker.pickImage(source: ImageSource.camera);
  //                   Get.back(result: pickedFile);
  //                 },
  //               ),
  //               ListTile(
  //                 leading: const Icon(Icons.photo_library),
  //                 title: const Text('Pilih dari Galeri'),
  //                 onTap: () async {
  //                   XFile? pickedFile =
  //                       await picker.pickImage(source: ImageSource.gallery);
  //                   Get.back(result: pickedFile);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _displayUpload(BuildContext context) {
  //   return RichText(
  //     text: TextSpan(
  //       children: [
  //         WidgetSpan(
  //           child: Icon(
  //             Icons.cloud_upload_rounded,
  //             color: Colors.grey[400],
  //             size: 20,
  //           ),
  //         ),
  //         WidgetSpan(child: mySpacer(height: 0, width: 10)),
  //         WidgetSpan(
  //           child: Text(
  //             "Upload / Take Photo",
  //             style: TextStyle(
  //               color: Theme.of(context).colorScheme.onSecondaryContainer,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget errorFoto(BuildContext context, String errorText) {
    return errorText.isEmpty
        ? const SizedBox.shrink()
        : Text(
            errorText,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          );
  }
}
