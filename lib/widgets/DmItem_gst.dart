import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/dmitems.dart';

class DmItemsGst extends StatelessWidget {

  final String id;
  final String prod;
  final int qtynos;
  final double qtykg;
  final double rate;
  final double amount;
  final String hsncode;
  final String taxType;
  final double taxPer;
  final double taxAmount;

  DmItemsGst(
      this.id,
      this.prod,
      this.qtynos,
      this.qtykg,
      this.rate,
      this.amount,
      this.hsncode,
      this.taxType,
      this.taxPer,
      this.taxAmount,
      );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 18),
      ),
      onDismissed: (direction) {
        Provider.of<DmItemNotify>(context,listen: false).removeItem(id);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are u sure?'),
            content: Text('Do you want to remove the item'),
            actions: <Widget>[
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              )
            ],
          ),
        );
      },//ConfirmDismiss

      // child: Card(
      //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      //     child: Padding(
      //       padding: EdgeInsets.all(10),
      //       child: ListTile(
      //         leading: CircleAvatar(
      //           child: Padding(
      //               padding: EdgeInsets.all(5),
      //               child: FittedBox(child: Text(rate.toString()))),
      //         ),
      //         title: Text(prod),
      //         subtitle: Text('Total Amount For Nos.: ${qtynos * rate} /  Total Amount For Kg.: ${qtykg * rate}'),
      //         trailing: Text('Nos. $qtynos  Kg.$qtykg'),
      //       ),
      //     )),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product: $prod  @Rate: $rate'),
          Text('Qty in Nos.: $qtynos  Qty in Kg: $qtykg'),
          Text('Total Amount.: ${amount.toStringAsFixed(0)}'),
          Text('Tax Type: $taxType  Tax%: $taxPer   Tax Amount: $taxAmount'),
          Divider(thickness: 2,)
        ],
      ),



    );
  }
}
