// Barrett Koster  2024
// Database demo .. working from Steve Grider course notes

import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'item.dart';

class DBProvider
{
  Database? db;
  bool ready;

  DBProvider() : ready=false
  { init(); }

  void init() async
  {
    Directory documentsDirectory = await
    getApplicationDocumentsDirectory();
    final String path = '${documentsDirectory.path}/items1.db';
    // print('path = $path');

    db = await openDatabase
    ( path,
      version:1,
      onCreate: ( Database newDb, int version )
      {
        // make the table of Item
        newDb.execute
        ( """
          CREATE TABLE Item
          (
            id INTEGER PRIMARY KEY,
            name TEXT,
            favorite TEXT,
            age INTEGER
          )
          """
        );
      }
    );

    ready = true;
  }

  Future<Item?> fetchItem( int id ) async
  {
    final maps = await db!.query
    ( "Item",
      columns: null, // could specify just some, eg ["title"]
                     // null means get whole record(s)
      where: "id=?", // ? gets replaced by arg below
      whereArgs: [id], // (this syntax avoids SQL injection attack).  
                       // this id is from defintion line of fetchItem()
    );

    //if (maps.length > 0)
    if ( maps.isNotEmpty )
    {
      return Item.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem( Item item )
  {
    return db!.insert
    ( 'Item',  
      item.toMap(),
      // avoid adding when it is already there
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // toss all records from the DB: clear the cache.
  // returns a Future.  
  Future<int> clear()
  {
    return db!.delete('Item'); // db should be defined
      // by the time we need it.
  }
}

