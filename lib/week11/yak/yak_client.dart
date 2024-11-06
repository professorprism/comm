

import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'msg_state.dart';
import 'server_state.dart';
import 'client_state.dart';

import '../../widgets/bb.dart';


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
  
    // Future<Socket> fs = clientSetup(mc, serverIP);
 
    Column c = Column(children:[]);
    c.children.add
    (
          Container
          ( decoration: BoxDecoration( border: Border.all() ),
            child: SizedBox
            ( height: 50, width: 200,
              child: TextField
              (controller:tec, style:TextStyle(fontSize:25)), 
            ),
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
}