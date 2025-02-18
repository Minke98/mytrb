import 'package:mytrb/app/modules/biodata/controllers/biodata_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiodataView extends GetView<BiodataController> {
  const BiodataView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.close(2);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Biodata'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.seafarerCodeController,
                  decoration: InputDecoration(
                    labelText: 'Seafarer Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.nikController,
                  decoration: InputDecoration(
                    labelText: 'NIK',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.namaLengkapController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.tempatLahirController,
                  decoration: InputDecoration(
                    labelText: 'Tempat Lahir',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                Obx(() => TextFormField(
                      controller: controller.tglLahirController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: controller.getFormattedDate(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () => controller.pickDate(context),
                    )),
                const SizedBox(height: 10),
                Obx(() {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Pilih Jenis Kelamin',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: ['Laki-laki', 'Perempuan'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: controller.selectedJenisKelamin.value == null
                          ? null
                          : ['Laki-laki', 'Perempuan'].firstWhere((jenis) =>
                              jenis == controller.selectedJenisKelamin.value),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectedJenisKelamin.value = newValue;
                          // controller.updateJenisKelamin(newValue);
                          controller
                              .onFieldChanged(); // Tambahkan ini jika perlu
                        }
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black38,
                          ),
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
                        maxHeight: 200,
                        width: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.white,
                        ),
                        offset: const Offset(0, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
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
                }),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.noTeleponController,
                  decoration: InputDecoration(
                    labelText: 'No. Whatsapp/Telepon',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.nisnController,
                  decoration: InputDecoration(
                    labelText: 'NISN',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.jurusanAsalController,
                  decoration: InputDecoration(
                    labelText: 'Jurusan Asal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.sekolahAsalController,
                  decoration: InputDecoration(
                    labelText: 'Sekolah Asal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.tahunLulusController,
                  decoration: InputDecoration(
                    labelText: 'Tahun Lulus Sesuai Ijazah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.tinggiBadanController,
                  decoration: InputDecoration(
                    labelText: 'Tinggi Badan',
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
              onPressed: () {
                controller.simpanForm();
              },
              // onPressed: controller.isFormChanged.value
              //     ? () {
              //         controller.simpanForm();
              //       }
              //     : () {
              //         Get.snackbar(
              //           'Info',
              //           'Tidak ada perubahan yang dilakukan!',
              //           snackPosition: SnackPosition.BOTTOM,
              //           backgroundColor: Colors.red,
              //           colorText: Colors.white,
              //         );
              //       },
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
