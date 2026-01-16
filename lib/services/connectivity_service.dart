import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionStatus {
  wifiOn,
  wifiOff,
  mobileOn,
  mobileOff,
  offline,
}

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectionStatus> _controller =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get stream => _controller.stream;

  ConnectivityResult? _previousResult;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_handleChange);
    _init();
  }

  Future<void> _init() async {
    final result = await _connectivity.checkConnectivity();
    _previousResult = result;
    _emitStatus(result, null);
  }

  void _handleChange(ConnectivityResult result) {
    _emitStatus(result, _previousResult);
    _previousResult = result;
  }

  void _emitStatus(
    ConnectivityResult current,
    ConnectivityResult? previous,
  ) {
    if (current == ConnectivityResult.none) {
      _controller.add(ConnectionStatus.offline);
      return;
    }

    if (current == ConnectivityResult.wifi) {
      if (previous != ConnectivityResult.wifi) {
        _controller.add(ConnectionStatus.wifiOn);
      }
      return;
    }

    if (current == ConnectivityResult.mobile) {
      if (previous != ConnectivityResult.mobile) {
        _controller.add(ConnectionStatus.mobileOn);
      }
      return;
    }

    if (previous == ConnectivityResult.wifi &&
        current != ConnectivityResult.wifi) {
      _controller.add(ConnectionStatus.wifiOff);
    }

    if (previous == ConnectivityResult.mobile &&
        current != ConnectivityResult.mobile) {
      _controller.add(ConnectionStatus.mobileOff);
    }
  }

  void dispose() {
    _controller.close();
  }
}
