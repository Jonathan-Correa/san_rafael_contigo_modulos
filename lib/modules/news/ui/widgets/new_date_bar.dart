import 'package:csr_design_system/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:csr_design_system/csr_design_system.dart';

class NewDateBar extends StatelessWidget {
  const NewDateBar({
    Key? key,
    required this.date,
  }) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      child: Container(
        height: 60,
        width: screenSize.width * 1,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: CsrConstants.circularRadius,
            topRight: CsrConstants.circularRadius,
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(left: screenSize.height * 0.04),
          alignment: Alignment.centerLeft,
          child: Subtitle2(
            'Fecha: $date',
            color: Colors.white,
            bold: false,
          ),
        ),
      ),
    );
  }
}
