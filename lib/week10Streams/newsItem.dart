
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsItem
{
  int id;
  String headline;

  NewsItem( this.id, this.headline );

  NewsItem.fromJson( Map<String,dynamic> json )
  : id = json['id'] ?? 999,
    headline= json['title'] ?? "nothing" 
  ;
}