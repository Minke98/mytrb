import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/profile/controllers/profile_controllers.dart';

class ChangePictureProfileView extends GetView<ProfileController> {
  ChangePictureProfileView({super.key});
  final IndexController indexController = Get.put(IndexController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.close(2);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("Ubah Foto Profil")),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfilePictureSection(context),
                  const SizedBox(height: 20),
                  _buildSaveButton(context),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildProfilePictureSection(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (controller.image.value != null ||
                indexController.currentUser.value?.usrPhoto != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  if (controller.image.value != null) {
                    return AlertDialog(
                      content: Image.file(
                        controller.image.value!,
                        fit: BoxFit.contain,
                      ),
                    );
                  } else {
                    return AlertDialog(
                      content: CachedNetworkImage(
                        imageUrl: Environment.urlfoto +
                            indexController.currentUser.value!.usrPhoto!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  }
                },
              );
            }
          },
          child: Obx(
            () {
              ImageProvider<Object> imageProvider;

              if (controller.image.value != null) {
                imageProvider = FileImage(controller.image.value!);
              } else if (indexController.currentUser.value?.usrPhoto != null) {
                imageProvider = NetworkImage(
                  Environment.urlfoto +
                      indexController.currentUser.value!.usrPhoto!,
                );
              } else {
                imageProvider = const AssetImage("assets/images/profile1.png");
              }

              return CircleAvatar(
                radius: 40,
                backgroundImage: imageProvider,
              );
            },
          ),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Camera'),
                        onTap: () {
                          Get.back();
                          controller.getImageFromCamera();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text('Gallery'),
                        onTap: () {
                          Get.back();
                          controller.getImageFromGallery();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text(
            'Ubah Foto',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Adjust border radius as needed
          ),
          padding: const EdgeInsets.all(0), // No padding
        ),
        onPressed: () {
          controller.changeFoto(context);
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
            borderRadius:
                BorderRadius.circular(8), // Adjust border radius as needed
          ),
          child: Container(
            constraints: const BoxConstraints(
                minWidth: 180, minHeight: 40), // Set min width and height
            alignment: Alignment.center,
            child: const Text(
              'Simpan Perubahan',
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 14, // Adjust font size as needed
              ),
            ),
          ),
        ),
      ),
    );
  }
}
