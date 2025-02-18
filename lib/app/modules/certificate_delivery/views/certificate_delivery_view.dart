import 'package:mytrb/app/modules/certificate_delivery/controllers/certificate_delivery_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateDeliveryView extends GetView<CertificateDeliveryController> {
  const CertificateDeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengiriman Sertifikat'),
      ),
      body: Obx(() {
        if (controller.pengirimansList.isEmpty) {
          // Tampilkan keterangan jika pengirimanList kosong
          return Center(
            child: Text(
              'Tidak ada pengiriman yang tersedia',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          );
        } else {
          // Jika tidak kosong, tampilkan ListView
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: controller.pengirimansList.length,
              itemBuilder: (context, index) {
                final pengiriman = controller.pengirimansList[index];
                return GestureDetector(
                  onTap: () {
                    controller.fetchCertDetail(pengiriman.ucPengajuan);
                    Get.toNamed(Routes.CERTIFICATE_DETAIL);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'No. Tiket : ',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(width: 80),
                              Expanded(
                                child: Text(
                                  pengiriman.tglPengajuan ?? '-',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            pengiriman.noTiket ?? '-',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Sertifikat yang Dikirim
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Jumlah Sertifikat: ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      pengiriman.jmlSertifikat != null
                                          ? '${pengiriman.jmlSertifikat} Lembar'
                                          : '-',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 80),
                              // Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 17),
                                    const Text(
                                      'Status : ',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color:
                                            _getStatusColor(pengiriman.isPass),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        _getStatusText(pengiriman
                                            .isPass), // Mengambil teks status
                                        style: const TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
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
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.fetchFormCert();
          controller.fetchCertificateTypes();
          _showFormDialog(context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

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

  String _getStatusText(String? isPass) {
    switch (isPass) {
      case '0':
        return 'Pengajuan Pengiriman';
      case '1':
        return 'Proses Pengiriman';
      case '2':
        return 'Sertifikat sudah diterima';
      default:
        return 'Unknown'; // Status tidak dikenal
    }
  }

  void showFileUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upload Bukti Penerimaan'),
                  GestureDetector(
                    onTap: () {
                      Get.back(); // Tutup dialog saat ikon close diketuk
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.black,
              ), // Divider di bawah judul
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Foto'),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: controller.selectedFileName.value.isNotEmpty
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
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Aksi ketika file diupload
                Get.back(); // Tutup dialog
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Form Pengiriman Sertifikat'),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.black,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.certificateTypes.isNotEmpty)
                  const Text(
                    'List Sertifikat',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                const SizedBox(height: 8),
                Obx(() {
                  // Menyesuaikan tinggi SizedBox berdasarkan ada tidaknya data
                  double boxHeight =
                      controller.certificateTypes.isEmpty ? 50 : 200;

                  return SizedBox(
                    height: boxHeight,
                    child: SingleChildScrollView(
                      child: controller.certificateTypes.isEmpty
                          ? const Center(
                              child: Text(
                                'Tidak ada sertifikat yang tersedia',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                controller.certificateTypes.length,
                                (index) {
                                  final type =
                                      controller.certificateTypes[index];
                                  return Obx(
                                    () => CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value:
                                          controller.isCheckedList[index].value,
                                      activeColor: Colors.black,
                                      title: Text(type.sertifikat ?? ''),
                                      onChanged: (bool? value) {
                                        controller.isCheckedList[index].value =
                                            value ?? false;
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.penerimaController,
                  decoration: InputDecoration(
                    labelText: 'Input Penerima',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.noTeleponController,
                  decoration: InputDecoration(
                    labelText: 'Input No. Telepon',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.alamatController,
                  decoration: InputDecoration(
                    labelText: 'Input Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
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
                        controller.pengajuanCert();
                      },
                      child: const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
