import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
