import 'package:flutter/material.dart' show Color;

enum Gender { men, women }

enum ImcCategory { underWeight, normalWeight, overWeight, obesity }

const imcCategoryColors = {
  ImcCategory.underWeight: Color.fromARGB(255, 247, 234, 44),
  ImcCategory.normalWeight: Color.fromARGB(255, 71, 225, 76),
  ImcCategory.overWeight: Color.fromARGB(255, 252, 138, 17),
  ImcCategory.obesity: Color.fromARGB(255, 245, 77, 65),
};

class ImcIndicator {
  final ImcBounds age;
  final ImcBounds imcUnderWeight;
  final ImcBounds imcNormalWeight;
  final ImcBounds imcOverWeight;
  final ImcBounds imcObesityWeight;

  const ImcIndicator({
    required this.age,
    required this.imcUnderWeight,
    required this.imcNormalWeight,
    required this.imcOverWeight,
    required this.imcObesityWeight,
  });
}

class ImcBounds {
  final double min;
  final double max;

  const ImcBounds(this.min, this.max);
}
