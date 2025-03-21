import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  spacer(height: 5),
                  avatar(context),
                  controller.isEditing.value
                      ? changeAvatar(context)
                      : const SizedBox.shrink(),
                  spacer(height: 20),
                  nikField(context),
                  seaFarerField(context),
                  fullNameField(context),
                  genderField(context),
                  kewarganegaraanField(context),
                  tempatLahirField(context),
                  tanggalLahirField(context),
                  controller.isEditing.value
                      ? emailField(context)
                      : const SizedBox.shrink(),
                  spacer(),
                  controller.isEditing.value
                      ? oldPasswordField(context)
                      : const SizedBox.shrink(),
                  spacer(),
                  controller.isEditing.value
                      ? newPassword(context)
                      : const SizedBox.shrink(),
                  spacer(),
                  controller.isEditing.value
                      ? confirmPassword(context)
                      : const SizedBox.shrink(),
                  spacer(
                      height:
                          20), // Beri ruang agar tidak tertutup bottom button
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar ukuran mengikuti isi
              children: [
                controller.isEditing.value
                    ? saveProfileBtn(context)
                    : ubahProfileBtn(context),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget avatar(BuildContext context) {
    return Obx(() {
      // Cek apakah ada foto baru yang dipilih
      if (controller.image.value != null) {
        return CircleAvatar(
          radius: 72,
          backgroundImage: FileImage(controller.image.value!),
        );
      }

      // Pastikan foto dalam bentuk String
      String fotoPath = controller.userData['data']?['foto']?.toString() ??
          "assets/images/profile.jpg";

      return CircleAvatar(
        radius: 72,
        child: ClipOval(
          child: fotoPath.startsWith("assets")
              ? Image.asset(
                  fotoPath,
                  fit: BoxFit.cover,
                  key: UniqueKey(),
                )
              : Image.file(
                  File(fotoPath),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
        ),
      );
    });
  }

  Widget changeAvatar(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("Change Profile Photo"),
      ),
    );
  }

  Widget nikField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        return TextFormField(
          style: const TextStyle(color: Colors.black),
          enabled: false,
          controller: controller.nikController,
          decoration: InputDecoration(
            labelStyle: controller.formTextStyle,
            labelText: "NIK :",
            border: InputBorder.none,
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget seaFarerField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        return TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: controller.seafererCodeController,
          enabled: false,
          decoration: InputDecoration(
            labelStyle: controller.formTextStyle,
            labelText: "Seafarer Code :",
            border: InputBorder.none,
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget fullNameField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        return TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: controller.fullNameController,
          enabled: false,
          decoration: InputDecoration(
            labelStyle: controller.formTextStyle,
            labelText: "Name :",
            border: InputBorder.none,
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget genderField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        return TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: controller.genderController,
          enabled: false,
          decoration: InputDecoration(
            labelStyle: controller.formTextStyle,
            labelText: "Gender :",
            border: InputBorder.none,
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget emailField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        return TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: controller.emailController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            enabled: controller.isEditing.value,
            labelStyle: controller.formTextStyle,
            labelText: "Email :",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (input) => input!.isValidEmail() ? null : "Email Invalid",
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget kewarganegaraanField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        return TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: controller.nationalityController,
          decoration: InputDecoration(
            enabled: false,
            labelStyle: controller.formTextStyle,
            labelText: "Nationality :",
            border: InputBorder.none,
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget tempatLahirField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        return TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: controller.tempatLahirController,
          decoration: InputDecoration(
            enabled: false,
            labelStyle: controller.formTextStyle,
            labelText: "Place of Birth :",
            border: InputBorder.none,
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget tanggalLahirField(BuildContext context) {
    return Obx(() {
      if (controller.userData.isNotEmpty) {
        var bornDate = controller.userData['data']['born_date'];
        DateTime? signOnDate;

        // Inisialisasi tanggal jika format sesuai
        if (bornDate != null && bornDate != "0000-00-00") {
          try {
            signOnDate = DateTime.parse(bornDate);
          } catch (e) {
            print('Error parsing tanggal lahir: $e');
            return const Text('Error parsing tanggal lahir');
          }
        }

        // Cek apakah signOnDate tetap null atau tidak
        controller.tanggalLahirController.text =
            (signOnDate == null) ? "-" : DateFormat.yMMMMd().format(signOnDate);

        return TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: controller.tanggalLahirController,
          decoration: InputDecoration(
            enabled: false,
            labelStyle: controller.formTextStyle,
            labelText: "Date of Birth :",
            border: InputBorder.none,
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget oldPasswordField(BuildContext context) {
    return Obx(() {
      return TextFormField(
        style: const TextStyle(color: Colors.black),
        obscureText: !controller.passwordVisible.value,
        controller: controller.oldPasswordController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "Old Password",
          hintText: "Enter Old Password",
          labelStyle: controller.formTextStyle,
          suffixIcon: IconButton(
            onPressed: () {
              controller.passwordVisible.value =
                  !controller.passwordVisible.value;
            },
            icon: Icon(
              controller.passwordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (controller.newPasswordController.text.isNotEmpty) {
              return "Please Enter the Old Password to Change the Password";
            }
          }
          return null;
        },
      );
    });
  }

  Widget newPassword(BuildContext context) {
    return Obx(() {
      return TextFormField(
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        obscureText: !controller.newPasswordVisible.value,
        controller: controller.newPasswordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "New Password",
          hintText: "Enter New Password",
          labelStyle: controller.formTextStyle,
          suffixIcon: IconButton(
            onPressed: () {
              controller.newPasswordVisible.value =
                  !controller.newPasswordVisible.value;
            },
            icon: Icon(
              controller.newPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password tidak boleh kosong";
          }
          if (value.length < 6 &&
              controller.oldPasswordController.text.isNotEmpty) {
            return "Minimum 6 Karakter";
          }
          return null;
        },
      );
    });
  }

  Widget confirmPassword(BuildContext context) {
    return Obx(() {
      return TextFormField(
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        obscureText: !controller.retypePasswordVisible.value,
        controller: controller.confirmNewPasswordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "Retype Password",
          hintText: "Confirm Password",
          labelStyle: controller.formTextStyle,
          suffixIcon: IconButton(
            onPressed: () {
              controller.retypePasswordVisible.value =
                  !controller.retypePasswordVisible.value;
            },
            icon: Icon(
              controller.retypePasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password confirmation is required";
          }
          if (value != controller.newPasswordController.text) {
            return "The passwords do not match";
          }
          return null;
        },
      );
    });
  }

  Widget ubahProfileBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.editProfile(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text("Edit Profile"),
    );
  }

  Widget saveProfileBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.updateProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              minimumSize: const Size.fromHeight(55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }

  Widget spacer({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }
}
