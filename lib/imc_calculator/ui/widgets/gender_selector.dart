import 'package:flutter/material.dart';
import '/imc_calculator/models/imc_indicator.dart';

class GenderSelector extends StatefulWidget {
  const GenderSelector({
    Key? key,
    required this.onChangeGender,
  }) : super(key: key);

  final void Function(Gender gender) onChangeGender;

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  bool _isMan = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (_isMan == true) {
              widget.onChangeGender(Gender.women);
              setState(() => _isMan = false);
            }
          },
          child: Column(
            children: [
              Icon(
                Icons.woman,
                size: 50,
                color: _isMan ? Colors.grey : null,
              ),
              const Text('Mujer'),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            if (_isMan == false) {
              widget.onChangeGender(Gender.men);
              setState(() => _isMan = true);
            }
          },
          child: Column(
            children: [
              Icon(
                Icons.man,
                size: 50,
                color: _isMan ? null : Colors.grey,
              ),
              const Text('Hombre'),
            ],
          ),
        )
      ],
    );
  }
}
