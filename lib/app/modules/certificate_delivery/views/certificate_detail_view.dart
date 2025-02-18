import 'package:mytrb/app/modules/certificate_delivery/controllers/certificate_delivery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateDetailView extends GetView<CertificateDeliveryController> {
  const CertificateDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Pengajuan Pengiriman Sertifikat'),
      ),
      body: Obx(() {
        // Jika data pengajuan ada, tampilkan rincian
        final detailCert = controller.detailCert.value;
        if (detailCert == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'No. Tiket',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    detailCert.tglPengajuan ?? '-',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                detailCert.noTiket ?? '-',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nama Penerima',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                detailCert.namaPengirim ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Alamat Penerima',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                detailCert.alamatRumah ?? '-',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'No. Telepon',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                detailCert.noTelepon ?? '-',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(detailCert.isPass),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _getStatusText(detailCert.isPass),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Daftar Sertifikat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.daftarSertifikatList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        '${index + 1}. ${controller.daftarSertifikatList[index].namaSertifikat ?? '-'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              // Tombol Konfirmasi Terima Sertifikat
              if (detailCert.isPass != '2')
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust border radius as needed
                      ),
                      padding: const EdgeInsets.all(0), // No padding
                    ),
                    onPressed: () {
                      showConfirmationDialog(context, detailCert.ucPengajuan);
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
                        borderRadius: BorderRadius.circular(
                            8), // Adjust border radius as needed
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 180,
                            minHeight: 40), // Set min width and height
                        alignment: Alignment.center,
                        child: const Text(
                          'Sudah Terima Sertifikat?',
                          style: TextStyle(
                            fontSize: 14, // Adjust font size as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // Mendapatkan warna berdasarkan status pengiriman
  Color _getStatusColor(String? isPass) {
    switch (isPass) {
      case '0':
        return Colors.blue;
      case '1':
        return Colors.orange;
      case '2':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Mendapatkan teks status berdasarkan is_pass
  String _getStatusText(String? isPass) {
    switch (isPass) {
      case '1':
        return 'Proses Pengiriman';
      case '2':
        return 'Sertifikat sudah diterima';
      default:
        return 'Pengajuan Pengiriman';
    }
  }

  Future<void> showConfirmationDialog(
      BuildContext context, String? ucPengajuan) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Perhatian!'),
          content: const Text(
            'Sudah Terima Sertifikat?\n\n'
            'Tekan Ya jika sudah menerima\n'
            'Tekan Cancel jika ingin menutup Dialog ini',
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Aksi ketika tombol Cancel ditekan
                    Get.back(); // Menutup dialog
                  },
                  child: const Text('Cancel'),
                ),
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
                          onPressed: () {
                            controller.updateStatus(ucPengajuan);
                          },
                          child: const Text('Ya'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
