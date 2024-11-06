
import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'msg_state.dart';
import 'server_state.dart';
import 'client_state.dart';

class YakServer extends StatelessWidget
{ YakServer({super.key});

  @override
  Widget build(BuildContext context)
  { return Scaffold
    ( appBar: AppBar( title: Text("YakServer"), ),
      body: BlocProvider<MsgCubit>
      ( create: (context) => MsgCubit(),
        child: BlocProvider<ServerCubit>
        ( create: (context) => ServerCubit(),
          child: BlocProvider<ClientCubit>
          ( create: (context) => ClientCubit(),
            child: BlocBuilder<MsgCubit,Msg>
            ( builder: (context,state)
              { return YakS2(); 
              },
            ),
          ),
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
