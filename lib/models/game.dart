import 'package:flutter/material.dart';

@immutable
class Game {
  final int secretNumber;
  final Set<int> guesses;
  final int score;

  const Game({required this.secretNumber, this.guesses = const {}, this.score = 0});

  Game copyWith({int? secretNumber, Set<int>? guesses, int? score}) {
    return Game(
      secretNumber: secretNumber ?? this.secretNumber,
      guesses: guesses ?? this.guesses,
      score: score ?? this.score,
    );
  }

  bool hasBeenGuessed(int value) => guesses.contains(value);
}