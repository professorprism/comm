// server_state.dart
// holds the ServerSocket when that gets set.


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'msg_state.dart';


class ServerState
{
  ServerSocket? ss;
  bool ssset = false; // false until we get it set

  ServerState(); // default state does nothing; server is NOT set yet.

  ServerState.set(this.ss) : ssset=true;
}

class ServerCubit extends Cubit<ServerState>
{
  ServerCubit() : super( ServerState() );

  Future<void> setup( MsgCubit mc) async
  {
    if (!state.ssset)
    {
      final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9201);
      print("server socket created");
      // listen for clent connections to the server
      server.listen
      ( (client)
        { print('Connection from'
            ' ${client.remoteAddress.address}:${client.remotePort}');

          // listen for events from the client
          client.listen
          ( (Uint8List data) async 
            {
              final message = String.fromCharCodes(data);
              print("client: $message");
              // await Future.delayed(Duration(seconds: 1));
              if (message=="hi")
              { client.write("hi, back"); }
              else if (message=="bye")
              { client.write('ok, bye');
                client.close();
              } 
            },

            // handle errors
            onError: (error) {
              print(error);
              client.close();
            },

            // handle the client closing the connection
            onDone: ()
            { print('Client left');
              client.close();
            },
          );
        }
      );
      emit( ServerState.set(server) );
    } // end if
  } // end setup()
} // end class ServerCubit

