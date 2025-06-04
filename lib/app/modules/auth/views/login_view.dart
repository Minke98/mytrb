import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/components/footer_copyright_login.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/dialog.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.grey[800],
            body: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: SingleChildScrollView(
                          child: AutofillGroup(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Environment.stip,
                                  height: 200,
                                  width: 200,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Text(
                                    "Hello There!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Login, please.",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 5),
                                  child: TextFormField(
                                    autofillHints: const [
                                      AutofillHints.username
                                    ],
                                    controller: controller.usernameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Username',
                                      labelStyle: const TextStyle(
                                          color: Colors.white70),
                                      hintStyle: const TextStyle(
                                          color: Colors.white54),
                                      filled: true,
                                      fillColor: Colors.grey[700],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 20),
                                  child: TextFormField(
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    controller: controller.passwordController,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      labelStyle: const TextStyle(
                                          color: Colors.white70),
                                      hintStyle: const TextStyle(
                                          color: Colors.white54),
                                      filled: true,
                                      fillColor: Colors.grey[700],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                Obx(() => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          controller.login();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade900,
                                          minimumSize:
                                              const Size.fromHeight(55),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: controller.isCheckingAuth.value
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Text(
                                                "Login",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                      ),
                                    )),
                                const SizedBox(height: 25),
                                RichText(
                                  text: TextSpan(
                                    text: "Don't Have an Account Yet?",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    children: [
                                      TextSpan(
                                        text: " Claim Now",
                                        style: TextStyle(
                                          color: Colors.blue.shade300,
                                          fontSize: 14,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(Routes.CLAIM);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                RichText(
                                  text: TextSpan(
                                    text: "Forgot Password?",
                                    style: TextStyle(
                                      color: Colors.blue.shade300,
                                      fontSize: 14,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        MyDialog.showErrorSnackbarRegist(
                                            "Please Contact UPT");
                                      },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const FooterCopyrightLogin()),
      ),
    );
  }
}
