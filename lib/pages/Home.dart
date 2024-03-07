import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:number_puzzle/components/image_picker_service.dart';
import 'package:number_puzzle/pages/puzzle.dart';
import 'package:image/image.dart' as img;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? imageFile;
  void _onClick() async {
    imageFile = await ImagePickerService().pickCropImage(
      cropAspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 10),
      imageSource: ImageSource.camera,
    );
  }

  void _myImg() async {
    // Create a 256x256 8-bit (default) rgb (default) image.
    final image = img.Image(width: 256, height: 256);
    // Iterate over its pixels
    for (var pixel in image) {
      // Set the pixels red value to its x position value, creating a gradient.
      pixel
        ..r = pixel.x
        // Set the pixels green value to its y position value.
        ..g = pixel.y;
    }
    // Encode the resulting image to the PNG image format.
    final png = img.encodePng(image);
    // Write the PNG formatted data to a file.
    await File('image.png').writeAsBytes(png);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Puzzle"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Puzzle()))
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: EdgeInsets.all(16),
          ),
          child: imageFile != null
              ? Image(image: FileImage(File(imageFile!.path)))
              : TextButton(
                  onPressed: _onClick,
                  child: Text("Pick Image"),
                ),
        ),
      ),
    );
  }
}


// const Text(
//             "Start Games",
//             style: TextStyle(color: Colors.brown, fontSize: 20),
//           ),