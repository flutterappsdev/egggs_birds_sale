import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../models/menu_list.dart';
import '../constant/constants.dart';


class SalesMenuGrid extends StatelessWidget {
  static const id = 'SalesMenuGrid';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text('Hello:$UserName   Area:$AreaName'),
      ),
      body: Container(
        color: Colors.grey,
        child: GridView(
          padding: const EdgeInsets.all(20),
          children: DUMMY_CATEGORIES
              .map((catData) => MenuItem(
            catData.id,
            catData.title,
            catData.color,
            catData.routeName,
            catData.icon,
          ),

          ) .toList(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
        ),
      ),
    );
  }
}


class MenuItem extends StatelessWidget {

  final String title;
  final String id;
  final Color color;
  final String routeName;
  final IconData icon;

  MenuItem(this.id,this.title, this.color,this.routeName,this.icon);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(routeName);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        // child: Text(title),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Icon(icon,size: 40,
              color: Colors.white,
            ),
            Text(title,style: TextStyle(
                color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20
            ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),

      ),
    );
  }
}
