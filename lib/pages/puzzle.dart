import 'dart:ffi';
import 'package:flutter/material.dart';
import "dart:math";

class Puzzle extends StatefulWidget {
  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  var number = [];

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
    setUpPuzzleImageGrid();
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

  dynamic puzzlListItem = [];
  dynamic puzzleListIndex = [];
  final scopeGrid = 8;
  void setUpPuzzleImageGrid() {
    final percentage = 100 / (scopeGrid - 1);
    for (var i = 0; i < scopeGrid * scopeGrid; i++) {
      dynamic itemInfos = {};

      var xpos = (percentage * (i % scopeGrid)); // Adjust the calculation
      var ypos = (percentage * (i % scopeGrid)); // Adjust the calculation

      print("percentage: ${percentage}");
      print("xpos: ${xpos}");
      print("ypos: ${ypos}");

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Puzzle Game"),
      ),
      body: Center(
        child: Container(
          color: Colors.grey,
          padding: const EdgeInsets.all(20),
          child: number.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
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
                            child: puzzlListItem[index],
                          )
                        : Container(
                            color: Colors.white,
                          );
                  },
                )
              : Container(
                  color: Colors.white,
                  child: const Text("Something is worng"),
                ),
        ),
      ),
    );
  }
}
