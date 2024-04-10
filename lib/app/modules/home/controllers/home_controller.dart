import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';

// class HomeController extends GetxController {

//   Rx<Uint8List?> embeddedImageBytes = Rx<Uint8List?>(null);

//   Future<void> captureImage() async {
//     final imagePicker = ImagePicker();
//     XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//     // XFile?  capturedImage = image;
//      embedImageWithData(image);
//     }
   
//   }

//   Future<void> embedImageWithData(XFile xfile) async {
//     // if (xfile == null) {
//     //   return;
//     // }

//     const qrData = 'www.jiitak.jp';
//     final qrImageData = await QrPainter(
//       data: qrData,
//       version: QrVersions.auto,
//     ).toImageData(200.0);

//     final capturedUiImage = await loadImage(xfile.path);

//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(recorder);

//     canvas.drawImage(capturedUiImage, Offset.zero, Paint());

//     final codec =
//         await ui.instantiateImageCodec(qrImageData!.buffer.asUint8List());
//     final qrImage = (await codec.getNextFrame()).image;
//     canvas.drawImage(qrImage, const Offset(40, 40), Paint());

//     final img = await recorder.endRecording().toImage(
//           capturedUiImage.width,
//           capturedUiImage.height,
//         );
//     final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
//     final imageBytes = byteData!.buffer.asUint8List();

//     embeddedImageBytes.value = imageBytes;
//   }

//   Future<ui.Image> loadImage(String imagePath) async {
//     final File file = File(imagePath);
//     final Uint8List bytes = await file.readAsBytes();
//     return decodeImageFromList(bytes);
//   }
// }

class HomeController extends GetxController {
  Rx<File?> qrEmbeddedImage = Rx<File?>(null);

  Future<void> captureImage() async {
    final imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await embedQrOnImage(File(image.path));
    }
  }

  Future<void> embedQrOnImage(File imageFile) async {
    const qrData = 'www.jiitak.jp';
    final qrImageData = await QrPainter(
      data: qrData,
      version: QrVersions.auto,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImageData(150.0);

    final capturedUiImage = await loadImage(imageFile.path);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(capturedUiImage, Offset.zero, Paint());

    final codec =
        await ui.instantiateImageCodec(qrImageData!.buffer.asUint8List());
    final qrImage = (await codec.getNextFrame()).image;
    canvas.drawImage(qrImage, const Offset(40, 40), Paint());

    final img = await recorder.endRecording().toImage(
      capturedUiImage.width,
      capturedUiImage.height,
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes = byteData!.buffer.asUint8List();

    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/${DateTime.now()}.jpg';
    final File file = File(filePath);
    await file.writeAsBytes(imageBytes);

    qrEmbeddedImage.value = file;
    debugPrint(qrEmbeddedImage.value?.path);
  }

  Future<ui.Image> loadImage(String imagePath) async {
    final File file = File(imagePath);
    final Uint8List bytes = await file.readAsBytes();
    return decodeImageFromList(bytes);
  }
}

