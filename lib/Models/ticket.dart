import 'package:flutter/cupertino.dart';

class Ticket with ChangeNotifier {
  String? firebaseID;
  String? rowDataAddress;
  String? createdBy;
  String? lastEditBy;
  String? openDate;
  String? visitDate;
  String? lastEditDate;
  String? mainCategory;
  String? subCategory;
  String? city;
  String? region;
  Map<String, dynamic>? creatorInfo;
  Map<String, dynamic>? techInfo;
}
