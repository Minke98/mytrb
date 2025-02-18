import 'package:mytrb/app/data/models/diklat_pengaduan.dart';
import 'package:mytrb/app/data/models/report_evaluation.dart';
import 'package:mytrb/app/data/models/type_pengaduan.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_evaluation/controllers/report_evaluation_controller.dart';

class ReportEvaluationView extends GetView<ReportEvaluationController> {
  ReportEvaluationView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.close(2);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengaduan'),
        ),
        body: Obx(() {
          if (controller.reportList.isEmpty) {
            return Center(
              child: Text(
                'Belum ada laporan pengaduan.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: controller.reportList.length,
              itemBuilder: (context, index) {
                final ticket = controller.reportList[index];
                return GestureDetector(
                  onTap: () {
                    controller.getDetailPengaduan(ticket.ucPengaduan);
                    Get.toNamed(Routes.REPORT_EVALUATION_DETAIL);
                  },
                  child: Card(
                    color: Colors.blue[50],
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Baris pertama: No. Tiket dan Tgl Pengaduan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // No. Tiket
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'No. Tiket : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      ticket.noTicket ?? '-',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              // Spacer untuk memberikan jarak antar elemen
                              const SizedBox(width: 80),
                              // Tgl Pengaduan
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tgl Pengaduan : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      ticket.tglPengaduan ?? '-',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Type Pengaduan : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      ticket.typePengaduan ?? '-',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              // Spacer untuk memberikan jarak antar elemen
                              const SizedBox(width: 80),
                              // Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Status : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(ticket.status),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        getStatusText(
                                            ticket.status ?? 'Unknown'),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.fetchDiklatReport();
            _showFilterDialog(context);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    Get.dialog(
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Form Pengaduan'),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onPressed: () {
                    Get.back();
                    controller.clearDialog();
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Diklat',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<DiklatPengaduan>(
                        isExpanded: true,
                        hint: const Text(
                          'Pilih Diklat',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        items: controller.diklatPengaduanList
                            .map((DiklatPengaduan diklatPengaduan) {
                          return DropdownMenuItem<DiklatPengaduan>(
                            value: diklatPengaduan,
                            child: Text(diklatPengaduan.diklat!),
                          );
                        }).toList(),
                        value: controller.selectedDiklat.value.isEmpty
                            ? null
                            : controller.diklatPengaduanList.firstWhere(
                                (diklatPengaduan) =>
                                    diklatPengaduan.ucPendaftaran ==
                                    controller.selectedDiklat.value),
                        onChanged: (DiklatPengaduan? newValue) {
                          if (newValue != null) {
                            controller.selectedDiklat.value =
                                newValue.ucPendaftaran!;
                            controller.fetchTypeReport();
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
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Type Pengaduan',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<TypePengaduan>(
                        isExpanded: true,
                        hint: const Text(
                          'Pilih Type Pengaduan',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        items: controller.typeReportList
                            .map((TypePengaduan typePengaduan) {
                          return DropdownMenuItem<TypePengaduan>(
                            value: typePengaduan,
                            child: Text(typePengaduan.typePengaduan!),
                          );
                        }).toList(),
                        value: controller.selectedTypeReport.value.isEmpty
                            ? null
                            : controller.typeReportList.firstWhere(
                                (typePengaduan) =>
                                    typePengaduan.id ==
                                    controller.selectedTypeReport.value),
                        onChanged: (TypePengaduan? newValue) {
                          if (newValue != null) {
                            controller.selectedTypeReport.value = newValue.id!;
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
                  const SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller.pengaduanController,
                          decoration: InputDecoration(
                            labelText: 'Input Pengaduan',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Lampiran',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText:
                                  controller.selectedFileName.value.isNotEmpty
                                      ? controller.selectedFileName.value
                                      : 'Choose file',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 12.0,
                              ),
                              suffixIcon: ElevatedButton(
                                onPressed: () async {
                                  await controller.pickFile();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey[400],
                                ),
                                child: const Text('Browse'),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 40,
                    width: double.infinity,
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
                        if (_formKey.currentState!.validate()) {
                          controller.sendReport();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
