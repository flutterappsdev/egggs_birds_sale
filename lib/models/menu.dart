import 'package:flutter/material.dart';

class Menu {
  final String id;
  final String title;
  final Color color;
  final String routeName;
  final IconData icon;

  const Menu({@required this.id, @required this.title, this.color =Colors.blueGrey,this.routeName, this.icon });
}