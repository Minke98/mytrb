import 'package:mytrb/app/data/models/news.dart';
import 'package:mytrb/app/data/models/news_certficate.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';
import 'package:mytrb/app/modules/news_certificate/controllers/news_certificate_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/html_parser_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexView extends GetView<IndexController> {
  IndexView({super.key});
  final NewsController newsController = Get.put(NewsController());
  final NewsCertificateController newsCertificateController =
      Get.put(NewsCertificateController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.dialog(
          AlertDialog(
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                },
                child: const Text(
                  'Batal',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.signout();
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return false;
      },
      child: GetBuilder<IndexController>(
        init: IndexController(),
        builder: (c) {
          c.loadUserInfo();
          return _buildWidget(context);
        },
      ),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
          child: Image.asset(
            Environment.poltekpelBanten, // Ganti sesuai path logo Anda
            height: 150,
            width: 150,
          ),
        ),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'mytrb ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Ukuran teks untuk "mytrb"
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Mobile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13, // Ukuran teks untuk "Mobile" lebih kecil
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF002171),
              Color(0xFF1565C0),
            ], // Ganti dengan warna gradient yang diinginkan
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20.0, 120.0 + 20.0, 16.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat datang,',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          controller.currentUser.value?.logName ?? '',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          controller.currentUser.value?.usrNik ?? '',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        profileDialog();
                      },
                      child: controller.currentUser.value?.usrPhoto != null
                          ? CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                Environment.urlfoto +
                                    controller.currentUser.value!.usrPhoto!,
                              ),
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 35,
                              backgroundImage:
                                  AssetImage("assets/images/profile1.png"),
                            ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                padding: const EdgeInsets.only(top: 35, bottom: 10),
                crossAxisCount: 4, // 2 kolom
                crossAxisSpacing: 4, // Jarak antar kolom
                mainAxisSpacing: 17, // Jarak antar baris
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildButtonColumn(
                    Colors.white,
                    Icons.edit_outlined,
                    'Daftar Diklat',
                    null,
                    () {
                      Get.toNamed(Routes.DIKLAT);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                  buildButtonColumn(
                    Colors.white,
                    Icons.upload_file_outlined,
                    'Upload',
                    'Persyaratan',
                    () {
                      Get.toNamed(Routes.UPLOAD_REQUIREMENTS);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                  buildButtonColumn(
                    Colors.white,
                    Icons.history_outlined,
                    'History',
                    null,
                    () {
                      Get.toNamed(Routes.HISTORY);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                  buildButtonColumn(
                    Colors.white,
                    Icons.question_answer_outlined,
                    'Kuesioner',
                    null,
                    () {
                      Get.toNamed(Routes.QUESTIONNAIRE);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                  buildButtonColumn(
                    Colors.white,
                    Icons.payment_outlined,
                    'Tagihan',
                    null,
                    () {
                      Get.toNamed(Routes.BILLING);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                  buildButtonColumn(
                    Colors.white,
                    Icons.assignment_outlined,
                    'Re-Schedule',
                    'Jadwal',
                    () {
                      Get.toNamed(Routes.SCHEDULE_CHANGE);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                  buildButtonColumn(
                    Colors.white,
                    Icons.info_outlined,
                    'Info Kursi',
                    null,
                    () {
                      Get.toNamed(Routes.SEAT_INFORMATION);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                  buildButtonColumn(
                    Colors.white,
                    Icons.local_offer_outlined,
                    'Pengiriman',
                    null,
                    () {
                      Get.toNamed(Routes.CERTIFICATE_DELIVERY);
                    },
                    iconColor: const Color(0xFF002171),
                  ),
                ],
              ),
              buildLatestAnnouncement(context),
              const SizedBox(height: 15),
              buildLatestCertificateAnnouncement(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLatestCertificateAnnouncement(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Sertifikat Terbit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.NEWS_CERTIFICATE);
                },
                child: const Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: Obx(() {
              if (newsCertificateController.newsCertificateList.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada sertifikat terbit terbaru',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final List<NewsCertificate> newsCertListCopy = List.unmodifiable(
                  newsCertificateController.newsCertificateList.take(5));

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newsCertListCopy.length,
                itemBuilder: (context, index) {
                  NewsCertificate newsCert = newsCertListCopy[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.NEWS_DETAIL, arguments: newsCert);
                    },
                    child: buildAnnouncementItem(
                      context,
                      newsCert.title ?? '',
                      HtmlParserUtil.parseHtmlString(newsCert.text ?? ''),
                      newsCert.createTime ?? '',
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildLatestAnnouncement(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Berita Terkini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.NEWS);
                },
                child: const Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: Obx(() {
              // Check if list is empty
              if (newsController.newsList.isEmpty) {
                return const Center(
                  child: Text('Tidak ada pengumuman terbaru',
                      style: TextStyle(color: Colors.white)),
                );
              }
              return ListView.separated(
                key: ValueKey(newsController.newsList.length),
                scrollDirection: Axis.horizontal,
                itemCount: newsController.newsList.toList().length < 5
                    ? newsController.newsList.toList().length
                    : 5, // Limit berdasarkan panjang list asli
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  News news =
                      newsController.newsList.toList()[index]; // Copy dari list
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.NEWS_DETAIL, arguments: news);
                    },
                    child: buildAnnouncementItem(
                      context,
                      news.title ?? '',
                      HtmlParserUtil.parseHtmlString(news.text ?? ''),
                      news.createTime ?? '',
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildButtonColumn(
    dynamic decoration,
    IconData icon,
    String? label1,
    String? label2,
    // Color? textColor,
    VoidCallback onPressed, {
    Color? iconColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: onPressed,
            child: Ink(
              decoration: BoxDecoration(
                gradient: decoration is LinearGradient ? decoration : null,
                color: decoration is Color ? decoration : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: 80), // Batasi lebar maksimal teks
                child: Text(
                  label1 ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Tambahkan elipsis
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: 80), // Batasi lebar maksimal teks
                child: Text(
                  label2 ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Tambahkan elipsis
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAnnouncementItem(
      BuildContext context, String title, String text, String additionalText) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002171),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                additionalText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> profileDialog() {
    return Get.dialog(
      WillPopScope(
        onWillPop: () async {
          Get.back(); // Menggunakan operator null-aware
          return true;
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Set border radius here
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profileDialogAvatar(Get.context!),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CHANGE_PICTURE_PROFILE);
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text("Ubah Foto Profil",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.BIODATA);
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text("Ubah Biodata",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.BIODATA_PARENT);
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.family_restroom_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text("Ubah Data Keluarga",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CHANGE_PASSWORD);
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text("Ubah PIN",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                // const Divider(height: 1),
                // InkWell(
                //   onTap: () {
                //     Get.toNamed(Routes.REPORT_EVALUATION);
                //   },
                //   child: Container(
                //     color: Colors.white,
                //     padding: const EdgeInsets.all(8.0),
                //     child: const Align(
                //       alignment: Alignment.centerLeft,
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.folder_open_outlined,
                //             size: 30,
                //             color: Colors.black,
                //           ),
                //           SizedBox(width: 10),
                //           Text("My Document",
                //               style:
                //                   TextStyle(color: Colors.black, fontSize: 14)),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                const Divider(height: 1),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.REPORT_EVALUATION);
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.report_problem_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text("Pengaduan",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                // const Divider(height: 1),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     color: Colors.white,
                //     padding: const EdgeInsets.all(8.0),
                //     child: const Align(
                //       alignment: Alignment.centerLeft,
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.help_outline,
                //             size: 30,
                //             color: Colors.black,
                //           ),
                //           SizedBox(width: 10),
                //           Text("Informasi Aplikasi",
                //               style:
                //                   TextStyle(color: Colors.black, fontSize: 14)),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                const Divider(
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        // contentPadding: EdgeInsets.all(16),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back(); // Tutup dialog
                            },
                            child: const Text(
                              'Batal',
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.signout();
                            },
                            child: const Text(
                              'Ok',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      barrierDismissible:
                          false, // Agar dialog tidak bisa ditutup dengan tap di luar
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text("Log Out",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
    );
  }

  Widget profileDialogAvatar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF002171),
            Color(0xFF1565C0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => controller.currentUser.value?.usrPhoto == null
              ? const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 100,
                  backgroundImage: AssetImage("assets/images/profile1.png"),
                )
              : CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                    Environment.urlfoto +
                        controller.currentUser.value!.usrPhoto!,
                  ),
                  onBackgroundImageError: (_, __) {
                    const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 100,
                      backgroundImage: AssetImage("assets/images/profile1.png"),
                    );
                  },
                )),
          const SizedBox(height: 10),

          // Nama Lengkap
          Obx(() => Text(
                controller.currentUser.value?.logName ?? 'Nama Tidak Ditemukan',
                style: Get.textTheme.bodyMedium!.copyWith(
                  color: Get.theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(height: 8),

          // Seafarers Code & Account ID
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    controller.currentUser.value?.usrNik ??
                        'NIK Tidak Ditemukan',
                    style: Get.textTheme.bodySmall!
                        .copyWith(color: Get.theme.colorScheme.onPrimary),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
