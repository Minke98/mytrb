import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/data/models/task_item.dart';
import 'package:mytrb/app/modules/task_checklist/controllers/task_checklist_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:url_launcher/url_launcher.dart';

class CheckItem extends GetView<TaskChecklistController> {
  final TaskItem item;
  final bool allowModify;

  CheckItem({super.key, required this.item, required this.allowModify});
  final _formKey = GlobalKey<FormState>();
  final _textKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: InkWell(
          onTap: () async {
            if (!item.checked.value && allowModify) {
              int? choice = await showModalBottomSheet<int>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                builder: (BuildContext contextt) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        buildListTile(context, "URL Video", 2),
                        buildListTile(context, "Photo", 1),
                      ],
                    ),
                  );
                },
              );

              if (choice == 2) {
                await showVideoURLDialog();
              } else if (choice == 1) {
                await takeAndUploadPhoto();
              }
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    item.checked.value
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: item.checked.value
                        ? Colors.green.shade700
                        : Colors.grey[500],
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.taskName ?? "Task Name Not Available",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (item.isAttachmentSaved) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => showViewAttachmentDialog(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.attach_file,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "View Attachment",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (item.checked.value) ...[
                          const SizedBox(height: 8),
                          buildApprovalButtons(context),
                        ]
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildApprovalButtons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (item.isApproved == 0) {
                    showStatusDialogInst(context);
                  } else if (item.isApproved == 1) {
                    showStatusDialogInst(context);
                  } else if (item.isApproved == 2) {
                    showStatusDialogInst(context);
                  }
                },
                child: const Text('Instructor Approval Status'),
              ),
              const SizedBox(height: 8),
              if (item.checked.value)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.instTime.isNotEmpty && item.isApproved == 1)
                      Text(item.instTime),
                    Text(
                      TaskRepository.statusText(item.isApproved),
                      style: TextStyle(
                        color: item.isApproved == 1 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.isLectApproved != 1)
                      Visibility(
                        visible: item.isApproved != 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          // onPressed: () {},
                          onPressed: item.isAttachmentSaved
                              ? () => Get.toNamed(Routes.TASK_APPROVAL,
                                      arguments: {
                                        "task_uc": item.uc,
                                        "task_name": item.taskName
                                      })
                              : () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('Attention',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        content: const Text(
                                            'Please fill in the attachment first.'),
                                        actions: <CupertinoDialogAction>[
                                          CupertinoDialogAction(
                                            child: const Text('OK'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          child: const Text(
                            "Approve",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (item.isLectApproved == 0) {
                    showStatusDialogLect(context);
                  } else if (item.isLectApproved == 1) {
                    showStatusDialogLect(context);
                  } else if (item.isLectApproved == 2) {
                    showStatusDialogLect(context);
                  }
                },
                child: const Text('Lecturer Approval Status'),
              ),
              const SizedBox(height: 8),
              if (item.checked.value)
                Text(
                  TaskRepository.statusText(item.isLectApproved),
                  style: TextStyle(
                    color: item.isLectApproved == 1 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void showViewAttachmentDialog(BuildContext context) async {
    if (item.isApproved == 1 && item.isAttachmentSaved == false) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: const Text("Empty Attachment"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 1,
                  color: Colors.black,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    "Attachment cannot be filled because it has already been approved"),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else {
      List<Widget> widgets = await attachmentWidgets();

      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Attachment Saved"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                ...widgets,
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Widget>> attachmentWidgets() async {
    List<Widget> widgets = [];

    Uint8List? foto;
    String? fotoLampiran = item.localPhoto;
    String? fotoUrl = item.attPhoto;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    if (fotoLampiran != null && fotoLampiran.isNotEmpty) {
      String networkUrl = fotoLampiran;
      if (fotoLampiran.startsWith(appDocPath)) {
        networkUrl = fotoLampiran.replaceFirst(appDocPath, '');
      }

      if (networkUrl.startsWith('http')) {
        widgets.add(Column(
          children: [
            const Text("The Result of the Photo:"),
            const SizedBox(height: 8),
            CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
              imageUrl: networkUrl,
              height: 400,
              width: 300,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: item.isApproved == 1
                  ? null
                  : () async {
                      takeAndUploadPhoto();
                      Get.close(1);
                    },
              child: const Text("Take Another Photo"),
            ),
          ],
        ));
      } else {
        String imagePath =
            Path.join(appDocPath, TASK_APPROVAL_FOTO_FOLDER, fotoLampiran);

        try {
          File imageFile = File(imagePath);

          if (imageFile.existsSync()) {
            foto = await imageFile.readAsBytes();

            widgets.add(Column(
              children: [
                const SizedBox(height: 8),
                Image.memory(
                  foto,
                  height: 400,
                  width: 300,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: item.isApproved == 1
                      ? null
                      : () async {
                          takeAndUploadPhoto();
                          Get.close(1);
                        },
                  child: const Text("Take Another Photo"),
                ),
              ],
            ));
          } else {
            if (kDebugMode) {
              print("File tidak ditemukan: $imagePath");
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print("Kesalahan saat memuat gambar: $e");
          }
        }
      }
    } else if (fotoUrl != null && fotoUrl.isNotEmpty) {
      if (!fotoUrl.startsWith('https://')) {
        fotoUrl = 'https://trsea.technomulti.co.id/trsea-api/$fotoUrl';
      }

      widgets.add(
        Column(
          children: [
            const Text(
              "The Result of the Photo :",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
              imageUrl: fotoUrl,
              height: 400,
              width: 300,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: item.isApproved == 1
                  ? null
                  : () async {
                      takeAndUploadPhoto();
                      Get.close(1);
                    },
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: isApproved == 1 ? Colors.grey : Colors.white,
              // ),
              child: const Text("Take Another Photo"),
            ),
          ],
        ),
      );
    } else if (item.url != null) {
      widgets.add(
        Column(
          children: [
            const Text(
              "URL Video :",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                final url = item.url!;
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar("Error",
                      "Tidak bisa membuka URL"); // Notifikasi jika gagal
                }
              },
              child: Text(
                item.url!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue, // Teks URL dengan warna biru
                  decoration: TextDecoration
                      .underline, // Agar terlihat seperti hyperlink
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: item.isApproved == 1
                  ? null
                  : () {
                      Get.close(1);
                      showVideoURLDialog(isEdit: true, itemUrl: item.url);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    item.isApproved == 1 ? Colors.grey : Colors.blue.shade900,
              ),
              child: Text(
                "Edit URL Video",
                style: TextStyle(
                  color: item.isApproved == 1
                      ? Colors.black54
                      : Colors.white, // Ubah warna teks sesuai kondisi
                ),
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  Future<void> takeAndUploadPhoto() async {
    final XFile? pickedFile =
        await controller.picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      controller.uploadFoto.value =
          File(pickedFile.path); // Konversi XFile ke File
      showUploadPhotoDialog(controller.uploadFoto.value!);
    }
  }

  void showUploadPhotoDialog(File imageFile) {
    Get.dialog(
      AlertDialog(
        title: const Text("The Result of the Photo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              imageFile,
              height: 400,
              width: 300,
              fit: BoxFit.fill,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.saveLampiran(item.uc, imageFile);
            },
            child: const Text(
              'Send',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> showVideoURLDialog({
    bool isEdit = false,
    String? itemUrl,
  }) async {
    String dialogTitle = isEdit ? "Edit Video URL" : "Enter Video URL";
    String buttonText = isEdit ? 'Update' : 'Send';

    // Sinkronisasi TextEditingController dengan nilai berdasarkan isEdit
    TextEditingController textController = TextEditingController(
      text: isEdit ? itemUrl ?? "" : controller.videoUrl.value,
    );

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            Uri? parsedUri = Uri.tryParse(textController.text);
            bool isValidUrl = parsedUri?.hasAbsolutePath == true;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    dialogTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: "Video URL",
                    hintText: "Enter the video link...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.link),
                  ),
                  onChanged: (text) {
                    // Update controller saat pengguna mengetik
                    controller.videoUrl.value = text;
                    // Perbarui validasi URL
                    setState(() {
                      parsedUri = Uri.tryParse(text);
                      isValidUrl = parsedUri?.hasAbsolutePath == true;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isValidUrl
                          ? () async {
                              await controller.saveUrlVideo(item.uc);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isValidUrl
                            ? Colors.blue.shade900
                            : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  Future<void> showStatusDialogLect(BuildContext context) async {
    String titleText = "";
    String lecturerName = item.appLectName ?? "-";
    String komentarText = item.appLectComment ?? "-";
    String? fotoLect = item.appLectComment;

    if (item.isLectApproved == 1) {
      titleText = "Approval Details";
    } else if (item.isLectApproved == 2) {
      titleText = "Rejection Details";
    } else if (item.isLectApproved == 0) {
      titleText = "Not Yet Approved";
    } else {
      titleText = "Invalid Status";
    }

    if (fotoLect != null &&
        fotoLect.isNotEmpty &&
        !fotoLect.startsWith('https://')) {
      fotoLect = 'https://trsea.technomulti.co.id/trsea-api/$fotoLect';
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(titleText),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1,
                color: Colors.black,
                margin: const EdgeInsets.only(bottom: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Tambahkan ini
                    children: [
                      const Text(
                        "Instructor's Name : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        lecturerName,
                        maxLines: 2, // Batas maksimal 5 baris
                        overflow: TextOverflow
                            .ellipsis, // Jika lebih, akan muncul "..."
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Tambahkan ini
                    children: [
                      const Text(
                        "Comment : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        komentarText,
                        maxLines: 5, // Batas maksimal 5 baris
                        overflow: TextOverflow
                            .ellipsis, // Jika lebih, akan muncul "..."
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (fotoLect != null && fotoLect.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Approval Photo:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                      imageUrl: fotoLect,
                      height: 400,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              if (fotoLect == null || fotoLect.isEmpty)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Approval Photo:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("The image is not available",
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> showStatusDialogInst(BuildContext context) async {
    String titleText = "";
    String instrukturName = item.appInstName ?? "-";
    String komentarText = item.appInstComment ?? "-";
    Uint8List? fotoInstruktur;

    if (item.isApproved == 1) {
      titleText = "Approval Details";
    } else if (item.isApproved == 2) {
      titleText = "Rejection Details";
    } else if (item.isApproved == 0) {
      titleText = "Not Yet Approved";
    } else {
      titleText = "Invalid Status";
    }

    String fotoApproval = item.appInstPhoto ?? "";
    String fotoApprovalFileName = item.appInstLocalPhoto ?? "";
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String imagePath =
        Path.join(appDocPath, TASK_APPROVAL_FOTO_FOLDER, fotoApprovalFileName);

    if (fotoApproval.isNotEmpty && !fotoApproval.startsWith('https://')) {
      fotoApproval = 'https://trsea.technomulti.co.id/trsea-api/$fotoApproval';
    }

    String networAppUrl = fotoApprovalFileName;
    if (fotoApprovalFileName.startsWith(appDocPath)) {
      networAppUrl = fotoApprovalFileName.replaceFirst(appDocPath, '');
    }

    if (fotoApprovalFileName.isNotEmpty) {
      try {
        File imageFile = File(imagePath);
        if (imageFile.existsSync()) {
          fotoInstruktur = await imageFile.readAsBytes();
        } else {
          if (kDebugMode) {
            print("File tidak ditemukan: $imagePath");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Kesalahan saat memuat gambar: $e");
        }
      }
    }
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (fotoInstruktur != null && fotoInstruktur.isNotEmpty) {
          return CupertinoAlertDialog(
            title: Text(titleText),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: Colors.black,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini
                  children: [
                    const Text(
                      "Instructor's Name : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      instrukturName,
                      maxLines: 2, // Batas maksimal 5 baris
                      overflow: TextOverflow
                          .ellipsis, // Jika lebih, akan muncul "..."
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini
                  children: [
                    const Text(
                      "Comment : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      komentarText,
                      maxLines: 6, // Batas maksimal 5 baris
                      overflow: TextOverflow
                          .ellipsis, // Jika lebih, akan muncul "..."
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Approval Photo :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 400,
                    width: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(fotoInstruktur),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        } else if (networAppUrl.startsWith('http')) {
          return CupertinoAlertDialog(
            title: Text(titleText),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: Colors.black,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Tambahkan ini
                      children: [
                        const Text(
                          "Instructor's Name : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          instrukturName,
                          maxLines: 2, // Batas maksimal 5 baris
                          overflow: TextOverflow
                              .ellipsis, // Jika lebih, akan muncul "..."
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Tambahkan ini
                      children: [
                        const Text(
                          "Comment : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          komentarText,
                          maxLines: 5, // Batas maksimal 5 baris
                          overflow: TextOverflow
                              .ellipsis, // Jika lebih, akan muncul "..."
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Approval Photo :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: networAppUrl,
                  height: 400,
                  width: 250,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        } else if (fotoApproval.isNotEmpty) {
          return CupertinoAlertDialog(
            title: Text(titleText),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: Colors.black,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Tambahkan ini
                      children: [
                        const Text(
                          "Instructor's Name : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          instrukturName,
                          maxLines: 2, // Batas maksimal 5 baris
                          overflow: TextOverflow
                              .ellipsis, // Jika lebih, akan muncul "..."
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Tambahkan ini
                      children: [
                        const Text(
                          "Comment : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          komentarText,
                          maxLines: 5, // Batas maksimal 5 baris
                          overflow: TextOverflow
                              .ellipsis, // Jika lebih, akan muncul "..."
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Approval Photo :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: fotoApproval,
                  height: 400,
                  width: 250,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text(titleText),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: Colors.black,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Tambahkan ini
                      children: [
                        const Text(
                          "Instructor's Name : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          instrukturName,
                          maxLines: 2, // Batas maksimal 5 baris
                          overflow: TextOverflow
                              .ellipsis, // Jika lebih, akan muncul "..."
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Tambahkan ini
                      children: [
                        const Text(
                          "Comment : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          komentarText,
                          maxLines: 5, // Batas maksimal 5 baris
                          overflow: TextOverflow
                              .ellipsis, // Jika lebih, akan muncul "..."
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("Approval Photo:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("The image is not available",
                    style: TextStyle(color: Colors.red)),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>?> addNotes(
      {String error = "", String initText = ""}) async {
    controller.notes.text = initText;

    return await Get.generalDialog(
      barrierDismissible: false,
      barrierLabel: "Add Note",
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(animation),
          child: WillPopScope(
            onWillPop: () async {
              controller.notes.text = "";
              return true;
            },
            child: Dialog(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          key: _textKey,
                          maxLines: null,
                          controller: controller.notes,
                          decoration: const InputDecoration(labelText: "Notes"),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Fill in Notes";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.notes.text = "";
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.colorScheme.error,
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    Get.back(result: {
                                      "status": true,
                                      "notes": controller.notes.text
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListTile(BuildContext context, String title, int value) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context, value);
      },
    );
  }
}
