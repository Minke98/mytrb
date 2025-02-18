import 'package:mytrb/app/modules/upload_requirements/controllers/upload_requirements_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadRequirementsView extends GetView<UploadRequirementsController> {
  const UploadRequirementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pendaftaran Diklat'),
        ),
        body: Obx(
          () {
            var sortedList = controller.pendaftaranDiklatList
                .where((diklat) => diklat.tanggalDaftar != null)
                .toList()
              ..sort((a, b) => b.tanggalDaftar!.compareTo(a.tanggalDaftar!));

            if (sortedList.isEmpty) {
              return const Center(
                child: Text(
                  'Data tidak tersedia',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: sortedList.length,
              itemBuilder: (context, index) {
                final diklat = sortedList[index];
                return GestureDetector(
                  onTap: () {
                    controller.fetchListPersyaratan(diklat.uc!);
                    Get.toNamed(Routes.REQUIREMENTS_DETAIL);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: const Color(0xFFFFF4E1),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('No. Regis: ${diklat.noPendaftaran}'),
                              Text(formatDateTime(diklat.tanggalDaftar)),
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
                            'Periode: ${diklat.periode}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Tgl. Pendaftaran Tutup: ${diklat.pelaksanaanAkhir != null ? formatDate(diklat.pelaksanaanAkhir) : 'Belum Ditetapkan'}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Status Persyaratan',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  _buildStatusChip(
                                    diklat.statusSyarat == '0'
                                        ? 'Belum Lengkap'
                                        : 'Lengkap',
                                  ),
                                ],
                              ),
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
                                        ? 'Belum Divalidasi'
                                        : 'Sudah Divalidasi',
                                  ),
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
            );
          },
        ));
  }

  Widget _buildStatusChip(String status) {
    Color color;
    if (status == 'Belum Lengkap' || status == 'Belum Divalidasi') {
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
