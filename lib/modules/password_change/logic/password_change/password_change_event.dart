part of 'password_change_bloc.dart';

@immutable
abstract class PasswordChangeEvent {
  const PasswordChangeEvent();
}

class RequestPasswordChangeEvent extends PasswordChangeEvent {
  final String documentNumber;
  const RequestPasswordChangeEvent(this.documentNumber);
}

class RetryPasswordChangeRequestEvent extends PasswordChangeEvent {
  const RetryPasswordChangeRequestEvent();
}

class ValidateCodeEvent extends PasswordChangeEvent {
  final String code;
  const ValidateCodeEvent(this.code);
}

class SendNewPassword extends PasswordChangeEvent {
  final String password;
  const SendNewPassword(this.password);
}
