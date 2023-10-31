import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csr_design_system/csr_design_system.dart';

import '/imc_calculator/models/imc_indicator.dart';
import '/imc_calculator/logic/imc_bloc/imc_bloc.dart';

class IMCCategories extends StatelessWidget {
  const IMCCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: BlocBuilder<ImcBloc, ImcState>(
        builder: (context, state) {
          return Column(
            children: [
              _CategoryIndicator(
                color: theme.colorScheme.primary,
                text1: 'Categoría',
                text2: 'Diferencia',
              ),
              _CategoryIndicator(
                color: state.category == ImcCategory.underWeight
                    ? imcCategoryColors[ImcCategory.underWeight]
                    : null,
                text1: 'Por debajo de 18.5',
                text2: 'Bajo Peso',
              ),
              _CategoryIndicator(
                color: state.category == ImcCategory.normalWeight
                    ? imcCategoryColors[ImcCategory.normalWeight]
                    : null,
                text1: '18.5 – 24.9',
                text2: 'Peso Normal',
              ),
              _CategoryIndicator(
                color: state.category == ImcCategory.overWeight
                    ? imcCategoryColors[ImcCategory.overWeight]
                    : null,
                text1: '25.0 – 29.9',
                text2: 'Sobrepeso',
              ),
              _CategoryIndicator(
                color: state.category == ImcCategory.obesity
                    ? imcCategoryColors[ImcCategory.obesity]
                    : null,
                text1: '30.0 o más',
                text2: 'Obesidad',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryIndicator extends StatelessWidget {
  const _CategoryIndicator({
    Key? key,
    required this.color,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final Color? color;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Subtitle2(
        text1,
        center: true,
        bold: false,
        color: color,
      ),
      Expanded(child: Container()),
      Subtitle2(
        text2,
        color: color,
        center: true,
        bold: false,
      ),
    ]);
  }
}
