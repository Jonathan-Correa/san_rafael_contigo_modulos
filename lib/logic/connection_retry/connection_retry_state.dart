part of 'connection_retry_bloc.dart';

@immutable
abstract class ConnectionRetryState {
  const ConnectionRetryState();
}

class ConnectionRetryInitial extends ConnectionRetryState {
  const ConnectionRetryInitial();
}

class ConnectionRetryCountdown extends ConnectionRetryState {
  final int currentSecond;

  const ConnectionRetryCountdown(this.currentSecond);
}
