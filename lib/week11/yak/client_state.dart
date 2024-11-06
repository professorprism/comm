import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'msg_state.dart';


class ClientState
{
  Socket? client;
  bool isSet = false;

  ClientState();
}

class ClientCubit extends Cubit<ClientState>
{
  ClientCubit(): super( ClientState() );

  Future<Socket> clientSetup( MsgCubit mc, String serverIP) async
  {
    // connect to the socket server
    final socket = await Socket.connect(serverIP, 9201);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    // listen for responses from the server
    socket.listen
    ( (Uint8List data)
      { final serverResponse = String.fromCharCodes(data);
        print('Server: $serverResponse');
      },

      onError: (error) {
        print(error);
        socket.destroy();
      },

      onDone: () {
        print('Server left.');
        socket.destroy();
      },
    );
    return socket;
  }
  
  Future<void> sendMessage(Socket socket, String message) async 
  { print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(seconds: 2));
  }

}