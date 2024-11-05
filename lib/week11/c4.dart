// Barrett Koster
// hacking from comm pair I found on the internet.
// 

import 'dart:io';
import 'dart:typed_data';

void main() async
{

  // connect to the socket server
  final socket = await Socket.connect('localhost', 9201);
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

  print("talk: ");
  String? sed = stdin.readLineSync();
  while (sed! != "quit")
  { print("trying to send: $sed");
    await sendMessage(socket,sed);
    print("talk: ");
    sed = stdin.readLineSync();
  }


  // send some messages to the server
  await sendMessage(socket, 'Knock, knock.');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Orange');
  await sendMessage(socket, "Orange you glad I didn't say banana again?");
}

Future<void> sendMessage(Socket socket, String message) async {
  print('Client: $message');
  socket.write(message);
  await Future.delayed(Duration(seconds: 2));
}