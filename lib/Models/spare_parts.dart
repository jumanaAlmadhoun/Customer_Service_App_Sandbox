// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';

class SparePart with ChangeNotifier {
  static const String PART_NO = 'partNo';
  static const String PRICE = 'priceAfter';
  static const String DESC = 'desc';

  SparePart({this.desc, this.partNo, this.price});
  String? partNo;
  String? desc;
  double? price;
}
