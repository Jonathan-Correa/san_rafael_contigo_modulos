import 'package:csr_design_system/csr_design_system.dart';
import 'package:csr_design_system/widgets/csr_appbar.dart';
import 'package:csr_design_system/widgets/csr_button.dart';
import 'package:flutter/material.dart';

class IMCIntroductionScreen extends StatelessWidget {
  const IMCIntroductionScreen({
    Key? key,
    required this.onPressCalculateIMC,
  }) : super(key: key);

  final void Function() onPressCalculateIMC;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CsrAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: Container()),
            const H6(
              'El índice de masa corporal (IMC) es una medida utilizada para evaluar si una persona tiene un peso saludable en relación con su altura',
              center: true,
              bold: false,
            ),
            const SizedBox(height: 10),
            const H6(
              'Es importante tener en cuenta que el IMC es solo una medida aproximada y no tiene en cuenta otros factores importantes como la composición corporal, la distribución de grasa y la masa muscular. Por lo tanto, el IMC no debe ser la única medida utilizada para evaluar la salud de una persona.',
              center: true,
              bold: false,
            ),
            Expanded(child: Container()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: CsrButton(
                  color: Theme.of(context).primaryColor,
                  text: 'Calcula tu IMC',
                  onPressed: onPressCalculateIMC,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
