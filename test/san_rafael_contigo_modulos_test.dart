import 'package:flutter_test/flutter_test.dart';

import 'package:san_rafael_contigo_modulos/san_rafael_contigo_modulos.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });
}
