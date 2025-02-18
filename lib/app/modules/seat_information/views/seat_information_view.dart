import 'package:mytrb/app/data/models/diklat.dart';
import 'package:mytrb/app/data/models/jenis_diklat.dart';
import 'package:mytrb/app/modules/seat_information/controllers/seat_information_controller.dart';
import 'package:mytrb/app/modules/training/controllers/training_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeatInformationView extends GetView<SeatInformationController> {
  SeatInformationView({super.key});
  final TrainingController trainingController = Get.put(TrainingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Ketersediaan Kursi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Spacer(),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF002171),
                        Color(0xFF1565C0),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _showFilterDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text('Filter'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.filteredInfoKursiList.length,
                itemBuilder: (context, index) {
                  final kursi = controller.filteredInfoKursiList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Colors.orange[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  kursi.jenisDiklat ?? '-',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(kursi.pelaksanaanAkhir ?? '-'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              kursi.namaDiklat ?? '-',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Tgl. Pendaftaran Terakhir"),
                                    const SizedBox(height: 4),
                                    Text(kursi.pelaksanaanAkhir ?? '-',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Kuota"),
                                    const SizedBox(height: 4),
                                    Text(kursi.kuota ?? '-',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Sisa Kuota"),
                                    const SizedBox(height: 4),
                                    Text(kursi.sisaKursi ?? '-',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
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
            ),
          ),
          Obx(() {
            final int currentPage = controller.currentPage.value;
            final int totalPages = controller.totalPage.value;
            List<int?> generatePages() {
              List<int?> pages = [];
              pages.add(1);
              if (currentPage > 2) {
                pages.add(null);
              }
              if (currentPage != 1 && currentPage != totalPages) {
                pages.add(currentPage);
              }
              if (currentPage < totalPages - 1) {
                pages.add(null);
              }
              if (totalPages > 1) {
                pages.add(totalPages);
              }
              return pages;
            }

            final pages = generatePages();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF002171),
                          Color(0xFF1565C0),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton(
                      onPressed: currentPage > 1
                          ? () {
                              controller.previousPage();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text(
                        'Prev',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...pages.map((pageNumber) {
                    if (pageNumber == null) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          controller.goToPage(pageNumber);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF002171),
                                Color(0xFF1565C0),
                              ],
                            ),
                            color: currentPage == pageNumber
                                ? Colors.blue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Text(
                            pageNumber.toString(),
                            style: TextStyle(
                              color: currentPage == pageNumber
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  }).toList(),
                  const SizedBox(width: 8),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF002171),
                          Color(0xFF1565C0),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton(
                      onPressed: currentPage < totalPages
                          ? () {
                              controller.nextPage();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
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
                const Text('Filter'),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onPressed: () {
                    Get.back();
                    controller.clearDropdowns();
                  },
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<JenisDiklat>(
                      isExpanded: true,
                      hint: const Text(
                        'Pilih Jenis Diklat',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: trainingController.kategoriList
                          .map((JenisDiklat kategori) {
                        return DropdownMenuItem<JenisDiklat>(
                          value: kategori,
                          child: Text(kategori.jenisDiklat!),
                        );
                      }).toList(),
                      value: trainingController.selectedKategori.value.isEmpty
                          ? null
                          : trainingController.kategoriList.firstWhere(
                              (kategori) =>
                                  kategori.uc ==
                                  trainingController.selectedKategori.value),
                      onChanged: (JenisDiklat? newValue) {
                        if (newValue != null) {
                          trainingController.selectedKategori.value =
                              newValue.uc!;
                          trainingController.updateDiklatAndTanggal(newValue);
                          trainingController.selectedDiklat.value = '';
                          trainingController.diklatList.clear();
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
                              trainingController.isDropdownOpened.value
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
                        trainingController.isDropdownOpened.value = isOpen;
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<Diklat>(
                      isExpanded: true,
                      hint: const Text(
                        'Pilih Diklat',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: trainingController.diklatList.map((Diklat diklat) {
                        return DropdownMenuItem<Diklat>(
                          value: diklat,
                          child: Text(diklat.namaDiklat!),
                        );
                      }).toList(),
                      value: trainingController.selectedDiklat.value.isEmpty
                          ? null
                          : trainingController.diklatList.firstWhere((diklat) =>
                              diklat.uc ==
                              trainingController.selectedDiklat.value),
                      onChanged: (Diklat? newValue) {
                        if (newValue != null) {
                          trainingController.selectedDiklat.value =
                              newValue.uc!;
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
                              trainingController.isDropdownOpened.value
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
                        trainingController.isDropdownOpened.value = isOpen;
                      },
                    ),
                  );
                }),
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
                      String ucJenisDiklat =
                          trainingController.selectedKategori.value;
                      String ucDiklat = trainingController.selectedDiklat.value;
                      controller.fetchFilterInfoKursi(ucJenisDiklat, ucDiklat);
                      controller.clearDropdowns();
                      Get.close(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text('Set Filter'),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
