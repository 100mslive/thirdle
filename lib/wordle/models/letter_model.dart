import 'package:equatable/equatable.dart';

enum LetterStatus { none, correctLetter, correctLetterWithPosition }

class Letter extends Equatable {
  const Letter({
    required this.value,
    this.status = LetterStatus.none,
  });

  final String value;
  final LetterStatus status;

  Letter copyWith({String? value, LetterStatus? status}) {
    return Letter(
      value: value ?? this.value,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [value];
}
