import 'dart:math';

import 'package:csr_design_system/helpers/snackbar_helper.dart';
import 'package:csr_design_system/widgets/csr_appbar.dart';
import 'package:csr_design_system/widgets/csr_button.dart';
import 'package:csr_design_system/widgets/csr_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csr_design_system/csr_design_system.dart';

import '/modules/imc_calculator/models/imc_indicator.dart';
import '/modules/imc_calculator/logic/imc_bloc/imc_bloc.dart';
import '/modules/imc_calculator/ui/widgets/imc_categories.dart';
import '/modules/imc_calculator/ui/widgets/gender_selector.dart';
import '/modules/imc_calculator/ui/widgets/imc_recommendations.dart';

class IMCCalculatorScreen extends StatelessWidget {
  const IMCCalculatorScreen({
    Key? key,
    required this.registerViewLog,
  }) : super(key: key);

  final Function(int, int) registerViewLog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CsrAppBar(),
      body: BlocProvider(
        create: (context) => ImcBloc(
          registerViewLog: registerViewLog,
        ),
        child: const _IMCCalculatorView(),
      ),
    );
  }
}

class _IMCCalculatorView extends StatefulWidget {
  const _IMCCalculatorView({Key? key}) : super(key: key);

  @override
  State<_IMCCalculatorView> createState() => _IMCCalculatorViewState();
}

class _IMCCalculatorViewState extends State<_IMCCalculatorView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: ListView(
        controller: _scrollController,
        children: [
          ImcControls(scrollController: _scrollController),
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: _RadarIMC(),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Subtitle2('¿CÓMO INTERPRETAR TU IMC?'),
          ),
          const SizedBox(height: 10),
          const IMCCategories(),
          const SizedBox(height: 2),
          const IMCRecommendations(),
        ],
      ),
    );
  }
}

class _RadarIMC extends StatelessWidget {
  const _RadarIMC({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var radarHeight = 120.0;
    var radarWidth = radarHeight * 3;

    return LayoutBuilder(builder: (context, constraints) {
      if (radarWidth > constraints.maxWidth) {
        radarWidth = constraints.maxWidth;
        radarHeight = radarWidth / 3;
      }

      return SizedBox(
        height: radarHeight,
        child: Stack(
          children: [
            SizedBox(
              width: radarWidth,
              child: const RadarContainer(),
            ),
            Positioned(
              top: radarHeight / 2.74,
              left: radarWidth / 6.1,
              child: _RadarIndicator(radarWidth: radarWidth),
            ),
            Positioned(
              top: 100,
              child: Container(
                height: 35,
                width: screenSize.width,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            )
          ],
        ),
      );
    });
  }
}

class _RadarIndicator extends StatelessWidget {
  const _RadarIndicator({
    Key? key,
    required this.radarWidth,
  }) : super(key: key);

  final double radarWidth;

  @override
  Widget build(BuildContext context) {
    final radarCircleWidth = radarWidth * 0.675;

    return Stack(
      children: [
        BlocBuilder<ImcBloc, ImcState>(
          builder: (context, state) {
            double rotation = 0;
            const initialRotation = -0.05;
            var scoreDifference = 34.5 - 16;
            var maxIntersection = initialRotation + pi;

            if (state.score <= 18.5) {
              scoreDifference = 18.5 - 16;
              maxIntersection = initialRotation + pi / 10;
            } else if (state.score <= 25) {
              scoreDifference = 25 - 16;
              maxIntersection = initialRotation + pi / 3.2;
            } else if (state.score <= 30) {
              scoreDifference = 30 - 16;
              maxIntersection = initialRotation + pi / 1.9;
            }

            rotation = ((state.score - 16) * maxIntersection / scoreDifference);

            if (rotation > initialRotation + 1.98) {
              rotation = initialRotation + 1.98;
            } else if (rotation < initialRotation) {
              rotation = initialRotation;
            }

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: rotation),
              duration: const Duration(milliseconds: 500),
              child: Stack(
                children: [
                  Container(
                    width: radarCircleWidth,
                    height: radarCircleWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 15,
                    child: Transform.rotate(
                      angle: -1,
                      child: CustomPaint(
                        painter: TrianglePainter(
                          strokeWidth: 10,
                          strokeColor: Colors.white,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        child: const SizedBox(
                          width: 12,
                          height: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              builder: (BuildContext context, double angle, Widget? child) {
                return Transform.rotate(
                  angle: angle,
                  child: child,
                );
              },
            );
          },
        ),
        Positioned(
          left: radarCircleWidth * 0.15,
          top: radarCircleWidth * 0.11,
          child: Transform.rotate(
            angle: -0.6,
            child: const Caption(
              '18.5',
              bold: false,
              scaleFactor: 0,
            ),
          ),
        ),
        Positioned(
          left: radarCircleWidth * 0.45,
          top: 2,
          child: const Caption(
            '25.0',
            bold: false,
            scaleFactor: 0,
          ),
        ),
        Positioned(
          left: radarCircleWidth * 0.75,
          top: radarCircleWidth * 0.11,
          child: Transform.rotate(
            angle: 0.5,
            child: const Caption(
              '30.0',
              bold: false,
              scaleFactor: 0,
            ),
          ),
        ),
        Positioned(
          left: radarCircleWidth * 0.43,
          top: 25,
          child: BlocBuilder<ImcBloc, ImcState>(
            builder: (context, state) {
              return H6(
                '${state.score}',
                color: imcCategoryColors[state.category],
                scaleFactor: 0.1,
              );
            },
          ),
        ),
      ],
    );
  }
}

class RadarContainer extends StatelessWidget {
  const RadarContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final normalWeightColor = imcCategoryColors[ImcCategory.normalWeight];
    final overWeightColor = imcCategoryColors[ImcCategory.overWeight];
    final underWeightColor = imcCategoryColors[ImcCategory.underWeight];
    final obesityColor = imcCategoryColors[ImcCategory.obesity];

    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<ImcBloc, ImcState>(
        builder: (context, state) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: state.category == ImcCategory.normalWeight
                            ? normalWeightColor
                            : const Color.fromARGB(255, 128, 233, 131),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            constraints.maxHeight * 0.11,
                          ),
                        ),
                      ),
                      width: constraints.maxWidth / 3.45,
                      height: constraints.maxHeight,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: constraints.maxHeight * 0.15,
                            left: 20,
                          ),
                          child: const Caption(
                            'Peso Normal',
                            color: Colors.white,
                            scaleFactor: 0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: state.category == ImcCategory.overWeight
                            ? overWeightColor
                            : const Color.fromARGB(255, 255, 166, 70),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            constraints.maxHeight * 0.11,
                          ),
                        ),
                      ),
                      width: constraints.maxWidth / 3.45,
                      height: constraints.maxHeight,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: constraints.maxHeight * 0.15,
                            right: 20,
                          ),
                          child: const Caption(
                            'Sobrepeso',
                            color: Colors.white,
                            scaleFactor: 0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: -0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: state.category == ImcCategory.underWeight
                              ? underWeightColor
                              : const Color.fromARGB(255, 252, 241, 92),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(constraints.maxHeight),
                          ),
                        ),
                        // width: 100,
                        width: constraints.maxWidth / 3.7,
                        height: constraints.maxHeight,
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.5,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Subtitle2(
                                "Bajo Peso",
                                color: Colors.white,
                                scaleFactor: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Transform.rotate(
                      angle: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: state.category == ImcCategory.obesity
                              ? obesityColor
                              : const Color.fromARGB(255, 244, 98, 88),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(constraints.maxHeight),
                          ),
                        ),
                        width: constraints.maxWidth / 3.7,
                        height: constraints.maxHeight,
                        child: Center(
                          child: Transform.rotate(
                            angle: 0.5,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Subtitle2(
                                "Obesidad",
                                color: Colors.white,
                                scaleFactor: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return false;
  }
}

class ImcControls extends StatefulWidget {
  const ImcControls({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<ImcControls> createState() => ImcControlsState();
}

class ImcControlsState extends State<ImcControls> {
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  Gender _selectedGender = Gender.men;

  @override
  void initState() {
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CsrInput(
                label: 'Edad',
                controller: _ageController,
                placeholder: 'Ejemplo: 21',
                textType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: GenderSelector(
                onChangeGender: (gender) {
                  _selectedGender = gender;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CsrInput(
                label: 'Estatura (Metros)',
                placeholder: 'Ejemplo: 1.83',
                controller: _heightController,
                textType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: CsrInput(
                controller: _weightController,
                label: 'Peso (Kilos)',
                placeholder: 'Ejemplo: 60',
                textType: TextInputType.number,
              ),
            ),
          ],
        ),
        CsrButton(
          text: 'Calcular IMC',
          onPressed: _calculateImc,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }

  void _calculateImc() {
    ScaffoldMessenger.of(context).clearSnackBars();
    FocusScope.of(context).requestFocus(FocusNode());
    if (_ageController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _weightController.text.isNotEmpty) {
      try {
        if (_weightController.text.contains(',')) {
          _weightController.text =
              _weightController.text.replaceAll(RegExp(r','), '.');
        }

        if (_heightController.text.contains(',')) {
          _heightController.text =
              _heightController.text.replaceAll(RegExp(r','), '.');
        }

        BlocProvider.of<ImcBloc>(context).add(
          Calculate(
            gender: _selectedGender,
            age: int.parse(_ageController.text),
            weight: double.parse(_weightController.text),
            height: double.parse(_heightController.text),
          ),
        );

        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } on FormatException catch (_) {
        csrErrorSnackBar(context, 'Todos lo valores deben ser númericos');
      }
    }
  }
}
