import 'package:mytrb/app/modules/upload_requirements/controllers/upload_requirements_controller.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

class RequirementDetailsLiveView extends GetView<UploadRequirementsController> {
  const RequirementDetailsLiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Persyaratan'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Obx(() {
              final diklat = controller.infoDiklat.value;
              if (diklat == null) {
                return const SizedBox.shrink();
              }
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: const Color(0xFFFFF4E1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'No. Regis: ${diklat.noPendaftaran ?? ''}',
                          ),
                          Text(
                            formatDateTime(diklat.tanggalDaftar ?? ''),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diklat.namaDiklat ?? 'Nama Diklat Tidak Tersedia',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Periode: ${diklat.periode ?? ''}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Tgl. Pendaftaran Tutup: ${diklat.pendaftaranAkhir != null ? formatDate(diklat.pendaftaranAkhir!) : 'Belum Ditetapkan'}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     const Text(
                          //       'Status Persyaratan',
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //     _buildStatusChip(
                          //       diklat.statusSyarat == '0'
                          //           ? 'Belum Lengkap'
                          //           : 'Lengkap',
                          //     ),
                          //   ],
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status Validasi',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              _buildStatusChip(
                                diklat.statusValidasi == '0'
                                    ? 'Belum Diverifikasi'
                                    : 'Terverifikasi',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Obx(() {
              final requirements = controller.dataPersyaratanList;
              if (requirements.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: List.generate(requirements.length, (index) {
                  final requirement = requirements[index];
                  return Column(
                    children: [
                      _buildRequirementCard(
                          iconColor: requirement.file != null &&
                                  requirement.file!.isNotEmpty
                              ? Colors.green
                              : Colors.red,
                          title: requirement.persyaratan ??
                              '', // Default title if null
                          subtitle: requirement.file != null &&
                                  requirement.file!.isNotEmpty
                              ? 'File Sudah Diupload' // File exists and is not empty
                              : 'File Belum Diupload', // File is null or empty
                          validationStatus: requirement.validasi == '1'
                              ? 'valid'
                              : 'invalid', // Assuming you have a field to represent validation status
                          validationNote: requirement.catatan ??
                              '-', // Validation note, if available
                          isFileUploaded: requirement.file != null &&
                              requirement.file!
                                  .isNotEmpty, // Determines if file is uploaded
                          onUploadPressed: () {
                            controller.selectRequirement(index);
                            controller.fetchUpload();

                            if (requirement.file != null &&
                                requirement.file!.isNotEmpty) {
                              showEditDialog(
                                context,
                                requirement.persyaratan ?? '',
                              );
                            } else {
                              _showUploadDialog(
                                context,
                                requirement.persyaratan ?? '',
                              );
                            }
                          },
                          textUpload: requirement.file != null &&
                                  requirement.file!.isNotEmpty
                              ? 'Edit'
                              : 'Upload'),
                      const SizedBox(
                          height: 16), // Jarak antar item persyaratan
                    ],
                  );
                }),
              );
            }),
          ],
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
                controller.sendPersyaratan();
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 180,
                    minHeight: 40,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Kirim Persyaratan',
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

  void showEditDialog(
    BuildContext context,
    String kategoriFile,
  ) {
    final backupFileName = controller.selectedFileName.value;
    final backupFile = controller.selectedFile.value;
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          controller.selectedFileName.value = backupFileName;
          controller.selectedFile.value = backupFile;
          return true;
        },
        child: AlertDialog(
          title: const Text('Upload Persyaratan'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Kategori File', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: kategoriFile,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final fileUrl =
                    controller.upload.value?.dataPersyaratanFile?.file;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('File Yang Terupload'),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _handleFileView(fileUrl, kategoriFile),
                      child: const Text(
                        'Lihat File',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Ubah File'),
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
                );
              }),
            ],
          ),
          actions: [
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
              child: Obx(() => ElevatedButton(
                    onPressed: controller.selectedFile.value != null
                        ? () {
                            controller.updateFile();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDialog(
    BuildContext context,
    String kategoriFile,
  ) {
    final backupFileName = controller.selectedFileName.value;
    final backupFile = controller.selectedFile.value;

    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          controller.selectedFileName.value = backupFileName;
          controller.selectedFile.value = backupFile;
          return true;
        },
        child: AlertDialog(
          title: const Text('Upload Persyaratan'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Kategori File',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: kategoriFile,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final fileUrl =
                    controller.upload.value?.dataPersyaratanFile?.file;
                final statusFile = controller.upload.value?.statusFile == 1;
                final hasUploaded = fileUrl != null && fileUrl.isNotEmpty;

                if (hasUploaded && statusFile) {
                  // If the file has been uploaded and statusFile == 1
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('File Yang Terupload'),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => _handleFileView(fileUrl, kategoriFile),
                        child: const Text(
                          'Lihat File',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '*) Informasi jika',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' File Sudah Tersedia: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Peserta Tidak Diperlukan Untuk Mengupload Berkas Kembali, Cukup Menekan Tombol Save untuk Menyertakan/Menyimpan Berkas',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          // const Text(
                          //   '• Jika Peserta ingin Mengubah Berkas Tersebut, tekan edit dibawah ini',
                          //   style: TextStyle(fontSize: 12),
                          // ),
                          // const SizedBox(height: 8),
                          // GestureDetector(
                          //   onTap: () {
                          //      Get.close(1); // Close the current dialog
                          //       showEditDialog(context,
                          //           kategoriFile); // Open the edit dialog
                          //   },
                          //   child: const Text('Edit', style: TextStyle(fontSize: 12, color: Colors.blue),
                          //   ),
                          // )
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Belum diupload'),
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
                  );
                }
              }),
            ],
          ),
          actions: [
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
              child: Obx(() {
                final fileUrl =
                    controller.upload.value?.dataPersyaratanFile?.file;
                final statusFile = controller.upload.value?.statusFile == 1;
                final hasUploaded = fileUrl != null && fileUrl.isNotEmpty;

                return ElevatedButton(
                  onPressed:
                      controller.selectedFile.value != null || hasUploaded
                          ? () {
                              if (hasUploaded && statusFile) {
                                controller.saveFile();
                              } else {
                                controller.uploadFile();
                              }
                            }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    hasUploaded && statusFile ? 'Save' : 'Upload',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFileView(String? fileUrl, String fileCategory) async {
    if (fileUrl == null) {
      Get.snackbar('Error', 'File URL is null');
      return;
    }

    String fileExtension = fileUrl.split('.').last.toLowerCase();
    String completeUrl = Environment.urlDocument + fileUrl;

    if (fileExtension == 'jpg' ||
        fileExtension == 'jpeg' ||
        fileExtension == 'png') {
      Get.dialog(
        AlertDialog(
          title: Text(fileCategory), // Menambahkan kategori file
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Kategori: $fileCategory', // Menambahkan kategori file
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'Terjadi kesalahan saat memuat PDF',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Center(
                              child: Text(
                                'File PDF tidak ditemukan.',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
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
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            controller.pageFractionText.value,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white),
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
              ],
            ),
          ),
        ),
      );
    } else {
      Get.snackbar('Error', 'Format file tidak didukung');
    }
  }

  Widget _buildRequirementCard({
    required Color iconColor,
    required String title,
    required String subtitle,
    required String validationStatus,
    required String validationNote,
    required bool isFileUploaded,
    required VoidCallback onUploadPressed,
    required String textUpload,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.picture_as_pdf, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Status Validasi",
                                style: TextStyle(fontSize: 14),
                              ),
                              Icon(
                                validationStatus == 'valid'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: validationStatus == 'valid'
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            children: [
                              const Text(
                                "Catatan",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                validationNote.isNotEmpty
                                    ? validationNote
                                    : "-",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isFileUploaded ? "Sudah Diupload" : "Belum Diupload",
                  style: TextStyle(
                    color: isFileUploaded ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Ink(
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                      onPressed: onUploadPressed,
                      child: Text(textUpload),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    if (status == 'Belum Lengkap' || status == 'Belum Diverifikasi') {
      color = Colors.red;
    } else {
      color = Colors.green;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
