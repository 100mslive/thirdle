enum LetterStatus { none, correctLetter, correctLetterWithPosition }

class Letter {
  Letter({
    required this.value,
    this.status = LetterStatus.none,
  });

  final String value;
  LetterStatus status;
}
