part of 'connection_retry_bloc.dart';

@immutable
abstract class ConnectionRetryEvent {
  const ConnectionRetryEvent();
}

class StartCountdown extends ConnectionRetryEvent {
  const StartCountdown();
}

class CurrentCountdown extends ConnectionRetryEvent {
  final int currentCountdown;

  const CurrentCountdown(this.currentCountdown);
}
