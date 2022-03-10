import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/game.dart';
import '../utils/roller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Game _game;
  late String _message;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _game = Game(secretNumber: rollDie(10));
    _message = "Choose a number from 1-10...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(_init);
            },
            icon: const Icon(Icons.refresh),
            tooltip: "New Game",
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 1; i <= 10; i++) Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Tooltip(
                      message: "Guess $i",
                      child: ElevatedButton(
                        onPressed: !_game.hasBeenGuessed(i) ? () => _makeGuess(i) : null,
                        child: Text(i.toString()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Score: ${_game.score}",
              style: Theme.of(context).textTheme.headline6,
            ),
            if (kDebugMode) Text("Secret: ${_game.secretNumber}"),
            if (kDebugMode) Text("Guesses: ${_game.guesses}"),
          ],
        ),
      ),
    );
  }

  void _makeGuess(int guess) {
    setState(() {
      List<int> guessesToAdd;

      if (guess == _game.secretNumber) {
        _message = "Yes! You guessed the secret number: ${_game.secretNumber}";
        guessesToAdd = List.generate(10, (index) => index + 1);
      }
      else if (guess < _game.secretNumber) {
        _message = "Whoa! Too low...";
        guessesToAdd = List.generate(guess, (index) => index + 1);
      }
      else {
        _message = "Yikes! Too high...";
        guessesToAdd = List.generate(10 - guess + 1, (index) => index + guess);
      }

      _game = _game.copyWith(
        guesses: Set.unmodifiable(_game.guesses.toSet()..addAll(guessesToAdd)),
        score: _game.score + 1,
      );
    });
  }
}
