import 'package:mytrb/app/data/models/detail_jadwal_diklat.dart';
import 'package:mytrb/app/data/models/diklat.dart';
import 'package:mytrb/app/data/models/jadwal_diklat.dart';
import 'package:mytrb/app/data/models/jadwal_pelaksanaan_detail.dart';
import 'package:mytrb/app/data/models/jenis_diklat.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/training/controllers/training_controller.dart';

class TrainingView extends GetView<TrainingController> {
  const TrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Diklat'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih dan Tentukan Jadwal Diklat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Kategori Dropdown
              Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<JenisDiklat>(
                    isExpanded: true,
                    hint: const Text(
                      'Pilih Kategori Diklat',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: controller.kategoriList.map((JenisDiklat kategori) {
                      return DropdownMenuItem<JenisDiklat>(
                        value: kategori,
                        child: Text(kategori.jenisDiklat!),
                      );
                    }).toList(),
                    value: controller.selectedKategori.value.isEmpty
                        ? null
                        : controller.kategoriList.firstWhere((kategori) =>
                            kategori.uc == controller.selectedKategori.value),
                    onChanged: (JenisDiklat? newValue) {
                      if (newValue != null) {
                        controller.selectedKategori.value = newValue.uc!;
                        controller.updateDiklatAndTanggal(newValue);
                        controller.selectedDiklat.value = '';
                        controller.selectedTanggal.value = '';
                        controller.diklatList.clear();
                        controller.tanggalList.clear();
                        controller.isChecked.value = false;
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

              // Diklat Dropdown
              Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<Diklat>(
                    isExpanded: true,
                    hint: Text(
                      controller.diklatLabelText.value,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: controller.diklatList.map((Diklat diklat) {
                      return DropdownMenuItem<Diklat>(
                        value: diklat,
                        child: Text(diklat.namaDiklat!),
                      );
                    }).toList(),
                    value: controller.selectedDiklat.value.isEmpty
                        ? null
                        : controller.diklatList.firstWhere((diklat) =>
                            diklat.uc == controller.selectedDiklat.value),
                    onChanged: (Diklat? newValue) {
                      if (newValue != null) {
                        controller.selectedDiklat.value = newValue.uc!;
                        controller.updateTanggalList(newValue);
                        controller.selectedTanggal.value = '';
                        controller.tanggalList.clear();
                        controller.isChecked.value = false;
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

              // Tanggal Dropdown
              Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<JadwalDiklat>(
                    isExpanded: true,
                    hint: Text(
                      controller.tanggalLabelText.value,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: controller.tanggalList.map((JadwalDiklat tanggal) {
                      final textToDisplay = tanggal.periode ?? 'Tidak Tersedia';
                      return DropdownMenuItem<JadwalDiklat>(
                        value: tanggal,
                        child: Text(textToDisplay),
                      );
                    }).toList(),
                    value: controller.selectedTanggal.value.isEmpty
                        ? null
                        : controller.tanggalList.firstWhere((tanggal) =>
                            tanggal.ucDiklatJadwal ==
                            controller.selectedTanggal.value),
                    onChanged: (JadwalDiklat? newValue) {
                      if (newValue != null) {
                        controller.selectedTanggal.value =
                            newValue.ucDiklatJadwal!;
                        controller.fetchDetailInfoJadwal(newValue);
                        controller.isChecked.value = false;
                        final selectedKategori = controller.jenisDiklat.value;
                        if (selectedKategori ==
                                'SIPENCATAR DIKLAT PELAUT - PEMBENTUKAN III' ||
                            selectedKategori == 'DIKLAT PENINGKATAN') {
                          controller.fetchJadwalPelaksanaan(newValue);
                        }
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
              // Form nomor sertifikat
              Obx(() {
                return controller.jenisDiklat.value ==
                        'ENDORSEMENT (PENERBITAN & PERPANJANG)'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: controller.nomorSertifikat,
                            decoration: InputDecoration(
                              labelText: 'No. Certificate',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(); // Jika bukan jenis diklat tersebut, tidak menampilkan apa pun
              }),
              Obx(() {
                final selectedTanggal = controller.selectedTanggal.value;
                return selectedTanggal.isNotEmpty
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Informasi Lengkap',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      )
                    : const SizedBox(); // Jika null, tampilkan widget kosong
              }),
              const SizedBox(height: 20),
              Obx(() {
                final selectedTanggal = controller.selectedTanggal.value;
                if (selectedTanggal.isEmpty) {
                  return const SizedBox();
                }

                final selectedJenisDiklat = controller.jenisDiklat.value;
                final detailJadwalDiklat =
                    controller.detailJadwalDiklatList.firstWhere(
                  (detailJadwalDiklat) =>
                      detailJadwalDiklat.ucDiklatJadwal == selectedTanggal,
                  orElse: () => DetailJadwalDiklat(),
                );
                final diklat = controller.diklatList.firstWhere(
                  (diklat) => diklat.uc == controller.selectedDiklat.value,
                  orElse: () => Diklat(),
                );

                final jadwalDiklat = controller.tanggalList.firstWhere(
                  (jadwalDiklat) =>
                      jadwalDiklat.ucDiklatJadwal ==
                      controller.selectedDiklat.value,
                  orElse: () => JadwalDiklat(),
                );

                if (selectedJenisDiklat.isEmpty) {
                  return const SizedBox();
                }

                // Gabungkan _buildCondition dan _buildDetailView
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailView(
                      selectedJenisDiklat,
                      detailJadwalDiklat,
                      diklat,
                      jadwalDiklat,
                    ), // Menampilkan detail diklat
                    const SizedBox(height: 30),
                    _buildCondition(),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 50,
          child: Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: controller.isChecked.value
                  ? () {
                      // Dapatkan data yang diperlukan di dalam onPressed
                      final selectedTanggal = controller.selectedTanggal.value;
                      final selectedJenisDiklat = controller.jenisDiklat.value;

                      if (selectedTanggal.isEmpty ||
                          selectedJenisDiklat.isEmpty) {
                        Get.snackbar(
                            'Info', 'Silakan pilih kategori yang sesuai');
                        return;
                      }

                      final detailJadwalDiklat =
                          controller.detailJadwalDiklatList.firstWhere(
                        (detailJadwalDiklat) =>
                            detailJadwalDiklat.ucDiklatJadwal ==
                            selectedTanggal,
                        orElse: () => DetailJadwalDiklat(),
                      );

                      if (selectedJenisDiklat ==
                              'SIPENCATAR DIKLAT PELAUT - PEMBENTUKAN III' ||
                          selectedJenisDiklat == 'DIKLAT PENINGKATAN') {
                        Get.toNamed(
                          Routes.DIKLAT_PROCEED,
                          arguments: {
                            'kategori': controller.selectedKategori.value,
                            'diklat': controller.selectedDiklat.value,
                            'tanggal': selectedTanggal,
                            'nomorSertifikat': controller.nomorSertifikat.value,
                            'programDiklat':
                                detailJadwalDiklat.namaDiklat ?? '-',
                            'statusPendaftaran':
                                detailJadwalDiklat.flagStatus ?? '-',
                            'tglPendaftaranDiTutup':
                                detailJadwalDiklat.pendaftaranAkhir ?? '-',
                            'biayaDiklat':
                                detailJadwalDiklat.biayaDiklat ?? '-',
                            'kouta': detailJadwalDiklat.kuota ?? '-',
                            'sisaKursi': detailJadwalDiklat.sisaKursi ?? '-',
                            'jadwalPelaksanaan':
                                detailJadwalDiklat.pelaksanaanMulai ?? '-',
                          },
                        );
                      } else {
                        controller.registDiklat();
                      }
                    }
                  : null, // Disable button jika isChecked false
              child: Ink(
                decoration: BoxDecoration(
                  gradient: controller.isChecked.value
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF002171),
                            Color(0xFF1565C0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )
                      : const LinearGradient(
                          colors: [
                            Color(0xFFB0BEC5),
                            Color(0xFFCFD8DC),
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
                  child: Text(
                    controller.jenisDiklat.value ==
                                'SIPENCATAR DIKLAT PELAUT - PEMBENTUKAN III' ||
                            controller.jenisDiklat.value == 'DIKLAT PENINGKATAN'
                        ? 'Lanjutkan'
                        : 'Daftar',
                    style: const TextStyle(
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

  Widget _buildCondition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ketentuan Pendaftaran
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ketentuan Pendaftaran Diklat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                  '1. Minimal jumlah peserta diklat per periode adalah 6 orang.'),
              SizedBox(height: 4),
              Text(
                  '2. Apabila kuota peserta belum terpenuhi, Peserta Diklat diberi kesempatan untuk Reschedule kembali Periode Diklat selanjutnya.'),
              SizedBox(height: 4),
              Text('3. Biaya pendaftaran tidak bisa dikembalikan.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Checklist
        Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.isChecked.value,
                  onChanged: (value) {
                    controller.isChecked.value = value ?? false;
                  },
                )),
            const Expanded(
              child: Text(
                'Dengan ini saya setuju dan memenuhi persyaratan dan ketentuan',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailView(
      String selectedJenisDiklat,
      DetailJadwalDiklat detailJadwalDiklat,
      Diklat diklat,
      JadwalDiklat jadwalDiklat) {
    switch (selectedJenisDiklat) {
      case 'ENDORSEMENT (PENERBITAN & PERPANJANG)':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Sertifikat: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              detailJadwalDiklat.namaDiklat ?? '-',
              maxLines: 2,
              softWrap: true, // Agar teks terbungkus dengan baik
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Status Pendaftaran: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: detailJadwalDiklat.flagStatus == 0
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                detailJadwalDiklat.flagStatus == 0 ? 'DITUTUP' : 'DIBUKA',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biaya Diklat: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.biayaDiklat ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 204,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lama Diklat: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      diklat.lamaDiklat ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kouta: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.kuota ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 238,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa Kursi: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.sisaKursi ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Persyaratan',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                showAffRequirementsDialog();
              },
              child: const Text(
                'Lihat Selengkapnya',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        );
      case 'REVALIDASI & RENEWAL ':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Sertifikat: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              detailJadwalDiklat.namaDiklat ?? '-',
              overflow: TextOverflow
                  .ellipsis, // Batasi jumlah baris, sesuaikan sesuai kebutuhan
              softWrap: true, // Agar teks terbungkus dengan baik
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Status Pendaftaran: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: detailJadwalDiklat.flagStatus == 0
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                detailJadwalDiklat.flagStatus == 0 ? 'DITUTUP' : 'DIBUKA',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biaya Diklat: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.biayaDiklat ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 169,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kuota: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.kuota ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa Kursi: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.sisaKursi ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 179,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Persyaratan',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        showAffRequirementsDialog();
                      },
                      child: const Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      case 'DIKLAT KETERAMPILAN PELAUT':
      case 'DIKLAT PEMUTAHIRAN (UPDATING)':
      case 'DIPLOMA III':
      case 'DIKLAT TOWING MASTER':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Diklat: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              detailJadwalDiklat.namaDiklat ?? '-',
              overflow: TextOverflow
                  .ellipsis, // Batasi jumlah baris, sesuaikan sesuai kebutuhan
              softWrap: true, // Agar teks terbungkus dengan baik
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Status Pendaftaran: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: detailJadwalDiklat.flagStatus == 0
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                detailJadwalDiklat.flagStatus == 0 ? 'DITUTUP' : 'DIBUKA',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lama Diklat: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      diklat.lamaDiklat ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 157,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biaya Diklat: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.biayaDiklat ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal Pelaksanaan: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.pelaksanaanMulai ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 103,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kuota: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.kuota ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa Kursi: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.sisaKursi ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 167,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Persyaratan',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        showAffRequirementsDialog();
                      },
                      child: const Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      case 'SIPENCATAR DIKLAT PELAUT - PEMBENTUKAN III':
      case 'DIKLAT PENINGKATAN':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Program Diklat: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              detailJadwalDiklat.namaDiklat ?? '-',
              overflow: TextOverflow
                  .ellipsis, // Batasi jumlah baris, sesuaikan sesuai kebutuhan
              softWrap: true, // Agar teks terbungkus dengan baik
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Status Pendaftaran: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: detailJadwalDiklat.flagStatus == 0
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                detailJadwalDiklat.flagStatus == 0 ? 'DITUTUP' : 'DIBUKA',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tgl. Pendaftaran Ditutup: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.pendaftaranAkhir ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 83,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biaya Diklat: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.biayaDiklat ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kouta ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.kuota ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 192,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa Kursi: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      detailJadwalDiklat.sisaKursi ?? '-',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Persyaratan',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        showAffRequirementsDialog();
                      },
                      child: const Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 120,
                ),
                Obx(
                  () {
                    String? title;
                    String? buttonText;
                    VoidCallback? onTapAction;

                    // Menentukan teks dan aksi berdasarkan jenis diklat
                    if (controller.jenisDiklat.value ==
                        'SIPENCATAR DIKLAT PELAUT - PEMBENTUKAN III') {
                      title = 'Jadwal Pelaksanaan';
                      buttonText = 'Lihat Selengkapnya';
                      onTapAction = () {
                        showJadwalDialog();
                      };
                    } else if (controller.jenisDiklat.value ==
                        'DIKLAT PENINGKATAN') {
                      title = 'Jadwal Kegiatan';
                      buttonText = 'Lihat Selengkapnya';
                      onTapAction = () {
                        showJadwalDialog();
                      };
                    }

                    if (title == null || buttonText == null) {
                      return const SizedBox();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: onTapAction,
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      default:
        return const SizedBox(); // Jika jenis diklat tidak dikenali, tidak menampilkan apa pun
    }
  }

  void showJadwalDialog() {
    String title = ''; // Default title

    // Tentukan judul berdasarkan jenis diklat
    if (controller.jenisDiklat.value ==
        'SIPENCATAR DIKLAT PELAUT - PEMBENTUKAN III') {
      title = 'Jadwal Pelaksanaan';
    } else if (controller.jenisDiklat.value == 'DIKLAT PENINGKATAN') {
      title = 'Jadwal Kegiatan';
    }

    Get.dialog(
      AlertDialog(
        title: Text(
          title, // Gunakan judul dinamis
          style: const TextStyle(fontSize: 15),
        ),
        content: SizedBox(
          width: 300, // Atur lebar dialog jika diperlukan
          child: Obx(() {
            // Menampilkan status pemanggilan API
            if (controller.apiCallStatus == ApiCallStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.apiCallStatus == ApiCallStatus.error) {
              return const Text('Gagal memuat data jadwal diklat.');
            } else if (controller.jadwalPelaksanaan.value != null) {
              final jadwal = controller.jadwalPelaksanaan.value!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (jadwal.category == "2") ...[
                      ..._buildSeleksi(jadwal.jadwalPelaksanaanDetail),
                    ],
                    if (jadwal.category == "3") ...[
                      ..._buildTingkatSeleksi(jadwal.jadwalPelaksanaanDetail),
                    ],
                  ],
                ),
              );
            } else {
              return const Text('Jadwal kegiatan tidak tersedia');
            }
          }),
        ),
        actions: [
          Container(
            width: double.infinity,
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
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSeleksi(JadwalPelaksanaanDetail? jadwal) {
    return [
      Text(
        'Tgl. Administrasi: ${jadwal?.seleksiAdmin ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text('Tgl. Kesehatan: ${jadwal?.seleksiKesehatan ?? '-'}',
          style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 8),
      Text('Tgl. Kesamaptaan: ${jadwal?.seleksiKesamaptaan ?? '-'}',
          style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 8),
      Text(
        'Tgl. Psikotes: ${jadwal?.seleksiPsikotes ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text('Tgl. Akademik: ${jadwal?.seleksiAkademik ?? '-'}',
          style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 8),
      Text('Tgl. Seleksi Wawancara: ${jadwal?.seleksiWawancara ?? '-'}',
          style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 8),
      Text(
          'Tgl. Pengumuman Hasil Sipencatar: ${jadwal?.seleksiPengumuman ?? '-'}',
          style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 8),
      Text(
          'Tgl. Daftar Ulang: ${jadwal?.seleksiDaftarUlangMulai ?? '-'} s/d ${jadwal?.seleksiDaftarUlangAkhir}',
          style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 8),
      Text('Tgl. Masuk Asrama: ${jadwal?.seleksiMasukAsrama ?? '-'}',
          style: const TextStyle(fontSize: 14)),
    ];
  }

  List<Widget> _buildTingkatSeleksi(JadwalPelaksanaanDetail? jadwal) {
    return [
      Text(
        'Tgl. Pendaftaran mulai: ${jadwal?.pendaftaranMulai} s/d ${jadwal?.pendaftaranAkhir}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8), // Tambahkan ruang
      Text(
        'Tgl. Seleksi: ${jadwal?.tingkatSeleksiMulai ?? '-'} s/d ${jadwal?.tingkatSeleksiAkhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Teori(Daring): ${jadwal?.tingkatTeoriMulai ?? '-'} s/d ${jadwal?.tingkatTeoriAkhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Ujian Tengah Diklat: ${jadwal?.tingkatUtdMulai ?? '-'} s/d ${jadwal?.tingkatUtdAkhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Praktek(Kampus): ${jadwal?.tingkatPraktekMulai ?? '-'} s/d ${jadwal?.tingkatPraktekAkhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Ujian Diklat: ${jadwal?.tingkatUdMulai ?? '-'} s/d ${jadwal?.tingkatUdAkhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Ujian Perbaikan: ${jadwal?.tingkatUpMulai ?? '-'} s/d ${jadwal?.tingkatUpAkhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Yudisium: ${jadwal?.tingkatYudisium ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Pelepasan: ${jadwal?.tingkatPelepasan ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. UKP ke 1: ${jadwal?.tingkatUkp1Mulai ?? '-'} s/d ${jadwal?.tingkatUkp1Akhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. UKP ke 2: ${jadwal?.tingkatUkp2Mulai ?? '-'} s/d ${jadwal?.tingkatUkp2Akhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. UKP ke 3: ${jadwal?.tingkatUkp3Mulai ?? '-'} s/d ${jadwal?.tingkatUkp3Akhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. UKP ke 4: ${jadwal?.tingkatUkp4Mulai ?? '-'} s/d ${jadwal?.tingkatUkp4Akhir ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Text(
        'Tgl. Pelepasan / Bon Voyage: ${jadwal?.tingkatPelepasan ?? '-'}',
        style: const TextStyle(fontSize: 14),
      ),
    ];
  }

  void showAffRequirementsDialog() {
    if (controller.persyaratanList.isEmpty) {
      Get.snackbar('Error', 'Tidak ada persyaratan yang tersedia');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Persyaratan',
          style: TextStyle(fontSize: 16),
        ),
        content: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.persyaratanList.map((persyaratan) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          persyaratan.persyaratan ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
        actions: [
          Container(
            width: double.infinity,
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
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
