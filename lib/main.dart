import 'package:egggs_birds_sale/screens/pdf_tr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './util/color.dart';
import './screens/Login_Screen.dart';
import './screens/menu_grid.dart';
import './screens/dm_entry_screen.dart';
import './provider/dmitems.dart';
import './screens/tr_entry_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product.dart';
import './screens/List_tr_data.dart';
import './screens/List_dm_data.dart';
import './screens/dm_details.dart';
import './screens/pdf_dm.dart';
import './screens/dm_entry_gst.dart';
import './provider/products.dart';
import './screens/generateTrPrint.dart';
import './screens/List_dm_gst.dart';
import './screens/dm_details_gst.dart';
import './screens/pdf_dm_gst.dart';
import './screens/List_cm_data.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DmItemNotify(),
                ),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
      ],

      child: MaterialApp(
        title: 'Gosalpur',
        theme: ThemeData(
          primarySwatch:Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
        routes: {
          SalesMenuGrid.id : (context)=>SalesMenuGrid(),
          DmEntryScreen.id : (context)=>DmEntryScreen(),
          TrEntryScreen.id :(context)=>TrEntryScreen(),
          UserProductScreen.routeName : (context)=>UserProductScreen(),
          EditProductScreen.routeName : (context)=>EditProductScreen(),
          ListTrData.id  : (context)=>ListTrData(),
          ListDmData.id : (context)=>ListDmData(),
          DmDetails.id :(context)=>DmDetails(),
          PdfDm.id : (context)=>PdfDm(),
          PdfTr.id : (context)=>PdfTr(),
          DmEntryGst.id :(context)=>DmEntryGst(),
          ListDmGst.id :(context)=>ListDmGst(),
          DmDetailsGst.id : (context)=>DmDetailsGst(),
          PdfDmGst.id : (context)=>PdfDmGst(),
          ListCMData.id : (context)=>ListCMData(),

        },
      ),
    );
  }
}


