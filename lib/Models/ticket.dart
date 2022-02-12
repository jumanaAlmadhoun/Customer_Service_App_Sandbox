import 'package:flutter/cupertino.dart';

class Ticket with ChangeNotifier {
  String? firebaseID;
  String? rowDataAddress;
  String? createdBy;
  String? lastEditBy;
  String? openDate;
  String? visitDate;
  String? mainCategory;
  String? subCategory;

  Map<String, dynamic>? creatorInfo;
  Map<String, dynamic>? techInfo;
}
