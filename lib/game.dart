import 'package:flutter/material.dart';

import 'model/user.dart';

class Game extends StatefulWidget {
  final User user;
  const Game(this.user, {Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
