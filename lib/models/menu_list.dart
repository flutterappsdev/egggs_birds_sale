import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/menu.dart';

const DUMMY_CATEGORIES = const [
  Menu(
    id: 'c1',
    title: 'TR Creation',
    color: Colors.teal,
    routeName: 'TrEntryScreen',
    icon: Icons.add_box
  ),
  Menu(
    id: 'c2',
    title: 'Supply',
    color: Colors.cyan,
    icon: FontAwesomeIcons.supple,
    routeName: 'DmEntryScreen'

  ),

  Menu(
      id: 'c11',
      title: 'Supply With GST',
      color: Colors.purpleAccent,
      icon: FontAwesomeIcons.supple,
      routeName: 'DmEntryGst'

  ),

  Menu(
    id: 'c7',
    title: 'Supply List',
    color: Colors.lightBlue,
      icon: FontAwesomeIcons.listAlt,
    routeName: 'ListDmData'
  ),

  Menu(
      id: 'c7',
      title: 'Supply List GST',
      color: Colors.lightBlue,
      icon: FontAwesomeIcons.list,
      routeName: 'ListGstDm'
  ),

  Menu(
      id: 'c7',
      title: 'Cash Memo',
      color: Colors.deepOrangeAccent,
      icon: FontAwesomeIcons.list,
      routeName: 'ListCMData'
  ),

  Menu(
    id: 'c10',
    title: 'TR List',
    routeName: 'ListTrData',
    color: Colors.lightGreen,
      icon: FontAwesomeIcons.list
  ),

  Menu(
      id: 'c10',
      title: 'Add Product',
      routeName: '/user-products',
      color: Colors.red,
      icon: Icons.add_circle_outline
  ),
];