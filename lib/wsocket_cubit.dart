import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketCubit extends Cubit<WebSocketChannel> {
  SocketCubit()
      : super(WebSocketChannel.connect(
            Uri.parse('ws://besquare-demo.herokuapp.com')));
}
