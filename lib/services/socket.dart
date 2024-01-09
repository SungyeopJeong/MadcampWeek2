import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late Socket _socket;
  Socket get socket => _socket;

  SocketService() {
    _socket = io(
      dotenv.get('BASE_URL'),
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
  }

  void connect() {
    _socket.connect();
  }

  void on(String event, Function(dynamic) handler) {
    _socket.on(event, handler);
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }
}
