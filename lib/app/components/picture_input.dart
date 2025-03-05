import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PictureInput extends StatefulWidget {
  PictureInput(
      {super.key,
      required this.title,
      this.allowedExtension = const ['jpg', 'png', 'jpeg', 'gif'],
      this.allowCamera = true,
      this.allowGalery = true,
      this.imageQuality = 70,
      this.imageMaxWidth = 600});

  final String title;
  List allowedExtension;
  bool allowGalery;
  bool allowCamera;
  int imageQuality;
  double imageMaxWidth;
  @override
  State<PictureInput> createState() => _PictureInputState();
}

class _PictureInputState extends State<PictureInput> {
  double sch = 0;
  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (sch == 0) {
      if (ResponsiveWrapper.of(context).orientation == Orientation.portrait) {
        sch = ResponsiveWrapper.of(context).screenHeight;
      } else {
        sch = ResponsiveWrapper.of(context).screenWidth;
      } // lastWidth = ;
    }
    double percentage = (20 / 100) * sch;
    List<Widget> childrens = [];
    if (widget.allowCamera == true) {
      childrens.add(SizedBox(
        width: 100,
        child: Column(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                log("pictureInput: restore set lastPage");
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("lastPage", "/takeFoto");
                selectedImage = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: widget.imageQuality,
                    maxWidth: widget.imageMaxWidth);
                log("pictureInput: $selectedImage");
                if (selectedImage is XFile && context.mounted) {
                  Navigator.of(context).pop(selectedImage);
                }
              },
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Take Foto",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )
          ],
        ),
      ));
    }

    if (widget.allowGalery == true) {
      childrens.add(SizedBox(
        width: 100,
        child: Column(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                log("pictureInput: restore set lastPage");
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("lastPage", "/takeFoto");
                selectedImage = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: widget.imageQuality,
                    maxWidth: widget.imageMaxWidth);
                log("pictureInput: $selectedImage");
                if (selectedImage is XFile && context.mounted) {
                  Navigator.of(context).pop(selectedImage);
                }
              },
              icon: const Icon(
                Icons.photo_library_rounded,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("From Gallery",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer))
          ],
        ),
      ));
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      height: (percentage < 150) ? 150 : percentage,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: childrens,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
