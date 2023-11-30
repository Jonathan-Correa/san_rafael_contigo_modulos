import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csr_design_system/csr_design_system.dart';
import 'package:url_launcher/url_launcher.dart';

import '/modules/imc_calculator/models/imc_indicator.dart';
import '/modules/imc_calculator/logic/imc_bloc/imc_bloc.dart';

class IMCRecommendations extends StatelessWidget {
  const IMCRecommendations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          BlocBuilder<ImcBloc, ImcState>(
            builder: (context, state) {
              String? reference =
                  'https://www.who.int/es/news-room/fact-sheets/detail/obesity-and-overweight';

              Widget recommendation = const H6(
                'Su Índice de Masa Corporal (IMC)   está dentro de los valores de "obesidad mórbida". "Le sugerimos consultar de forma prioritaria a su EPS para valoración metabólica y pautas de tratamiento interdisciplinario de su condición. Adicionalmente le sugerimos realizar ajustes nutricionales y actividad física cardiovascular al menos 300 minutos semanales, acorde a recomendación de la OMS para aumentar su gasto energético.',
                bold: false,
                center: true,
                color: Color.fromARGB(255, 246, 87, 76),
                key: Key('indice_obesity'),
              );

              if (state.score == 0.0) {
                reference = null;
                recommendation = const H6(
                  '',
                  key: Key('no_recomendacion'),
                );
              } else if (state.category == ImcCategory.underWeight) {
                reference =
                    'http://www.saludcapital.gov.co/Documents/Cuidate_3_Alerta_ROJA+ALCM.pdf';

                recommendation = const H6(
                  'Su Índice de Masa Corporal (IMC) está dentro de los valores correspondientes a “delgadez o bajo peso". Le sugerimos realizar ajustes nutricionales y de actividad física para aumentar su masa muscular. Si persiste su condición le sugerimos consultar a su médico',
                  bold: false,
                  center: true,
                  key: Key('indice_bajo'),
                );
              } else if (state.category == ImcCategory.normalWeight) {
                reference =
                    'http://www.saludcapital.gov.co/Documents/Cuidate_4_Peso_Normal+ALCM.pdf';
                recommendation = const H6(
                  'Su Índice de Masa Corporal (IMC) está dentro  de los valores "normales" o de peso saludable. Felicitaciones. Le sugerimos mantener sus adecuados hábitos y estilos de vida.',
                  bold: false,
                  center: true,
                  key: Key('indice_normal'),
                );
              } else if (state.category == ImcCategory.overWeight) {
                reference =
                    'https://www.who.int/es/news-room/fact-sheets/detail/obesity-and-overweight';
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
                    child: Column(children: [
                      recommendation,
                      const SizedBox(height: 20),
                      if (reference != null) const Text('Tomado de: '),
                      if (reference != null)
                        TextButton(
                          onPressed: () {
                            launchUrl(Uri.parse(reference!));
                          },
                          child: Text(reference, textAlign: TextAlign.center),
                        )
                    ]),
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
