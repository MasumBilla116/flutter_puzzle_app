import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:number_puzzle/components/image_picker_service.dart';
import 'package:number_puzzle/pages/puzzle.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Image>> imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = splitAssetsImage('assets/images/bird.jpg');
  }

  Future<List<Image>> splitAssetsImage(String assetPath) async {
    // Load the asset image as a byte list
    ByteData data = await rootBundle.load(assetPath);
    List<int> input = data.buffer.asUint8List();

    Uint8List uint8List = Uint8List.fromList(input);

    // convert image to image from the image package
    imglib.Image? image = imglib.decodeImage(uint8List);

    if (image != null) {
      int x = 0, y = 0;
      int width = (image.width / 3).floor();
      int height = (image.height / 3).floor();

      List<imglib.Image> parts = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          parts.add(
              imglib.copyCrop(image, x: x, y: y, width: width, height: height));
          x += width;
        }
        x = 0;
        y += height;
      }
      List<Image> output = [];
      for (var img in parts) {
        output.add(Image.memory(Uint8List.fromList(imglib.encodeJpg(img))));
      }

      return output;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Puzzle Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Puzzle(),
                  ),
                );
              },
              child: const Text("Start Puzzle Game"),
            ),
          ],
        ),
      ),
    );
  }
}
