import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csr_design_system/config/constants.dart';
import 'package:csr_design_system/csr_design_system.dart';
import 'package:csr_design_system/widgets/csr_button.dart';

import '/logic/connection_retry/connection_retry_bloc.dart';

class ErrorMessageWidget extends StatefulWidget {
  final String message;
  final void Function()? onRefresh;

  const ErrorMessageWidget({
    Key? key,
    required this.message,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<ErrorMessageWidget> createState() => _ErrorMessageWidgetState();
}

class _ErrorMessageWidgetState extends State<ErrorMessageWidget> {
  bool isLoading = false;
  late final ConnectionRetryBloc _connectionRetryBloc;

  @override
  void initState() {
    _connectionRetryBloc = ConnectionRetryBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeScreen = MediaQuery.of(context).size;

    return Center(
      child: Container(
        padding: EdgeInsets.all(sizeScreen.width * 0.05),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: -25.0,
              blurRadius: 15.0,
              offset: const Offset(0, 5),
              color: CsrConstants.optionColorGrey.withOpacity(0.5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: sizeScreen.width,
                  padding: EdgeInsets.all(sizeScreen.width * 0.05),
                  color: theme.primaryColor,
                  child: Icon(
                    CSRIcons.shieldExclamation,
                    color: Colors.white,
                    size: sizeScreen.width * 0.1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(sizeScreen.width * 0.05),
                  child: H5(widget.message, center: true, bold: false),
                ),
                if (widget.onRefresh != null)
                  BlocBuilder(
                    bloc: _connectionRetryBloc,
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: CsrButton(
                          icon: state is ConnectionRetryInitial
                              ? const Icon(Icons.refresh_outlined)
                              : Text(
                                  (state as ConnectionRetryCountdown)
                                      .currentSecond
                                      .toString(),
                                ),
                          text: 'Reintentar',
                          color: theme.primaryColor,
                          onPressed: state is ConnectionRetryInitial
                              ? () {
                                  if (widget.onRefresh != null) {
                                    widget.onRefresh!();
                                    _connectionRetryBloc
                                        .add(const StartCountdown());
                                  }
                                }
                              : null,
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
