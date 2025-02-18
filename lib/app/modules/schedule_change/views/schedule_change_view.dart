import 'package:mytrb/app/data/models/jadwal_reschedule.dart';
import 'package:mytrb/app/modules/schedule_change/controllers/schedule_change_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleChangeView extends GetView<ScheduleChangeController> {
  const ScheduleChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Perubahan Jadwal'),
      ),
      body: Obx(() {
        if (controller.diklatList.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data diklat.',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.diklatList.length,
            itemBuilder: (context, index) {
              var diklat = controller.diklatList[index];
              return GestureDetector(
                onTap: () async {
                  await controller.fetchGetForm(diklat.ucPendaftaran,
                      diklat.ucDiklatJadwal, diklat.ucDiklatTahun);
                  if (controller.rescheduleList.isNotEmpty) {
                    showDialogReschedule(controller.rescheduleList.first);
                  } else {
                    Get.snackbar(
                        'Mohon maaf', 'Tidak ada data reschedule tersedia');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: const Color(0xFFFFF1E6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: const BorderSide(color: Colors.orange, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'No. Regis: ${diklat.noRegis}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                (diklat.tanggalPendaftaran ?? ''),
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            diklat.namaDiklat ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tgl. Pelaksanaan: ${diklat.periode}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                'Status Pembayaran: ',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: diklat.statusBayar == 'Belum Bayar'
                                      ? Colors.red
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  diklat.statusBayar ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                'Status Validasi: ',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: diklat.statusValidasi ==
                                          'Belum Divalidasi'
                                      ? Colors.red
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  diklat.statusValidasi ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  void showDialogReschedule(JadwalReschedule reschedule) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Re-schedule Pelaksanaan Diklat',
          style: TextStyle(fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<JadwalReschedule>(
                    isExpanded: true,
                    hint: const Text(
                      'Pilih Gelombang/Periode',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: controller.rescheduleList
                        .map((JadwalReschedule reschedule) {
                      return DropdownMenuItem<JadwalReschedule>(
                        value: reschedule,
                        child: Text(reschedule.periode!),
                      );
                    }).toList(),
                    value: controller.selectedReschedule.value.isEmpty
                        ? null
                        : controller.rescheduleList.firstWhere((reschedule) =>
                            reschedule.ucDiklatJadwal ==
                            controller.selectedReschedule.value),
                    onChanged: (JadwalReschedule? newValue) {
                      if (newValue != null) {
                        controller.selectedReschedule.value =
                            newValue.ucDiklatJadwal!;
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
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white,
                      ),
                      offset: const Offset(0, 0),
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
              }),
              const SizedBox(height: 20),
              const Text(
                "Catatan: Hanya dapat mengubah 1 (satu) kali Gel/Periode Pelaksanaan Diklat.",
                style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 13),
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF002171),
                      Color(0xFF1565C0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    controller.saveReschedule();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
