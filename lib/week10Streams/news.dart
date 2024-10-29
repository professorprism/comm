// Barrett Koster
// doing a stream reader type app (stream from net)
// Working from Grider's news app

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'newsItem.dart';

void main()
{ runApp( News() ); }

class News extends StatelessWidget
{ News({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "news",
      home: Scaffold
      ( appBar: AppBar( title: Text("news") ),
        body: News1()
      ),
    );
  }
}

class News1 extends StatelessWidget
{ News1({super.key});

  @override
  Widget build( BuildContext context )
  { 
    Stream<int> ts = topStream();
    List<int> all = [];

    Stream<NewsItem> sni = topStreamItems();
    List<NewsItem> allni = [];


    return StreamBuilder
    ( stream: sni,
      builder: ( context, snapshot )
      { Column c  = Column( children: [ Text("items")] );
        if (snapshot.hasData )
        { allni.add( snapshot.data! ); }
        for ( NewsItem ni in allni )
        { 
          c.children.add
          ( Row
            ( children:
              [ Text('${ni.id}'),
                Text(ni.headline),
              ],
            )
          );
        }
        return c;
      },
    );
    /*
    return StreamBuilder 
    ( stream: ts,
      builder: ( context, snapshot) 
      {    Column c = Column(children: [ Text("0"), ] );

        if ( snapshot.hasData ) 
        { all.add(snapshot.data!);   
          print("trying to add ...${snapshot.data!}");
        }
        for ( int i in all )
        {
          c.children.add( Text("$i"));
        }
        return c;
      }
    );
    */
  }

  // return the top news story numbers as a stream
  Stream<int> topStream() async*
  {
    List<int> topList = await getTopNumbers();
    for( int sn in topList )
    {
        await Future.delayed( Duration(milliseconds:2000) );
        yield sn;
    }
  }

  Stream<NewsItem> topStreamItems() async*
  { String root = "https://hacker-news.firebaseio.com/v0/";
    List<int> topList = await getTopNumbers();
    for ( int sn in topList )
    {
      final url = Uri.parse('${root}item/${sn}.json');
      final response = await http.get(url);
      Map<String,dynamic> theItem = jsonDecode(response.body);
      NewsItem ni = NewsItem.fromJson( theItem );
      yield ni;
    }
  }



  // fetches an image url from a website.  Takes a while,
  // so we mark it 'async' and it returns a Future.
  Future<List<int>> getTopNumbers() async
  { String root = "https://hacker-news.firebaseio.com/v0/";
    // await Future.delayed( Duration(milliseconds:2000) );
    final url = Uri.parse('${root}topstories.json');
    final response = await http.get(url);
    List<dynamic> dataList = jsonDecode(response.body);
    // print(dataList);
    List<int> topList = [];
    for ( int i=0; i<10; i++ )
    {
        topList.add( dataList[i] );
    }
    print(topList);
    // for ( String k in dataAsMap.keys )
    // { print("k=$k"); }

    return topList;
  }

}