part of 'imc_bloc.dart';

abstract class ImcEvent {
  const ImcEvent();
}

class Calculate extends ImcEvent {
  final int age;
  final Gender gender;
  final double weight;
  final double height;

  const Calculate({
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
  });
}
