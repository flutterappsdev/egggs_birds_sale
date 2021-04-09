import 'package:flutter/foundation.dart';

class DmItem {
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

  DmItem({
    @required this.id,
    @required this.prod,
    @required this.qtynos,
    @required this.qtykg,
    @required this.rate,
    @required this.amount,
    @required this.hsncode,
    this.taxType,
    this.taxPer,
    this.taxAmount,

  });
}

class DmItemNotify with ChangeNotifier {
  List<DmItem> _dmItems = [];

  List<DmItem> get items {
    return [..._dmItems];
  }

  void additems(String id, String prod, int qtynos, double qtykg, double rate,
      double amount, String hsncode,String taxType,double taxPer, double taxAmount) {
    _dmItems.add(DmItem(
        id: id,
        prod: prod,
        qtynos: qtynos,
        qtykg: qtykg,
        rate: rate,
        amount: amount,
        hsncode: hsncode,
        taxType: taxType,
        taxPer: taxPer,
        taxAmount: taxAmount,
        ),);
    notifyListeners();
  }

  void removeItem(String id) {

    final existingProductIndex = _dmItems.indexWhere((prod) => prod.id == id);
    var existingProduct = _dmItems[existingProductIndex];
    _dmItems.removeAt(existingProductIndex);
    notifyListeners();
  }

  void clearList()
  {
    _dmItems.clear();
  }

}
