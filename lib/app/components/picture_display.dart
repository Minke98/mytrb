import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class PictureDisplay extends StatefulWidget {
  final String folder;
  final String local;
  final String? remote;
  final BoxFit fit;
  final double height;
  final Alignment picAlign;
  const PictureDisplay(
      {super.key,
      required this.folder,
      required this.local,
      this.remote,
      this.height = 10,
      this.fit = BoxFit.contain,
      this.picAlign = Alignment.center});

  @override
  State<PictureDisplay> createState() => _PictureDisplayState();
}

class _PictureDisplayState extends State<PictureDisplay> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadImage(widget.local, widget.remote),
      builder: (BuildContext context,
          AsyncSnapshot<ImageProvider<Object>> snapshot) {
        if (snapshot.hasData) {
          // log("pictureDisplay: SnapShot Data ${widget.local}");
          return Align(
            alignment: widget.picAlign,
            child: Image(
              image: snapshot.data!,
              fit: widget.fit,
            ),
          );
        } else if (snapshot.hasError) {
          // return Center(child: Text(snapshot.error!.toString()));
          // return const Center(child: Placeholder());
          return Center(
              child: Image.asset(
            "assets/pub/images/noimage.jpg",
            fit: widget.fit,
            // height: widget.height,
          ));
        } else {
          return const Center(
              child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text("Loading Image")
            ],
          ));
        }
      },
    );
  }

  Future<ImageProvider<Object>> loadImage(
      String image, String? imageUrl) async {
    // await Future.delayed(const Duration(seconds: 5));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String localImage = Path.join(appDocPath, widget.folder, image);
    bool imageExist = await File(localImage).exists();
    if (imageExist == false && imageUrl != null) {
      // if (imageUrl != null) {
      try {
        // log("pictureDisplay: Loading Image $localImage $imageUrl");
        String savePath = Path.join(appDocPath, widget.folder);
        Directory(savePath).createSync(recursive: true);
        await BaseClient.download(
          url: imageUrl,
          savePath: localImage,
          onSuccess: () => log("Download sukses"),
          onError: (e) {
            log("Download gagal: /$e");
          },
        );
        // Dio dio = await MyDio.getDio(retry: false);
        // await dio.download(imageUrl, localImage);
        // log("pictureDisplay: Loading Image Completed $localImage");
        final image = FileImage(File(localImage));
        return image;
      } catch (e) {
        // log("pictureDisplay: Loading Image Error");
        return Future.error("Image Cannot Be Loaded");
      }
    } else if (imageExist == true) {
      // log("pictureDisplay: Image Exists $localImage");
      final image = FileImage(File(localImage));
      return image;
    } else {
      return Future.error("Image Cannot Be Loaded");
      // log("Random Image");
      // final image = Image.asset("assets/pub/images/noimage.jpg");
      // return image;
    }
    // final image = NetworkImage(imagePath);
    // await image.resolve(ImageConfiguration());
    // return image;
  }
}
