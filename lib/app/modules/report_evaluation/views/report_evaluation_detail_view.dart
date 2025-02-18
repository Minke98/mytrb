import 'package:mytrb/app/modules/report_evaluation/controllers/report_evaluation_controller.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

class ReportEvaluationDetailView extends GetView<ReportEvaluationController> {
  const ReportEvaluationDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengaduan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'No. Tiket : ',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          controller.detailPengaduan.value?.noTiket ?? '-',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      controller.detailPengaduan.value?.tglAduan ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Type Pengaduan : ',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4.0),
                Text(
                  controller.detailPengaduan.value?.typePengaduan ?? '-',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),

                // Nama Diklat
                const Text(
                  'Nama Diklat : ',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8.0),
                Text(
                  controller.detailPengaduan.value?.namaDiklat ?? '',
                  style: const TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),

                // Keterangan
                const Text(
                  'Keterangan : ',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8.0),
                Text(
                  controller.detailPengaduan.value?.aduan ?? '',
                  style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 16.0),

                // Lampiran
                const Text(
                  'Lampiran : ',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4.0),
                GestureDetector(
                  onTap: () {
                    _fileView(controller.detailPengaduan.value
                        ?.file); // Menampilkan file lampiran
                  },
                  child: const Text(
                    'Lihat File Lampiran',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Jawaban Operator
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jawaban Operator : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      controller.detailPengaduan.value?.tglJawab ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  controller.detailPengaduan.value?.jawaban ?? '',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _fileView(String? fileUrl) async {
    if (fileUrl == null) {
      Get.snackbar('Error', 'File URL is null');
      return;
    }

    String fileExtension = fileUrl.split('.').last.toLowerCase();
    String completeUrl = Environment.urlPengaduan + fileUrl;

    if (fileExtension == 'jpg' ||
        fileExtension == 'jpeg' ||
        fileExtension == 'png') {
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(completeUrl),
            ],
          ),
        ),
      );
    } else if (fileExtension == 'pdf') {
      await controller.loadPdfFromUrl(completeUrl);
      Get.dialog(
        Dialog(
          child: SizedBox(
            height: 600,
            child: Obx(() {
              if (controller.pdfPath.value == null) {
                return const Center(
                  child: Text(
                    'File PDF tidak tersedia.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                );
              } else {
                return FutureBuilder<PdfDocument>(
                  future: controller.pdfPath.value,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Terjadi kesalahan saat memuat PDF',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text(
                          'File PDF tidak ditemukan.',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 380,
                        child: Stack(
                          children: [
                            PdfViewPinch(
                              controller: controller.pdfPinchController,
                              onPageChanged: (page) {
                                controller.onPageChanged(page);
                              },
                            ),
                            Positioned(
                              top: 10.0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Obx(() {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      controller.pageFractionText.value,
                                      style: const TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              }
            }),
          ),
        ),
      );
    } else {
      Get.snackbar('Error', 'Format file tidak didukung');
    }
  }
}
