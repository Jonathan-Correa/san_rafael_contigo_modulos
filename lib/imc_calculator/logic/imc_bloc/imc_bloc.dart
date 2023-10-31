import 'package:bloc/bloc.dart';

import '/imc_calculator/models/imc_table.dart';
import '/imc_calculator/models/imc_indicator.dart';

part 'imc_state.dart';
part 'imc_event.dart';

class ImcBloc extends Bloc<ImcEvent, ImcState> {
  final Function(int, int) _registerViewLog;

  ImcBloc({required Function(int, int) registerViewLog})
      : _registerViewLog = registerViewLog,
        super(const ImcState(0.0, ImcCategory.underWeight)) {
    on<Calculate>((event, emit) {
      final imcTable = ImcTable();

      bool findIndicator(ImcIndicator indicator) {
        return event.age >= indicator.age.min && event.age <= indicator.age.max;
      }

      final imcIndicator = event.gender == Gender.men
          ? imcTable.men.firstWhere(findIndicator)
          : imcTable.women.firstWhere(findIndicator);

      final calculatedScore = event.weight / (event.height * event.height);
      final scoreTruncated = calculatedScore.toStringAsFixed(2);
      final score = double.parse(scoreTruncated);

      ImcCategory category;

      if (score >= imcIndicator.imcUnderWeight.min &&
          score <= imcIndicator.imcUnderWeight.max) {
        category = ImcCategory.underWeight;
      } else if (score >= imcIndicator.imcNormalWeight.min &&
          score <= imcIndicator.imcNormalWeight.max) {
        category = ImcCategory.normalWeight;
      } else if (score >= imcIndicator.imcOverWeight.min &&
          score <= imcIndicator.imcOverWeight.max) {
        category = ImcCategory.overWeight;
      } else {
        category = ImcCategory.obesity;
      }

      emit(ImcState(score, category));
      _registerViewLog(1, 5);
    });
  }
}
