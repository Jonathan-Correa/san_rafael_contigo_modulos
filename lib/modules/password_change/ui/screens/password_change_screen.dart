import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:csr_design_system/csr_design_system.dart';
import 'package:csr_design_system/widgets/csr_input.dart';
import 'package:csr_design_system/widgets/csr_button.dart';
import 'package:csr_design_system/helpers/form_helper.dart';
import 'package:csr_design_system/helpers/snackbar_helper.dart';
import 'package:csr_shared_modules/modules/password_change/logic/password_change/password_change_bloc.dart';

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({
    Key? key,
    required this.apiUrl,
    required this.apiToken,
    required this.userType,
  }) : super(key: key);

  final String apiUrl;
  final String apiToken;
  final String userType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) {
          return PasswordChangeBloc(
            userType: userType,
            apiToken: apiToken,
            apiUrl: apiUrl,
          );
        },
        child: const _PasswordChangeView(),
      ),
    );
  }
}

class _PasswordChangeView extends StatelessWidget {
  const _PasswordChangeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/logo-simple-icon.svg',
                      height: sizeScreen.height * 0.11,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: sizeScreen.height * 0.025),
                    BlocConsumer<PasswordChangeBloc, PasswordChangeState>(
                      builder: (context, state) {
                        Widget view = const RequestPasswordChange();

                        if (state is PasswordChangeLoadingState) {
                          view = const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is PasswordChangeRequestedState ||
                            state is CodeIsInvalidState) {
                          view = const EnterPasswordChangeCodeScreen();
                        } else if (state is CodeIsValidState) {
                          view = const _ChangePasswordScreen();
                        } else if (state is PasswordChangedState) {
                          view = Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Image.asset(
                              'assets/icons/success.png',
                              height: sizeScreen.height * 0.2,
                              fit: BoxFit.contain,
                            ),
                          );
                        }

                        return Column(
                          children: [
                            H6(
                              state is PasswordChangedState
                                  ? 'Contraseña restablecida con éxito'
                                  : 'Cambiar Contraseña',
                              center: true,
                            ),
                            view,
                          ],
                        );
                      },
                      listener: (context, state) {
                        if (state is PasswordChangeErrorState) {
                          csrErrorSnackBar(context, state.error.message);
                        } else if (state is PasswordChangedState) {
                          csrSuccessSnackBar(
                            context,
                            'Contraseña restablecida correctamente!',
                          );
                        } else if (state is CodeIsInvalidState) {
                          csrErrorSnackBar(
                            context,
                            'El código es incorrecto!',
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RequestPasswordChange extends StatefulWidget {
  const RequestPasswordChange({Key? key}) : super(key: key);

  @override
  State<RequestPasswordChange> createState() => _RequestPasswordChangeState();
}

class _RequestPasswordChangeState extends State<RequestPasswordChange> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late final TextEditingController _documentController;
  bool isLoading = false;

  @override
  void initState() {
    _documentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeScreen.width * 0.1),
            child: CsrInput(
              hideText: false,
              label: 'Ingresa tú número de documento',
              textType: TextInputType.number,
              controller: _documentController,
              validate: validateDocument,
              labelAlignment: MainAxisAlignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeScreen.width * 0.3),
            child: CsrButton(
              color: Theme.of(context).colorScheme.secondary,
              text: 'Envíar',
              onPressed: () {
                if (_documentController.text.length < 3) {
                  return;
                }

                context
                    .read<PasswordChangeBloc>()
                    .add(RequestPasswordChangeEvent(_documentController.text));
              },
            ),
          )
        ],
      ),
    );
  }
}

class EnterPasswordChangeCodeScreen extends StatefulWidget {
  const EnterPasswordChangeCodeScreen({Key? key}) : super(key: key);

  @override
  State<EnterPasswordChangeCodeScreen> createState() =>
      _EnterPasswordChangeCodeScreenState();
}

class _EnterPasswordChangeCodeScreenState
    extends State<EnterPasswordChangeCodeScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late final TextEditingController _digit1;
  late final TextEditingController _digit2;
  late final TextEditingController _digit3;
  late final TextEditingController _digit4;
  late final TextEditingController _digit5;
  late final TextEditingController _digit6;
  bool isLoading = false;

  @override
  void initState() {
    _digit1 = TextEditingController();
    _digit2 = TextEditingController();
    _digit3 = TextEditingController();
    _digit4 = TextEditingController();
    _digit5 = TextEditingController();
    _digit6 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _digit1.dispose();
    _digit2.dispose();
    _digit3.dispose();
    _digit4.dispose();
    _digit5.dispose();
    _digit6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Subtitle1(
              'Ingresa el código de 6 digitos que hemos envíado a tu correo',
              center: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: sizeScreen.width * 0.75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Digit(controller: _digit1),
                _Digit(controller: _digit2),
                _Digit(controller: _digit3),
                _Digit(controller: _digit4),
                _Digit(controller: _digit5),
                _Digit(controller: _digit6, isLast: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              child: const Text('Reenviar Código'),
              onPressed: () {
                final passwordBloc = context.read<PasswordChangeBloc>();
                passwordBloc.add(const RetryPasswordChangeRequestEvent());
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeScreen.width * 0.3),
            child: CsrButton(
              color: Theme.of(context).colorScheme.secondary,
              text: 'Envíar',
              onPressed: () {
                if (!_isCodeComplete()) {
                  return csrErrorSnackBar(
                    context,
                    'El código debe estar completo',
                  );
                }

                context.read<PasswordChangeBloc>().add(ValidateCodeEvent(code));
              },
            ),
          )
        ],
      ),
    );
  }

  bool _isCodeComplete() {
    return _digit1.text.isNotEmpty &&
        _digit2.text.isNotEmpty &&
        _digit3.text.isNotEmpty &&
        _digit4.text.isNotEmpty &&
        _digit5.text.isNotEmpty &&
        _digit6.text.isNotEmpty;
  }

  String get code {
    return _digit1.text +
        _digit2.text +
        _digit3.text +
        _digit4.text +
        _digit5.text +
        _digit6.text;
  }
}

class _Digit extends StatelessWidget {
  const _Digit({
    Key? key,
    required this.controller,
    this.isLast = false,
  }) : super(key: key);

  final TextEditingController controller;
  final bool isLast;

  static const errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final inputSize = screenSize.width * 0.1;

    return SizedBox(
      width: inputSize,
      height: inputSize,
      child: TextField(
        focusNode: FocusNode(),
        onChanged: (value) {
          if (value.length > 1) {
            controller.text = value[0];
          }

          if (value == '') {
            FocusScope.of(context).previousFocus();
          } else if (!isLast) {
            FocusScope.of(context).nextFocus();
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
        ),
      ),
    );
  }
}

class _ChangePasswordScreen extends StatefulWidget {
  const _ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<_ChangePasswordScreen> {
  late final TextEditingController _passwordController;
  late final TextEditingController _validatePasswordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _validatePasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _validatePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FormControl(
            title: 'Contraseña',
            controller: _passwordController,
          ),
          _FormControl(
            title: 'Repetir Contraseña',
            controller: _validatePasswordController,
            onSubmit: () => _onChangePassword(context),
          ),
          CsrButton(
            text: 'Confirmar',
            color: theme.primaryColor,
            onPressed: () => _onChangePassword(context),
          )
        ],
      ),
    );
  }

  void _onChangePassword(BuildContext context) {
    if (!_validatePasswords()) return;
    FocusScope.of(context).requestFocus(FocusNode());
    context
        .read<PasswordChangeBloc>()
        .add(SendNewPassword(_passwordController.text));
  }

  bool _validatePasswords() {
    var status = true;
    var message = '';

    if (_passwordController.text.isEmpty ||
        _validatePasswordController.text.isEmpty) {
      return false;
    }

    if (_passwordController.text.length < 8) {
      message = 'La contraseña debe tener 8 caracteres como mínimo';
      status = false;
    }

    if (_passwordController.text != _validatePasswordController.text) {
      message = 'Las contraseñas no son iguales';
      status = false;
    }

    if (status == false) {
      csrErrorSnackBar(context, message);
    }

    return status;
  }
}

class _FormControl extends StatelessWidget {
  const _FormControl({
    Key? key,
    required this.title,
    required this.controller,
    this.onSubmit,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        H6(title, bold: false),
        CsrInput(
          title: title,
          hideText: true,
          controller: controller,
          textType: TextInputType.text,
          onFieldSumitted: (value) => onSubmit != null ? onSubmit!() : null,
        ),
        SizedBox(height: screenSize.height * 0.025),
      ],
    );
  }
}
