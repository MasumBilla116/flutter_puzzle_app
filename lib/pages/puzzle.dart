import 'dart:ffi';
import 'package:flutter/material.dart';
import "dart:math";
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class Puzzle extends StatefulWidget {
  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  var number = [];
  dynamic puzzlListItem = [];
  dynamic puzzleListIndex = [];
  late Future<List<Image>> imageFile;

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
    setUpPuzzleImageGrid();
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

  void generateRandomNumber() {
    List<int> randomNumber = List.generate(9, (index) => index);
    randomNumber.shuffle();
    setState(() {
      number = randomNumber;
    });
  }

  void setPuzzleNumber(index) {
    if (((index - 1 > 0) && (number[index - 1] == 0) && (index % 3 != 0)) ||
        ((index + 1 < 9) &&
            (number[index + 1] == 0) &&
            ((index + 1) % 3 != 0)) ||
        ((index - 3 >= 0) && (number[index - 3] == 0)) ||
        ((index + 3 < 9) && (number[index + 3] == 0)) ||
        (index == 1 && number[index - 1] == 0)) {
      setState(() {
        number[number.indexOf(0)] = number[index];
        number[index] = 0;
      });
    }
  }

  final scopeGrid = 3;
  void setUpPuzzleImageGrid() {
    final percentage = 100 / (scopeGrid - 1);
    for (var i = 0; i < scopeGrid * scopeGrid; i++) {
      dynamic itemInfos = {};

      var xpos = (percentage * (i % scopeGrid)); // Adjust the calculation
      var ypos = (percentage * (i % scopeGrid)); // Adjust the calculation

      puzzleListIndex.add(i);

      puzzlListItem.add(
        ClipRect(
          child: Positioned(
            left: xpos, // Set the left position
            top: ypos, // Set the top position
            // right: xpos,
            // bottom: ypos,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bird.jpg"),
                  // fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              ),
              alignment: Alignment.center,
            ),
          ),
        ),
      );
      puzzleListIndex.shuffle();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("puzzleListIndex: ");
    print(puzzlListItem);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Puzzle Game"),
      ),
      body: Center(
        child: Container(
          color: Colors.grey,
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<Image>>(
            future: imageFile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  color: Colors.white,
                  child: const Text("Something is wrong"),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: .80,
                    crossAxisSpacing: .80,
                  ),
                  itemCount: number.length,
                  itemBuilder: (context, index) {
                    return number[index] != 0
                        ? TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0)),
                            onPressed: () {
                              setPuzzleNumber(index);
                            },
                            child: SizedBox(
                              width: 110,
                              height: 110,
                              child: ClipRRect(
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: snapshot.data![index],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.white,
                          );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
