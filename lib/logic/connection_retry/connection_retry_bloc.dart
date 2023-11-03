import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'connection_retry_event.dart';
part 'connection_retry_state.dart';

class ConnectionRetryBloc
    extends Bloc<ConnectionRetryEvent, ConnectionRetryState> {
  Timer? timer;

  ConnectionRetryBloc() : super(const ConnectionRetryInitial()) {
    on<ConnectionRetryEvent>((event, emit) async {
      const maxSeconds = 26;

      if (event is StartCountdown) {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          add(CurrentCountdown(timer.tick));
        });
      } else if (event is CurrentCountdown) {
        final countdown = maxSeconds - event.currentCountdown;

        if (countdown <= 0) {
          timer != null ? timer!.cancel() : null;
          emit(const ConnectionRetryInitial());
        } else {
          emit(ConnectionRetryCountdown(countdown));
        }
      }
    });
  }
}
