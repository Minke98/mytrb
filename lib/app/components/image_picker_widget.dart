import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final String? title;
  final Rx<XFile?>? imageFile;
  final RxString? error;

  const ImagePickerWidget({
    this.title,
    this.imageFile,
    this.error,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title!, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        if (error != null && error!.value.isNotEmpty)
          Text(
            error!.value,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            XFile? tmp = await _showImagePicker(context);
            if (tmp != null && imageFile != null) {
              imageFile!.value = tmp;
              if (error != null) error!.value = "";
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              border: Border.all(
                color: (error != null && error!.value.isNotEmpty)
                    ? Theme.of(context).colorScheme.error
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            height: (30 / 100) * Get.height,
            child: Center(
              child: (imageFile != null && imageFile!.value != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imageFile!.value!.path),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    )
                  : _displayUpload(context),
            ),
          ),
        ),
      ],
    );
  }

  Future<XFile?> _showImagePicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    return await showModalBottomSheet<XFile?>(
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            color: Colors.white,
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Ambil Foto'),
                  onTap: () async {
                    XFile? pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    Get.back(result: pickedFile);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () async {
                    XFile? pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    Get.back(result: pickedFile);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _displayUpload(BuildContext context) {
    bool hasError = error != null && error!.value.isNotEmpty;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.cloud_upload_rounded,
              color:
                  hasError ? Theme.of(context).colorScheme.error : Colors.white,
              size: 20,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 10)),
          WidgetSpan(
            child: Text(
              hasError ? "Harap unggah foto" : "Upload / Take Photo",
              style: TextStyle(
                fontSize: 14,
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : Colors.white,
                fontWeight: hasError ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
