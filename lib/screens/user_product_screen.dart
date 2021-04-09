import 'package:flutter/material.dart';
import '../screens/edit_product.dart';
import '../widgets/user_product_item.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';


class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext ctx )  async {
    await Provider.of<Products>(ctx,listen: false).fetchAndSetProducts();
  }



  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context,listen: false).fetchAndSetProducts();
    final productsData = Provider.of<Products>(context,listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
     body:  RefreshIndicator(
       onRefresh: ()=>_refreshProducts(context),
       child: Container(
         padding: EdgeInsets.all(5),
         child: ListView.builder(
           itemCount: productsData.items.length,
           itemBuilder: (ctx, i) => UserProductItem(
               productsData.items[i].unit, productsData.items[i].title,productsData.items[i].id
           ),
         ),
       ),
     ),
    );

  }
}
