import 'package:flutter/material.dart';

import 'model/user.dart';

class Game extends StatefulWidget {
  final User user;
  const Game(this.user, {Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  static int numberOfSquares = 640;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            GridView.builder(
                itemCount: numberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 20),
                itemBuilder: (context, index) {
                  return boardSquare();
                }),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _scoreWidget(),
                    _coinsWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Represents an empty board square
  Widget boardSquare() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(.4),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget snakePart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget botPart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget foodPart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget coinPart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.yellow, borderRadius: BorderRadius.circular(5)),
        child: Image.asset("assets/images/singlecoin.png"),
      ),
    );
  }

  Widget _scoreWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Score: ",
          style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 25),
        ),
        Text(
          "PLACEHOLDER",
          style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 25),
        ),
      ],
    );
  }

  Widget _coinsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/singlecoin.png",
          width: 25,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "PLACEHOLDER",
          style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 25),
        ),
      ],
    );
  }
}
