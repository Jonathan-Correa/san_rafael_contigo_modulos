part of 'password_change_bloc.dart';

@immutable
abstract class PasswordChangeState {
  const PasswordChangeState();
}

class PasswordChangeInitialState extends PasswordChangeState {
  const PasswordChangeInitialState() : super();
}

class PasswordChangeLoadingState extends PasswordChangeState {
  const PasswordChangeLoadingState() : super();
}

class PasswordChangeRequestedState extends PasswordChangeState {
  const PasswordChangeRequestedState() : super();
}

class CodeIsInvalidState extends PasswordChangeState {
  const CodeIsInvalidState() : super();
}

class CodeIsValidState extends PasswordChangeState {
  const CodeIsValidState() : super();
}

class PasswordChangedState extends PasswordChangeState {
  const PasswordChangedState() : super();
}

class PasswordChangeErrorState extends PasswordChangeState {
  final ServerError error;
  const PasswordChangeErrorState(this.error) : super();
}
