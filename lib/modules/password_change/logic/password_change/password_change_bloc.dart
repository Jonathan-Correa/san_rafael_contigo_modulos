import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csr_shared_modules/models/server_error.dart';
import 'package:csr_shared_modules/modules/password_change/services/password_change_service.dart';

part 'password_change_event.dart';
part 'password_change_state.dart';

class PasswordChangeBloc
    extends Bloc<PasswordChangeEvent, PasswordChangeState> {
  late final PasswordChangeService _passwordChangeService;

  String _code = '';
  String _documentNumber = '';

  PasswordChangeBloc({
    required String userType,
    required String apiUrl,
    required String apiToken,
  })  : _passwordChangeService = PasswordChangeService(
          userType: userType,
          apiToken: apiToken,
          apiUrl: apiUrl,
        ),
        super(const PasswordChangeInitialState()) {
    on<ValidateCodeEvent>(_onValidateCode);
    on<SendNewPassword>(_onSendNewPassword);
    on<RequestPasswordChangeEvent>(
      (event, emit) async {
        _documentNumber = event.documentNumber;
        await _onSendRequest(emit);
      },
    );

    on<RetryPasswordChangeRequestEvent>(
      (event, emit) async => await _onSendRequest(emit),
    );
  }

  Future<void> _onSendRequest(
    Emitter<PasswordChangeState> emit,
  ) async {
    try {
      emit(const PasswordChangeLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      await _passwordChangeService.requestPasswordChange(_documentNumber);
      emit(const PasswordChangeRequestedState());
    } on ServerError catch (e) {
      emit(PasswordChangeErrorState(e));
    } catch (e) {
      emit(
        const PasswordChangeErrorState(
          ServerError(message: 'Ha ocurrido un error al realizar la solicitud'),
        ),
      );
    }
  }

  void _onValidateCode(
    ValidateCodeEvent event,
    Emitter<PasswordChangeState> emit,
  ) async {
    try {
      emit(const PasswordChangeLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      await _passwordChangeService.validateCode(event.code, _documentNumber);
      _code = event.code;
      emit(const CodeIsValidState());
    } on ServerError {
      emit(const CodeIsInvalidState());
    } catch (e) {
      emit(
        const PasswordChangeErrorState(
          ServerError(
            message: 'Ha ocurrido un error al intentar validar el código',
          ),
        ),
      );
    }
  }

  void _onSendNewPassword(
    SendNewPassword event,
    Emitter<PasswordChangeState> emit,
  ) async {
    try {
      emit(const PasswordChangeLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      await _passwordChangeService.changePassword(
        event.password,
        _code,
        _documentNumber,
      );

      emit(const PasswordChangedState());
    } on ServerError catch (e) {
      emit(PasswordChangeErrorState(e));
    } catch (e) {
      emit(
        const PasswordChangeErrorState(
          ServerError(
            message: 'Ha ocurrido un error al cambiar la contraseña',
          ),
        ),
      );
    }
  }
}
