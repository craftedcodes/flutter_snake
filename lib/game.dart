import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'model/board.dart';
import 'model/snake.dart';
import 'model/user.dart';

class Game extends StatefulWidget {
  final User user;
  const Game(this.user, {Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  static int numberOfSquares = 640;

  //* This is the range of the food that will be randomly generated. This is used to make sure that the food is not generated on some unwanted squares (for example, at the bottom edge)
  static int foodRange = numberOfSquares - 50;
  //* This is the range of the bots that will be randomly generated. This is used to make sure that the bots are not generated on some unwanted squares (for example, at the bottom edge)
  static int botRange = numberOfSquares - 50;

  // Initialize snake with positions, name, color and score of 0
  //* This is the snake that we will be using to play the game.
  late Snake snake;
  //* This is the board that we will be using to play the game.
  late Board board;

  //* This is the timer that will act as the GAME clock and will determine how often the UI should update.
  late Timer timer;

  //*  This is the list of bots aka enemies that will appear to try to defeat the snake.
  List<Snake> bots = [];
  //* This is the list of bots that will be used to store the bots that are currently being generated.
  List<Snake> placeHolderBots = [];
  //* This is the list of directions that the snake can move in.
  List<String> directions = ["up", "down", "left", "right"];

  var food;

  var coin;

  static var random;

  static var randomCoin;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  startGame() {
    // Reset any active bots
    resetBots();
    // Initialize the snake and board
    initializeModels();
    // Initialize any random vars
    initalizeRandoms();
    // Initialize the food and coin items
    initializeItems();
    // start the game loop
    initializeGameLoop();
    // Game loop
  }

  resetBots() {
    placeHolderBots = [];
    bots = [];
  }

  initializeModels() {
    board = Board(
      id: "default",
      color: Colors.black,
      name: "default",
      price: 0,
    );

    Random rand = Random();
    final direction = rand.nextInt(3);
    final positioni = rand.nextInt(botRange);

    snake = Snake(
      name: "default",
      color: Colors.orange,
      direction: directions[direction],
      coins: 0,
      diamonds: 0,
      price: 0,
      score: 0,
      positions: generateRandomPositionList(
        directions[direction],
        positioni,
        5,
      ),
    );
  }

  initalizeRandoms() {
    random = Random();
    randomCoin = Random();
  }

  initializeItems() {
    food = random.nextInt(foodRange);
    coin = randomCoin.nextInt(foodRange);
  }

  initializeGameLoop() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      updateGame();
      // TODO: detect game over
    });
  }

  updateGame() {
    setState(() {
      moveSnake();
      detectCollision();
    });
  }

  moveSnake() {
    switch (snake.direction) {
      case "down":
        // LAST ROW OF GRIDS
        if (snake.positions.last > numberOfSquares - 20) {
          snake.positions.add(snake.positions.last + 20 - numberOfSquares);
        } else {
          snake.positions.add(snake.positions.last + 20);
        }
        break;
      case "up":
        if (snake.positions.last < 20) {
          snake.positions.add(snake.positions.last - 20 + numberOfSquares);
        } else {
          snake.positions.add(snake.positions.last - 20);
        }
        break;
      case "left":
        if (snake.positions.last % 20 == 0) {
          snake.positions.add(snake.positions.last - 1 + 20);
        } else {
          snake.positions.add(snake.positions.last - 1);
        }
        break;
      case "right":
        if ((snake.positions.last + 1) % 20 == 0) {
          snake.positions.add(snake.positions.last + 1 - 20);
        } else {
          snake.positions.add(snake.positions.last + 1);
        }
        break;
      default:
    }
    snake.positions.removeAt(0);
  }

  detectCollision() {
    if (snake.positions.last == coin) {
      snake.coins += 50;
      coin = randomCoin.nextInt(foodRange);
    } else if (snake.positions.last == food) {
      snake.score += 20;
      food = random.nextInt(foodRange);
    } else {
      snake.positions.removeAt(0);
    }
  }

  //* It takes a direction, an initial position and a snake length and returns a list of positions that the snake will occupy
  //* Args:
  //*   direction (String): The direction in which the snake is moving.
  //*   initialPosition (int): The initial position of the snake's head.
  //*   snakeLength (int): The length of the snake.
  //*
  //* Returns:
  //*   A list of integers.
  generateRandomPositionList(
      String direction, int initialPosition, int snakeLength) {
    List<int> positionsList = [];
    positionsList.add(initialPosition);
    for (var i = 0; i < snakeLength - 1; i++) {
      switch (direction) {
        case "down":
          if (positionsList.last > numberOfSquares - 20) {
            positionsList.add(positionsList.last + 20 - numberOfSquares);
          } else {
            positionsList.add(positionsList.last + 20);
          }
          break;
        case "up":
          if (positionsList.last < 20) {
            positionsList.add(positionsList.last - 20 + numberOfSquares);
          } else {
            positionsList.add(positionsList.last - 20);
          }
          break;
        case "left":
          if (positionsList.last % 20 == 0) {
            positionsList.add(positionsList.last - 1 + 20);
          } else {
            positionsList.add(positionsList.last - 1);
          }
          break;
        case "right":
          if ((positionsList.last + 1) % 20 == 0) {
            positionsList.add(positionsList.last + 1 - 20);
          } else {
            positionsList.add(positionsList.last + 1);
          }
          break;
        default:
      }
    }
    return positionsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (snake.direction != "up" && details.delta.dy > 0) {
                  snake.direction = "down";
                } else if (snake.direction != "down" && details.delta.dy < 0) {
                  snake.direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (snake.direction != "left" && details.delta.dx > 0) {
                  snake.direction = "right";
                } else if (snake.direction != "right" && details.delta.dx < 0) {
                  snake.direction = "left";
                }
              },
              child: GridView.builder(
                  itemCount: numberOfSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20),
                  itemBuilder: (context, index) {
                    //* This code will detect if any of the snake positions (aka squares that represent the snake contains certain index) and if it does, it will render the snake part. Otherwise, it will check for the other items such as food, coin and bots.
                    if (snake.positions.contains(index)) {
                      return snakePart();
                    } else if (food == index) {
                      return foodPart();
                    } else if (coin == index) {
                      return coinPart();
                    } else {
                      for (var i = 0; i < bots.length; i++) {
                        if (bots[i].positions.contains(index)) {
                          return botPart();
                        }
                      }
                    }

                    return boardSquare();
                  }),
            ),
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
          snake.score.toString(),
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
          snake.coins.toString(),
          style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 25),
        ),
      ],
    );
  }
}
