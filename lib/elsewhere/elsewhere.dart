// Barrett Koster 2024
// demo of resizing

// > flutter pub add flutter_localizations --sdk=flutter
// > flutter pub add intl:any

// add to pubspec.yaml
// flutter:
//   generate:true 


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import '../widgets/bb.dart';

void main() async
{ runApp(const ElseWhere());
}

class ElseWhere extends StatelessWidget 
{ const ElseWhere({super.key});

  @override
  Widget build(BuildContext context) 
  { return  MaterialApp
    ( 
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'ElseWhere',
      home:  ElseWhere1(),
    );
  }
}

class ElseWhere1 extends StatelessWidget 
{ const ElseWhere1({super.key});

  @override
  Widget build(BuildContext context)
  { 
    List<Widget> kids = 
    [ Text("bob"),  Text("mary"), Text("jane"), 
      Text(AppLocalizations.of(context)!.helloWorld),
      Localizations.override
      (
        context: context,
        locale: const Locale('es'),
        // Using a Builder here to get the correct BuildContext.
        child: Builder(
          builder: (BuildContext context) {
            return Text(AppLocalizations.of(context)!.helloWorld);
          },
        ),
      ),
    ];

    return Scaffold
    (
      appBar: AppBar( title: Text("Resize"),  ),
      body: Column( children: kids ),
    );
  }
}
