import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/data/models/instructor.dart';
import 'package:mytrb/app/data/models/type_vessel.dart';
import 'package:mytrb/app/modules/sign_on/controllers/sign_on_controller.dart';

class SignView extends GetView<SignController> {
  final formKey = GlobalKey<FormState>();
  SignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign On")),
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
                  vesselInput(context),
                  mySpacer(),
                  namaKapalInput(),
                  mySpacer(),
                  namaPerusahaanInput(),
                  mySpacer(),
                  imoNumberInput(),
                  mySpacer(),
                  mmsiNumberInput(),
                  mySpacer(),
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
                      ),
                      child: controller.isSubmitting.value
                          ? CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : const Text("Sign On"),
                    );
                  }),
                  mySpacer(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget mySpacer({double height = 20, double width = 10}) {
    return SizedBox(height: height, width: width);
  }

  Widget dateInput(BuildContext context) {
    return TextFormField(
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

  Widget namaKapalInput() {
    return TextFormField(
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
    return Obx(() => _imageInput(context, "Photo of Sign On",
        controller.signOnFoto, controller.signOnError));
  }

  Widget mutasiOnWidget(BuildContext context) {
    return Obx(() => _imageInput(context, "Photo of Mutasi On",
        controller.mutasiOnFoto, controller.mutasiOnError));
  }

  Widget imoFotoWidget(BuildContext context) {
    return Obx(() => _imageInput(
        context, "Photo of IMO", controller.imoFoto, controller.imoFotoError));
  }

  Widget crewListFotoWidget(BuildContext context) {
    return Obx(() => _imageInput(context, "Photo of Crew List",
        controller.crewListFoto, controller.crewListFotoError));
  }

  Widget bukuPelautFotoWidget(BuildContext context) {
    return Obx(() => _imageInput(context, "Photo of Seafarer's Book",
        controller.bukuPelautFoto, controller.bukuPelautFotoError));
  }

  Widget _imageInput(BuildContext context, String title, Rx<XFile?> imageFile,
      RxString error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        if (error.value.isNotEmpty)
          Text(
            error.value,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            XFile? tmp = await _showImagePicker(context);

            if (tmp != null) {
              imageFile.value = tmp;
              error.value = "";
            }
          },
          child: Ink(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border.all(
                  color: error.value.isNotEmpty
                      ? Theme.of(context).colorScheme.error
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              height: (30 / 100) * Get.height,
              child: Center(
                child: imageFile.value == null
                    ? _displayUpload(context)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FittedBox(
                          fit: BoxFit.contain, // Menjaga ukuran asli gambar
                          child: Image.file(
                            File(imageFile.value!.path),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Fungsi untuk menampilkan modal pemilihan gambar
  Future<XFile?> _showImagePicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    return await showModalBottomSheet<XFile?>(
      useRootNavigator: false,
      backgroundColor: Colors.white,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () async {
                XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                Get.back(result: pickedFile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                Get.back(result: pickedFile);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _displayUpload(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.cloud_upload_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
          WidgetSpan(child: mySpacer(height: 0, width: 10)),
          WidgetSpan(
            child: Text(
              "Upload / Take Photo",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
