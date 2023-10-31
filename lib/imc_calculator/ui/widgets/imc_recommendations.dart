import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csr_design_system/csr_design_system.dart';

import '/imc_calculator/models/imc_indicator.dart';
import '/imc_calculator/logic/imc_bloc/imc_bloc.dart';

class IMCRecommendations extends StatelessWidget {
  const IMCRecommendations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          BlocBuilder<ImcBloc, ImcState>(
            builder: (context, state) {
              Widget recommendation = const H6(
                'Su Índice de Masa Corporal (IMC)   está dentro de los valores de "obesidad mórbida". "Le sugerimos consultar de forma prioritaria a su EPS para valoración metabólica y pautas de tratamiento interdisciplinario de su condición. Adicionalmente le sugerimos realizar ajustes nutricionales y actividad física cardiovascular al menos 300 minutos semanales, acorde a recomendación de la OMS para aumentar su gasto energético.',
                bold: false,
                center: true,
                color: Color.fromARGB(255, 246, 87, 76),
                key: Key('indice_obesity'),
              );

              if (state.score == 0.0) {
                recommendation = const H6(
                  '',
                  key: Key('no_recomendacion'),
                );
              } else if (state.category == ImcCategory.underWeight) {
                recommendation = const H6(
                  'Su Índice de Masa Corporal (IMC) está dentro de los valores correspondientes a “delgadez o bajo peso". Le sugerimos realizar ajustes nutricionales y de actividad física para aumentar su masa muscular. Si persiste su condición le sugerimos consultar a su médico',
                  bold: false,
                  center: true,
                  key: Key('indice_bajo'),
                );
              } else if (state.category == ImcCategory.normalWeight) {
                recommendation = const H6(
                  'Su Índice de Masa Corporal (IMC) está dentro  de los valores "normales" o de peso saludable. Felicitaciones. Le sugerimos mantener sus adecuados hábitos y estilos de vida.',
                  bold: false,
                  center: true,
                  key: Key('indice_normal'),
                );
              } else if (state.category == ImcCategory.overWeight) {
                recommendation = const H6(
                  'Su Índice de Masa Corporal (IMC)  está dentro de los valores correspondientes a "sobrepeso". "Le sugerimos realizar ajustes nutricionales y actividad física cardiovascular al menos 150 minutos semanales, acorde a recomendación de la OMS para aumentar su gasto energético.',
                  bold: false,
                  center: true,
                  key: Key('indice_sobrepeso'),
                );
              }

              return Column(
                children: [
                  if (state.score != 0.0) const SizedBox(height: 10),
                  if (state.score != 0.0) const H6('Recomendaciones'),
                  if (state.score != 0.0) const SizedBox(height: 10),
                  AnimatedSwitcher(
                    reverseDuration: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: recommendation,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
