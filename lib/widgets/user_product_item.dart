import 'package:flutter/material.dart';
import '../provider/products.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String imageURL;
  final String tittle;
  final String id;
  UserProductItem(this.imageURL, this.tittle, this.id);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(child: Text(imageURL.toString()))),
      ),
      title: Text(tittle),
      trailing: Container(
        width: 120,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
