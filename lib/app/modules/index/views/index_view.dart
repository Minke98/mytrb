import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/components/footer_copyright.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/profile/controllers/profile_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_value.dart' as responsive;
import 'package:shared_preferences/shared_preferences.dart'; // Tambah prefix

class IndexView extends GetView<IndexController> {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController = Get.find<ProfileController>();
  IndexView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bool isConnected = await ConnectionUtils.checkInternetConnection();
        if (!isConnected) {
          EasyLoading.showError("Tidak ada koneksi internet.");
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        String? userUc = prefs.getString("userUc");
        if (userUc != null) {
          await authController.fetchUserData(userUc);
        }
      },
      child: PopScope(
        canPop: false,
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          backdrop(context),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                bar(context),
                                const SizedBox(height: 25.0),
                                fullname(context),
                                const SizedBox(height: 4.0),
                                jurusanTingkat(context),
                                const SizedBox(height: 4.0),
                                title(context),
                                const SizedBox(height: 8.0),
                                menuGrid(context),
                                const SizedBox(height: 10.0),
                                signOffButton(context),
                                const SizedBox(height: 15.0),
                                const Text(
                                  "News",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Obx(() {
                                  if (controller.isLoading.value) {
                                    return const CircularProgressIndicator();
                                  }
                                  return buildCarousel();
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const FooterCopyright(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget backdrop(BuildContext context) {
    double baseHeight = 250 +
        (100 * controller.rowInWrap.value).toDouble(); // Tinggi diperpanjang
    double mobileHeight = baseHeight;
    double tabletHeight = baseHeight;

    // return Obx(() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: responsive.ResponsiveValue(
          // Pakai prefix "responsive"
          context,
          defaultValue: baseHeight,
          valueWhen: [
            responsive.Condition.largerThan(
                name: MOBILE, value: mobileHeight), // Pakai prefix
            responsive.Condition.largerThan(
                name: TABLET, value: tabletHeight), // Pakai prefix
          ],
        ).value,
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
      ),
    );
    // });
  }

  Widget bar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                profileDialog();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Icon(
                  Icons.account_circle,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20, // Tambah jarak 20 pixel dari atas
              ),
              child: Image.asset(
                "assets/images/logo3.png",
                width: 200, // Sesuaikan ukuran lebar
                height: 200, // Sesuaikan ukuran tinggi
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Icon(
                  Icons.notifications,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                await Get.toNamed(Routes.NEWS);
                controller.reInitializeHome();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget fullname(BuildContext context) {
    return Obx(() {
      final userData = authController.user;
      return Text(
        (userData['status'] == true)
            ? userData['data']['full_name'] ?? "UNKNOWN"
            : "UNKNOWN",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      );
    });
  }

  Widget jurusanTingkat(BuildContext context) {
    return Obx(() {
      final userData = authController.user;
      return Text(
        (userData['status'] == true)
            ? "${userData['data']['seafarer_code']} - ${userData['data']['label']}"
            : "UNKNOWN",
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      );
    });
  }

  Widget title(BuildContext context) {
    return Obx(() {
      final userData = authController.user;
      return Text(
        (userData['status'] == true)
            ? userData['data']['title'] ?? "UNKNOWN"
            : "UNKNOWN",
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontSize: 14),
      );
    });
  }

  Widget menuGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [BoxShadow(blurRadius: 0.1)],
      ),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 20,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            }

            List<Widget> menus =
                menuItemsBuilder(context, sigOn: controller.signStatus.value);
            var constraintWidth = constraint.maxWidth;
            int newInWrap = controller.menuGridCount ~/
                (constraintWidth / (100 * controller.scale.value)).floor();
            if (newInWrap < 1) {
              newInWrap = 1;
            }

            if (controller.rowInWrap.value != newInWrap) {
              controller.rowInWrap.value = newInWrap;
            }

            return Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 20,
              children: menus,
            );
          });
        },
      ),
    );
  }

  Widget signOffButton(BuildContext context) {
    return Obx(() {
      if (controller.signStatus.value) {
        return Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                // var result =
                await Get.toNamed(Routes.SIGN_OFF);
                // if (result != null && result is Map) {
                //   if (result['signoffSuccess'] == true) {
                //     await controller.reInitializeHome();
                //   }
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                "Sign Off",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  List<Widget> menuItemsBuilder(BuildContext context, {bool sigOn = false}) {
    final controller = Get.find<IndexController>();
    double menuWidth = 100;

    Widget signButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.toNamed(Routes.SIGN_ON)?.then((completion) {
                  if (completion != null && completion is Map) {
                    if (completion['signSuccess'] == true) {
                      controller.reInitializeHome();
                    }
                  }
                });
              },
              icon: Icon(
                Icons.assignment,
                size: 40,
                color: Colors.blue.shade900,
              ),
            ),
            const Text("Sign On",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget historyButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await historySelection();
              },
              icon: Icon(
                Icons.history,
                size: 40,
                color: Colors.blue.shade900,
              ),
            ),
            const Text("History",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget reportButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await Get.toNamed(Routes.REPORT);
                controller.initializeHome();
              },
              icon: Icon(
                Icons.assignment, // Ganti dengan ikon yang diinginkan
                size: 40,
                color: Colors.blue.shade900, // Atur warna ikon jika diperlukan
              ),
            ),
            const Text("Report",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget chatButton() {
      double menuWidth = 100;

      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                controller.openWhatsAppGroup();
                // await Get.toNamed(Routes.CHAT);
                // controller.initializeHome();
              },
              icon: Icon(
                Icons.chat,
                size: 40,
                color: Colors.blue.shade900,
              ),
            ),
            const Text("Chat",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget taskButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await Get.toNamed(Routes.TASK);
                controller.initializeHome();
              },
              icon: Icon(
                Icons.task,
                size: 40,
                color: Colors.blue.shade900,
              ),
            ),
            const Text("Task",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget examButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await Get.toNamed(Routes.EXAM);
                controller.initializeHome();
                // Get.to(
                //   () => const Exam(),
                //   transition:
                //       Transition.downToUp, // Efek slide dari bawah ke atas
                //   duration: const Duration(milliseconds: 500),
                // );
              },
              icon: Icon(
                Icons.quiz, // Ikon untuk kuis atau ujian
                size: 40,
                color: Colors.blue.shade900,
              ),
              iconSize: 48,
            ),
            const Text("Exam",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget logButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await Get.toNamed(Routes.LOGBOOK);
                controller.initializeHome();
              },
              icon: Icon(
                Icons.menu_book, // Ikon untuk log book
                size: 40,
                color: Colors.blue.shade900,
              ),
            ),
            const Text("Log Book",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget contactButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await Get.toNamed(Routes.CONTACT);
                controller.initializeHome();
              },
              icon: Icon(
                Icons.contact_page, // Ikon untuk contact
                size: 40,
                color: Colors.blue.shade900,
              ),
            ),
            const Text("Contact",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    Widget syncButton() {
      return SizedBox(
        width: menuWidth,
        child: Column(
          children: <Widget>[
            Obx(() {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (controller.isNeedSync.value) {
                        controller.startSyncing();
                      }
                    },
                    icon: Icon(
                      Icons.sync, // Ikon sinkronisasi
                      size: 40,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  controller.isNeedSync.value
                      ? Positioned(
                          top: -3,
                          right: -3,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            alignment: Alignment.center,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            }),
            const Text("Sync",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    // Tambahkan daftar menu lainnya
    List<Widget> menus = <Widget>[];

    if (!sigOn) {
      menus = <Widget>[
        signButton(), // Harus dipanggil dengan ()
        historyButton(),
        syncButton(),
      ];
    } else {
      menus = <Widget>[
        // signButton(),
        reportButton(),
        chatButton(),
        taskButton(),
        logButton(),
        contactButton(),
        syncButton(),
        examButton(),
      ];
    }

    return menus; // Pastikan selalu mengembalikan List<Widget>
  }

  Future<void> profileDialog() {
    return Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              profileDialogAvatar(Get.context!),
              InkWell(
                onTap: () {
                  Get.back(); // Tutup dialog sebelum pindah halaman
                  Get.toNamed(Routes.PROFILE);
                },
                child: _menuItem(Icons.person, "Profile"),
              ),
              const Divider(height: 1),
              InkWell(
                onTap: () {
                  Get.back(); // Tutup dialog sebelum pindah halaman
                  Get.toNamed(Routes.FAQ);
                },
                child: _menuItem(Icons.help, "Help"),
              ),
              const Divider(height: 1),
              InkWell(
                onTap: () {
                  Get.back(); // Tutup dialog sebelum konfirmasi logout
                  log("homePage: LOGOUT");
                  confirmLogout();
                },
                child: _menuItem(Icons.logout, "Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileDialogAvatar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      color: Colors.grey[800],
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Memastikan ukuran menyesuaikan isi
        children: [
          Obx(() {
            // Cek apakah ada foto yang tersedia
            String fotoPath =
                profileController.userData['data']?['foto']?.toString() ??
                    "assets/images/profile.jpg";

            return ClipOval(
              child: Image.file(
                File(fotoPath),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 10),
          Obx(() {
            final user = authController.user;
            if (user.isNotEmpty && user['status'] == true) {
              return Text(
                user['data']?['full_name'] ?? "UNKNOWN",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              );
            }
            return Text(
              "UNKNOWN",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 10),
          Obx(() {
            final user = authController.user;
            if (user.isNotEmpty && user['status'] == true) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${user['data']?['seafarer_code'] ?? '-'} - ${user['data']?['label'] ?? '-'}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['data']?['title'] ?? '-',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              );
            }
            return Text(
              "UNKNOWN",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            );
          }),
        ],
      ),
    );
  }

  Future<void> historySelection() async {
    Map userData = await UserRepository.getLocalUser(useAlternate: true);
    Map udata = {};

    if (userData['status'] == true) {
      udata = userData['data'];

      Get.dialog(
        Dialog(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.blue.shade900,
                  child: Center(
                    child: Text(
                      "History",
                      style: Get.textTheme.titleMedium!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: udata.isEmpty ||
                                      udata['sign_uc_local'] == null
                                  ? () {
                                      Get.defaultDialog(
                                        title: "Peringatan",
                                        middleText:
                                            "Anda belum pernah melakukan sign on. Silahkan sign on",
                                        confirm: TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text("OK"),
                                        ),
                                      );
                                    }
                                  : () {
                                      Get.toNamed("/task");
                                    },
                              icon: Icon(
                                Icons.task,
                                size: 40,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const Text("Task",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: udata.isEmpty ||
                                      udata['sign_uc_local'] == null
                                  ? () {
                                      Get.defaultDialog(
                                        title: "Peringatan",
                                        middleText:
                                            "Anda belum pernah melakukan sign on. Silahkan sign on",
                                        confirm: TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text("OK"),
                                        ),
                                      );
                                    }
                                  : () {
                                      Get.toNamed("/report");
                                    },
                              icon: Icon(
                                Icons.report,
                                size: 40,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const Text("Report",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    }
  }

  Widget buildCarousel() {
    return Obx(() {
      if (controller.news.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "There is currently no recent news available",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }

      return Column(
        children: [
          CarouselSlider(
            items: controller.news.map((item) {
              return Card(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.NEWS_DETAIL, arguments: {
                      "uc": item['uc'],
                      "title": item['title'],
                      "created_at": item['created_at_formated'],
                      "description": item['descriptionfull']
                    });
                    controller.initializeHome();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        item['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          const Divider(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item['created_at_formated'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 12),
                                children: [
                                  const TextSpan(
                                    text: "MyTRB News - ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                      text: item['description'] ?? '-',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            carouselController: controller.carouselController,
            options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              aspectRatio: 16 / 6,
              height: 150,
              onPageChanged: (index, reason) {
                controller.currentIndex.value =
                    index; // Pastikan ini memperbarui nilai
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.news.length, (index) {
              return Obx(() => GestureDetector(
                    onTap: () {
                      controller.carouselController.animateToPage(index);
                      controller.currentIndex.value = index;
                    },
                    child: Container(
                      width:
                          controller.currentIndex.value == index ? 16.0 : 10.0,
                      height:
                          controller.currentIndex.value == index ? 16.0 : 10.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.currentIndex.value == index
                            ? Colors.blue.shade900
                            : Colors.grey,
                      ),
                    ),
                  ));
            }),
          )
        ],
      );
    });
  }

  Future<void> confirmLogout() async {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: "Logout",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      middleText: "Are you sure you want to log out?",
      middleTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      barrierDismissible: false,
      radius: 15,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            minimumSize: const Size(100, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            authController.logout();
            Get.back();
          },
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(100, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Get.back(),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(icon, size: 25, color: Colors.black),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
