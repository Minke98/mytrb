import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mytrb/app/data/models/pukp.dart';
import 'package:mytrb/app/data/models/upt.dart';
import 'package:mytrb/app/modules/credential/controllers/credential_controller.dart';

class CredentialView extends GetView<CredentialController> {
  const CredentialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Judul di atas dropdown
              const Text(
                "Choose School",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // PUKP Dropdown
              Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<Pukp>(
                    isExpanded: true,
                    hint: const Text("Pilih PUKP",
                        style: TextStyle(color: Colors.grey)),
                    value: controller.selectedPukp.value,
                    items: controller.pukpList.map((item) {
                      return DropdownMenuItem<Pukp>(
                        value: item,
                        child: Text(item.pukpLabel ?? '-'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedPukp.value = value;
                      controller.loadUptByPukp(value?.uc);
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 56,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black38),
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Obx(() => Icon(
                            controller.isPukpDropdownOpened.value
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                          )),
                      iconSize: 24,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black26),
                        color: Colors.white,
                      ),
                      offset: const Offset(0, 5),
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
                      controller.isPukpDropdownOpened.value = isOpen;
                    },
                  ),
                );
              }),

              const SizedBox(height: 20),

              // UPT Dropdown
              Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<Upt>(
                    isExpanded: true,
                    hint: const Text("Pilih UPT",
                        style: TextStyle(color: Colors.grey)),
                    value: controller.selectedUpt.value,
                    items: controller.uptList.map((item) {
                      return DropdownMenuItem<Upt>(
                        value: item,
                        child: Text(item.uptLabel ?? '-'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedUpt.value = value;
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 56,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black38),
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Obx(() => Icon(
                            controller.isUptDropdownOpened.value
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                          )),
                      iconSize: 24,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black26),
                        color: Colors.white,
                      ),
                      offset: const Offset(0, 5),
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
                      controller.isUptDropdownOpened.value = isOpen;
                    },
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isDisabled = controller.selectedPukp.value == null ||
                      controller.selectedUpt.value == null;

                  return ElevatedButton(
                    onPressed: isDisabled
                        ? null
                        : () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            controller.submitConfiguration();
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),
                      backgroundColor:
                          isDisabled ? Colors.grey : Colors.blue.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
