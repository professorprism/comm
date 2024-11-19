// Barrett Koster
// keyboard demo

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/bb.dart';
import 'item.dart';
import 'db_provider.dart';

class ShowState
{
  Item currentItem = Item();
  ShowState( this.currentItem );
}
class ShowCubit extends Cubit<ShowState>
{
  ShowCubit() : super( ShowState( Item() ) );
  void set( Item i ) { emit( ShowState(i) ); }
  void fetchItem( DBProvider dbp, int id ) async
  { Item? item = await dbp.fetchItem(id);
    if ( item==null ) { item = Item(); }
    emit( ShowState(item) );
  }
}

void main() async
{ runApp( DB() );
}

class DB extends StatelessWidget 
{ DB({super.key});
  final title = "DB Demo";

  final DBProvider dbp = DBProvider();

  @override
  Widget build(BuildContext context) 
  { return  MaterialApp
    ( 
      title: title,
      home: Scaffold
      ( appBar: AppBar( title: BB(title) ),
        body: BlocProvider<ShowCubit>
        ( create: (context) => ShowCubit(),
          child: BlocBuilder<ShowCubit,ShowState>
          ( builder: (context,state)
            { return DD1(dbp); },
          ),
        ),
      ),
    );
  }
}

class DD1 extends StatelessWidget 
{ final DBProvider dbp;
  DD1(this.dbp,{super.key});
  final TextEditingController tec = TextEditingController();

  @override
  Widget build(BuildContext context)
  { ShowCubit sc = BlocProvider.of<ShowCubit>(context);
    TextEditingController tecId = TextEditingController();
    TextEditingController tecName = TextEditingController();
    TextEditingController tecColor = TextEditingController();
    TextEditingController tecAge = TextEditingController();
    print("-------------------- building KD1");
 
    Item item = sc.state.currentItem;
    tecId.text = item.id.toString();
    tecName.text = item.name;
    tecColor.text = item.color;
    tecAge.text = item.age.toString();
    
    return Row
    ( children:
      [
        Column // data shows in this column
        ( children:
          [ dataRow( "id",    tecId,    sc ),
            dataRow( "name",  tecName,  sc ),
            dataRow( "color", tecColor, sc ),
            dataRow( "age",   tecAge,   sc ),
          ],
        ),
        Column // buttons to add or find go in this column
        ( children:
          [ ElevatedButton
            ( onPressed: ()
              { Item item = Item.fill
                ( int.parse(tecId.text),
                  tecName.text,
                  tecColor.text,
                  int.parse(tecAge.text),
                );
                dbp.addItem(item);
              },
              child: Text("save"),
            ),
            ElevatedButton
            ( onPressed: ()
              { sc.fetchItem(dbp,int.parse(tecId.text));
              },
              child: Text("load by id"),
            ),
          ],
        ),
      ],
    );
  }

  Widget dataRow( String label, TextEditingController tec, ShowCubit sc )
  { return Row
    ( children:
      [ BB(label),
        SizedBox
        ( height: 50, width: 200,
          child: TextField
          ( controller:tec, style:TextStyle(fontSize: 25) , ), 
        ),
      ],
    );
  }
}

