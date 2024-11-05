// Barrett Koster
// hacking from 

import 'dart:io';
import 'dart:typed_data';


void main() async
{ 
  // bind the socket server to an address and port
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9201);
  print("server socket created?");
  // listen for clent connections to the server
  server.listen((client) {
    handleConnection(client);
    
  });
}

void handleConnection(Socket client)
{
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  // listen for events from the client
  client.listen
  ( (Uint8List data) async 
    {
      final message = String.fromCharCodes(data);
      print("msg from client: $message");
      await Future.delayed(Duration(seconds: 1));
      if (message == 'Knock, knock.')
      { client.write('Who is there?');
      }
      else if (message=="hi")
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
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}