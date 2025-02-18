// import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mytrb/app/modules/profile/controllers/profile_controllers.dart';

// class ProfileView extends GetView<ProfileController> {
//   ProfileView({super.key});
//   final IndexController indexController = Get.put(IndexController());

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Get.close(2);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Profile")),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildProfilePictureSection(context),
//                 const SizedBox(height: 40),
//                 _buildAccountIdSection(context),
//                 const SizedBox(height: 10),
//                 _buildNikSection(context),
//                 const SizedBox(height: 10),
//                 _buildSeafarerCodeSection(context),
//                 const SizedBox(height: 10),
//                 _buildNameSection(context),
//                 const SizedBox(height: 10),
//                 _buildEmailSection(context),
//                 const SizedBox(height: 10),
//                 _buildPhoneNumber(context),
//                 const SizedBox(height: 30),
//                 const Text(
//                   'Ubah Password',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 _buildChangePasswordSection(context),
//                 const SizedBox(height: 20),
//                 _buildSaveButton(context),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfilePictureSection(BuildContext context) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             if (controller.image.value != null ||
//                 controller.imageUrl.value.isNotEmpty) {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   if (controller.image.value != null) {
//                     // Jika ada gambar lokal
//                     return AlertDialog(
//                       content: Image.file(
//                         controller.image.value!,
//                         fit: BoxFit.contain,
//                       ),
//                     );
//                   } else {
//                     // Jika hanya ada URL gambar
//                     return AlertDialog(
//                       content: CachedNetworkImage(
//                         imageUrl: controller.imageUrl.value,
//                         fit: BoxFit.contain,
//                         placeholder: (context, url) =>
//                             const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                       ),
//                     );
//                   }
//                 },
//               );
//             }
//           },
//           child: Obx(
//             () => CircleAvatar(
//               radius: 40,
//               backgroundImage: controller.imageUrl.value.isNotEmpty
//                   ? NetworkImage(controller.imageUrl.value)
//                   : (controller.image.value != null
//                           ? FileImage(controller.image.value!)
//                           : const AssetImage("assets/images/profile1.png"))
//                       as ImageProvider<Object>,
//               // Jika imageUrl kosong dan image juga null, tampilkan ikon profil default.
//               // child: controller.imageUrl.value.isEmpty &&
//               //         controller.image.value == null
//               //     ? const Icon(Icons
//               //         .person) // Ganti dengan ikon atau widget lain jika diinginkan.
//               //     : null,
//             ),
//           ),
//         ),
//         const SizedBox(width: 20),
//         TextButton(
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return SafeArea(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       ListTile(
//                         leading: const Icon(Icons.photo_camera),
//                         title: const Text('Camera'),
//                         onTap: () {
//                           Navigator.pop(context);
//                           controller.getImageFromCamera();
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.photo),
//                         title: const Text('Gallery'),
//                         onTap: () {
//                           Navigator.pop(context);
//                           controller.getImageFromGallery();
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//           child: Text(
//             'Ubah Foto',
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.blue[700],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSeafarerCodeSection(BuildContext context) {
//     return Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Kode Pelaut : ',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Text(
//               indexController.currentUser.value?.usrKodePelaut ?? '-',
//               style: const TextStyle(fontSize: 13),
//             ),
//           ],
//         ));
//   }

//   Widget _buildAccountIdSection(BuildContext context) {
//     return Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'ID Pengguna : ',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Text(
//               indexController.currentUser.value?.usrAccountId ?? '',
//               style: const TextStyle(fontSize: 13),
//             ),
//           ],
//         ));
//   }

//   Widget _buildNikSection(BuildContext context) {
//     return Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'NIK : ',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Text(
//               indexController.currentUser.value?.usrNik ?? '',
//               style: const TextStyle(fontSize: 13),
//             ),
//           ],
//         ));
//   }

//   Widget _buildNameSection(BuildContext context) {
//     return Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Nama : ',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Text(
//               indexController.currentUser.value?.logName ?? '',
//               style: const TextStyle(fontSize: 13),
//             ),
//           ],
//         ));
//   }

//   Widget _buildEmailSection(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Obx(() => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Email : ',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Text(
//                     indexController.currentUser.value?.usrEmail ?? '',
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                 ],
//               )),
//         ),
//         // TextButton(
//         //   onPressed: () {
//         //     _showChangeEmailDialog(context);
//         //   },
//         //   child: Text(
//         //     'Ubah Email',
//         //     style: TextStyle(
//         //       fontSize: 13,
//         //       color: Colors.blue[700],
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }

//   Widget _buildPhoneNumber(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Obx(() => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Nomor Telepon : ',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Text(
//                     indexController.currentUser.value?.usrNoTelephone ?? '',
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                 ],
//               )),
//         ),
//         // TextButton(
//         //   onPressed: () {
//         //     _showChangePhoneNumberDialog(context);
//         //   },
//         //   child: Text(
//         //     'Ubah Nomor Telepon',
//         //     style: TextStyle(
//         //       fontSize: 13,
//         //       color: Colors.blue[700],
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }

//   Widget _buildChangePasswordSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: controller.oldPassController,
//           decoration: const InputDecoration(
//             labelText: 'Password Lama',
//             labelStyle: TextStyle(
//               fontSize: 13.0,
//             ),
//           ),
//           obscureText: true,
//         ),
//         TextFormField(
//           controller: controller.changePassController,
//           decoration: const InputDecoration(
//             labelText: 'Password Baru',
//             labelStyle: TextStyle(
//               fontSize: 13.0,
//             ),
//           ),
//           obscureText: true,
//         ),
//         TextFormField(
//           controller: controller.newPassController,
//           decoration: const InputDecoration(
//             labelText: 'Konfirmasi Password Baru',
//             labelStyle: TextStyle(
//               fontSize: 13.0,
//             ),
//           ),
//           obscureText: true,
//           cursorColor: Colors.black,
//         ),
//       ],
//     );
//   }

//   Widget _buildSaveButton(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.circular(8), // Adjust border radius as needed
//           ),
//           padding: const EdgeInsets.all(0), // No padding
//         ),
//         onPressed: () {
//           controller.saveChanges(context);
//           // Get.snackbar('Info', 'Perubahan telah disimpan');
//         },
//         child: Ink(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFF002171),
//                 Color(0xFF1565C0),
//               ],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//             borderRadius:
//                 BorderRadius.circular(8), // Adjust border radius as needed
//           ),
//           child: Container(
//             constraints: const BoxConstraints(
//                 minWidth: 180, minHeight: 40), // Set min width and height
//             alignment: Alignment.center,
//             child: const Text(
//               'Simpan Perubahan',
//               style: TextStyle(
//                 color: Colors.white, // Set text color to white
//                 fontSize: 14, // Adjust font size as needed
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showChangeEmailDialog(BuildContext context) {
//     Get.defaultDialog(
//       title: 'Ubah Email',
//       titleStyle: const TextStyle(
//           fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.bold),
//       content: TextFormField(
//         controller: controller.emailController,
//         decoration: const InputDecoration(
//           labelText: 'Email Baru',
//           labelStyle: TextStyle(
//             fontSize: 13.0,
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Get.back();
//           },
//           child: const Text(
//             'Batal',
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             controller.changeEmail(controller.emailController.text);
//             Get.back();
//           },
//           child: const Text('Simpan'),
//         ),
//       ],
//     );
//   }

//   void _showChangePhoneNumberDialog(BuildContext context) {
//     Get.defaultDialog(
//       title: 'Ubah Nomor Telepon',
//       titleStyle: const TextStyle(
//           fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.bold),
//       content: TextFormField(
//         keyboardType: TextInputType.phone,
//         controller: controller.phoneNumberController, // Use the new controller
//         decoration: const InputDecoration(
//           labelText: 'Nomor Telepon Baru',
//           labelStyle: TextStyle(
//             fontSize: 13.0,
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Get.back();
//           },
//           child: const Text('Batal'),
//         ),
//         TextButton(
//           onPressed: () {
//             controller.changePhoneNumber(controller.phoneNumberController.text);
//             Get.back();
//           },
//           child: const Text('Simpan'),
//         ),
//       ],
//     );
//   }
// }
