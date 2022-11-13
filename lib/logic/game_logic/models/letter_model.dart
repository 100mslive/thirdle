enum LetterStatus { none, correctLetter, correctLetterWithPosition }

class Letter {
  Letter({
    required this.value,
    this.status = LetterStatus.none,
  });

  final String value;
  LetterStatus status;

  Map<String, dynamic> toMap() {
    return {
      "value": value,
      "status": status.name,
    };
  }

  factory Letter.fromMap(Map<String, dynamic> map) {
    return Letter(
      value: map["value"],
      status: LetterStatus.values.byName(map["status"]),
    );
  }
}
