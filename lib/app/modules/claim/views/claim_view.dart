import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/modules/claim/controllers/claim_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:validators/sanitizers.dart';

class ClaimView extends GetView<ClaimController> {
  final formKey = GlobalKey<FormState>();
  ClaimView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          "Claim Seafarer",
          style: TextStyle(fontSize: 16),
        )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                seafarerCode(context),
                const SizedBox(height: 10),
                seafarerButton(context),
                const SizedBox(height: 40),
                // Menambahkan jarak yang lebih kecil
                Obx(() {
                  if (controller.seafarerAvailable.value) {
                    return registerForm(context);
                  }
                  return const SizedBox.shrink();
                }),

                // Error Message
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Success Snackbar & Redirect
                Obx(() {
                  if (controller.isSuccess.value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.snackbar(
                        "Claim Successful",
                        "Please Login",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.blue.shade800,
                        colorText: Colors.white,
                      );

                      Future.delayed(const Duration(seconds: 2), () {
                        Get.offNamed(Routes.LOGIN);
                      });
                    });
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget seafarerCode(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black, // Warna teks input
      ),
      controller: controller.seafarerController,
      decoration: InputDecoration(
        labelText: "Seafarer",
        hintText: "Input Seafarer Code",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.black), // Ganti warna fokus
        ),
      ),
    );
  }

  Widget seafarerButton(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isChecking.value
            ? null
            : () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.checkSeafarer();
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(55),
          backgroundColor: controller.isChecking.value
              ? Colors.grey
              : Colors.blue.shade800, // Warna biru saat tombol aktif
          splashFactory: controller.isChecking.value
              ? NoSplash.splashFactory
              : InkSplash.splashFactory, // Efek splash saat aktif
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: controller.isChecking.value
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : const Text(
                "Check Seafarer",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
      ),
    );
  }

  Widget registerForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => TextFormField(
                style: const TextStyle(
                  color: Colors.grey, // Warna teks input
                ),
                controller: TextEditingController(text: controller.nama.value),
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Colors.black), // Ganti warna fokus
                  ),
                ),
                enabled: false,
              )),
          const SizedBox(height: 10),
          Obx(() => TextFormField(
                style: const TextStyle(
                  color: Colors.grey, // Warna teks input
                ),
                controller: TextEditingController(text: controller.nik.value),
                decoration: InputDecoration(
                  labelText: "NIK",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Colors.black), // Ganti warna fokus
                  ),
                ),
                enabled: false,
              )),
          const SizedBox(height: 10),
          TextFormField(
            style: const TextStyle(
              color: Colors.black, // Warna teks input
            ),
            cursorColor: Colors.black,
            keyboardType: TextInputType.emailAddress,
            controller: controller.emailController,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Input Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (input) =>
                input!.isValidEmail() ? null : "Email Invalid",
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: const TextStyle(
              color: Colors.black, // Warna teks input
            ),
            cursorColor: Colors.black,
            controller: controller.usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              hintText: "Input Username (Minimum 5 Characters)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (value) {
              var vl = trim(value!);
              return vl.minimumChar(length: 5) ? null : "Minimum 5 Characters";
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: const TextStyle(
              color: Colors.black, // Warna teks input
            ),
            cursorColor: Colors.black,
            obscureText: !controller.passwordVisible.value,
            controller: controller.passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Input Password (Minimum 6 Characters)",
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (value) {
              return value!.minimumChar(length: 6)
                  ? null
                  : "Minimum 6 Characters";
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: const TextStyle(
              color: Colors.black, // Warna teks input
            ),
            cursorColor: Colors.black,
            obscureText: !controller.retypePasswordVisible.value,
            controller: controller.confirmpasswordController,
            decoration: InputDecoration(
              labelText: "Retype Password",
              hintText: "Confirm Password",
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (value) {
              var vl = value.toString();
              if (!vl.minimumChar(length: 6)) {
                return "Minimum 6 Characters";
              }
              if (vl != controller.passwordController.text) {
                return "Password Mismatch";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: controller.emailController.text.isEmpty ||
                        controller.usernameController.text.isEmpty ||
                        controller.passwordController.text.isEmpty ||
                        controller.confirmpasswordController.text.isEmpty
                    ? Colors.grey
                    : Colors.blue.shade800,
                splashFactory: controller.emailController.text.isEmpty ||
                        controller.usernameController.text.isEmpty ||
                        controller.passwordController.text.isEmpty ||
                        controller.confirmpasswordController.text.isEmpty
                    ? NoSplash.splashFactory
                    : InkSplash.splashFactory,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: controller.emailController.text.isEmpty ||
                      controller.usernameController.text.isEmpty ||
                      controller.passwordController.text.isEmpty ||
                      controller.confirmpasswordController.text.isEmpty
                  ? null
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (formKey.currentState!.validate()) {
                        controller.claim();
                      }
                    },
              child: const Text(
                "Claim",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget registerForm(BuildContext context) {
  //   return Obx(() {
  //     if (controller.isLoading.value) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //     return SlideTransition(
  //       position: controller.animation,
  //       child: Form(
  //         key: formKey,
  //         child: ResponsiveRowColumn(
  //           layout: ResponsiveRowColumnType.COLUMN,
  //           children: [
  //             spacer(context, height: 15),
  //             const ResponsiveRowColumnItem(rowFlex: 0, child: Divider()),
  //             ResponsiveRowColumnItem(
  //               rowFlex: 1,
  //               child: TextFormField(
  //                 keyboardType: TextInputType.name,
  //                 initialValue: seafarerController.nama.value,
  //                 decoration: const InputDecoration(labelText: "Name"),
  //                 enabled: false,
  //               ),
  //             ),
  //             spacer(context),
  //             ResponsiveRowColumnItem(
  //               rowFlex: 1,
  //               child: TextFormField(
  //                 initialValue: seafarerController.nik.value,
  //                 decoration: const InputDecoration(labelText: "NIK"),
  //                 enabled: false,
  //               ),
  //             ),
  //             spacer(context),
  //             ResponsiveRowColumnItem(
  //               rowFlex: 1,
  //               child: TextFormField(
  //                 keyboardType: TextInputType.emailAddress,
  //                 controller: controller.emailController,
  //                 decoration: const InputDecoration(
  //                   labelText: "Email",
  //                   hintText: "Input Email",
  //                 ),
  //                 validator: (input) =>
  //                     input!.isValidEmail() ? null : "Email Invalid",
  //               ),
  //             ),
  //             spacer(context),
  //             ResponsiveRowColumnItem(
  //               rowFlex: 1,
  //               child: TextFormField(
  //                 controller: controller.usernameController,
  //                 decoration: const InputDecoration(
  //                   labelText: "Username",
  //                   hintText: "Input Username (Minimum 5 Characters)",
  //                 ),
  //                 validator: (value) {
  //                   var vl = trim(value!);
  //                   return vl.minimumChar(length: 5)
  //                       ? null
  //                       : "Minimum 5 Characters";
  //                 },
  //               ),
  //             ),
  //             spacer(context),
  //             ResponsiveRowColumnItem(
  //               rowFlex: 1,
  //               child: TextFormField(
  //                 obscureText: !controller.passwordVisible.value,
  //                 controller: controller.passwordController,
  //                 decoration: InputDecoration(
  //                   labelText: "Password",
  //                   hintText: "Input Password (Minimum 6 Characters)",
  //                   suffixIcon: IconButton(
  //                     onPressed: () {
  //                       controller.passwordVisible.value =
  //                           !controller.passwordVisible.value;
  //                     },
  //                     icon: Icon(
  //                       controller.passwordVisible.value
  //                           ? Icons.visibility
  //                           : Icons.visibility_off,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ),
  //                 validator: (value) {
  //                   return value!.minimumChar(length: 6)
  //                       ? null
  //                       : "Minimum 6 Characters";
  //                 },
  //               ),
  //             ),
  //             spacer(context),
  //             ResponsiveRowColumnItem(
  //               rowFlex: 1,
  //               child: TextFormField(
  //                 obscureText: !controller.retypePasswordVisible.value,
  //                 controller: controller.confirmpasswordController,
  //                 decoration: InputDecoration(
  //                   labelText: "Retype Password",
  //                   hintText: "Confirm Password",
  //                   suffixIcon: IconButton(
  //                     onPressed: () {
  //                       controller.retypePasswordVisible.value =
  //                           !controller.retypePasswordVisible.value;
  //                     },
  //                     icon: Icon(
  //                       controller.retypePasswordVisible.value
  //                           ? Icons.visibility
  //                           : Icons.visibility_off,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ),
  //                 validator: (value) {
  //                   var vl = value.toString();
  //                   if (!vl.minimumChar(length: 6)) {
  //                     return "Minimum 6 Characters";
  //                   }
  //                   if (vl != controller.passwordController.text) {
  //                     return "Password Mismatch";
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ),
  //             spacer(context),
  //             ResponsiveRowColumnItem(
  //               rowFlex: 1,
  //               child: ElevatedButton(
  //                 onPressed: () async {
  //                   if (formKey.currentState!.validate()) {
  //                     controller.claim();
  //                   }
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                     minimumSize: const Size.fromHeight(55)),
  //                 child: const Text("Claim"),
  //               ),
  //             ),
  //             spacer(context, height: 20),
  //           ],
  //         ),
  //       ),
  //     );
  //     // }
  //     // return const SizedBox.shrink();
  //   });
  // }

  ResponsiveRowColumnItem spacer(BuildContext context, {double height = 10}) {
    return ResponsiveRowColumnItem(
      rowFlex: 0,
      child: SizedBox(
        height: height,
        width: 5,
      ),
    );
  }
}
