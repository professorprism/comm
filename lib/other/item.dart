import 'dart:convert';

class Item
{
  final int id;
  final String name;
  final String color;
  final int age; // UNIX time

  // constructor
  Item.fromJson( Map<String, dynamic> parsedJson )
  : id = parsedJson['id'] ?? 998, 
    name = parsedJson['name'] ?? 'bob', 
    color = parsedJson['color'] ?? 'penk',
    age = parsedJson['age'] ?? 150 
  ;

  // constructor
  Item.fromDb( Map<String, dynamic> parsedJson )
  : id = parsedJson['id'] ?? 999 ,
    name = parsedJson['name'] ?? 'bobert',
    color = parsedJson['color'] ?? 'pinko',
    age = parsedJson['age'] ?? 151
  ;

   Item() : id=997, name="bobby", color="rosada", age=200;

  Map<String,dynamic> toMap()
  {
    return <String,dynamic>
    {
      "id": id,
      "name":name,
      "color":color,
      "age":age,
    };
  }
}