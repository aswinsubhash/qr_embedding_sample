import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR embedding'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => controller.qrEmbeddedImage.value != null
                ? Image.file(
                    controller.qrEmbeddedImage.value!,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.captureImage,
              child: const Text('Capture Image'),
            ),
          ],
        ),
      ),
    );
  }
}
