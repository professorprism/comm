// Barrett Koster
// This is supposed to be BOTH sides of a
//conversation between processes

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// flutter pub add socket_io
// flutter pub outdated
// flutter pub add socket_io_client
import '../widgets/bb.dart';

void main()
{
  runApp(Yak());
}

class Yak extends StatelessWidget
{ Yak({super.key});
 
  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: 'Yak',
      home: Yak1(),
    );
  }
}

class Yak1 extends StatelessWidget
{ Yak1({super.key});

  @override
  Widget build(BuildContext context)
  { TextEditingController tec = TextEditingController();
    return Scaffold
    ( appBar: AppBar( title: Text("Yak"), ),
      body: Column
      ( children:
        [ ElevatedButton
          ( onPressed: ()
            { Navigator.of(context).push
              ( MaterialPageRoute
                ( builder: (context)
                  { return YakServer(); }
                ) 
              );
            },
            child: BB("server"),
          ),
          ElevatedButton
          ( onPressed: ()
            { Navigator.of(context).push
              ( MaterialPageRoute
                ( builder: (context)
                  { return YakClient( tec.text ); }
                ) 
              );
            },
            child: BB("client"),
          ),
          SizedBox
          ( height: 50, width: 200,
            child: TextField
            (controller:tec, style:TextStyle(fontSize:25)), 
          ),
        ],
      ),
    );
  }
}

class Msg 
{
  bool role; // true=server, false=client
  List<String> conversation;

  Msg( this.role, this.conversation);
}
class MsgCubit extends Cubit<Msg>
{
  MsgCubit() : super( Msg(true,["here we go ...","second line"]) );
  upi( String i )
  { List<String> theList = state.conversation;
    theList.add("${state.role?"server:":"client:"}$i");
    emit( Msg(state.role,theList) );
  }

  upu( String u )
  { List<String> theList = state.conversation;
    theList.add("${state.role?"client:":"server:"}$u");
    emit( Msg(state.role,theList) );
  }

  setRole( bool r ){ emit(Msg(r, state.conversation) ); }
}


class YakServer extends StatelessWidget
{ YakServer({super.key});

  @override
  Widget build(BuildContext context)
  { return Scaffold
    ( appBar: AppBar( title: Text("YakServer"), ),
      body: BlocProvider<MsgCubit>
      ( create: (context) => MsgCubit(),
        child: Builder
        ( builder: (context)
          { MsgCubit mc = BlocProvider.of<MsgCubit>(context);
            serverSetup(mc);
            return BlocBuilder<MsgCubit,Msg>
            ( builder: (context,state)
              { return YakS2(); },
            );
          },
        ),
      ),
    );
  }
}

class YakS2 extends StatelessWidget
{ YakS2({super.key});

  @override
  Widget build( BuildContext context ) 
  { MsgCubit mc = BlocProvider.of<MsgCubit>(context);

    Column c = Column(children:[]);
    for ( String s in mc.state.conversation )
    { c.children.add
      ( Text( s ),
      );
    }

    return SingleChildScrollView
    ( child: c,
    );
  }
}

Future<void> serverSetup( MsgCubit mc) async
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
}

class YakClient extends StatelessWidget
{
  final serverIP;
  YakClient( this.serverIP,{super.key});

  @override
  Widget build(BuildContext context)
  { return Scaffold
    ( appBar: AppBar( title: Text("YakClient"), ),
      body: BlocProvider<MsgCubit>
      ( create: (context) => MsgCubit(),
        child: Builder
        (builder: (context)
          { return BlocBuilder<MsgCubit,Msg>
            ( builder: (context,state)
              { return YakC2(serverIP); },
            );
          },
        ),
      ),
    );
  }
}

class YakC2 extends StatelessWidget
{
  final String serverIP;
  YakC2( this.serverIP, {super.key});

  @override
  Widget build( BuildContext context ) 
  { MsgCubit mc = BlocProvider.of<MsgCubit>(context);
    TextEditingController tec = TextEditingController();
  
    Future<Socket> = clientSetup(mc, serverIP);
 
    Column c = Column(children:[]);
    c.children.add
    (
      SizedBox
      ( height: 50, width: 200,
        child: TextField
        (controller:tec, style:TextStyle(fontSize:25)), 
      ),
    );
    c.children.add
    ( ElevatedButton
      ( onPressed: ()
        { String msg = tec.text;
          mc.upi(msg); 
          // sendMessage( , msg );
        },
        child: BB("client send"),
      )
    );
    for ( String s in mc.state.conversation )
    { c.children.add
      ( Text( s ),
      );
    }

    return SingleChildScrollView
    ( child: c,
    );
  }

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
  
}


Future<void> sendMessage(Socket socket, String message) async 
{ print('Client: $message');
  socket.write(message);
  await Future.delayed(Duration(seconds: 2));
}