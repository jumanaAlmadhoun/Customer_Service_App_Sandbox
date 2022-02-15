import 'package:flutter/cupertino.dart';

class Ticket with ChangeNotifier {
  static const String SITE_VISIT_CATEGORY = 'Site Visit';
  static const String FIREBASE_ID = 'firebaseID';
  static const String ROW_ADDRESS = 'rowDataAddress';
  static const String CREATED_BY = 'createdBy';
  static const String LAST_EDIT_BY = 'lastEditBy';
  static const String VISIT_DATE = 'visitDate';
  static const String LAST_EDIT_DATE = 'lastEditDate';
  static const String MAIN_CATEGORY = 'mainCategory';
  static const String SUB_CATEGORY = 'subCategory';
  static const String CITY = 'city';
  static const String REGION = 'region';
  static const String CREATION_INFO = 'creatorInfo';
  static const String TECH_INFO = 'techInfo';
  static const String CUSTOMER_NAME = 'customerName';
  static const String CUSTOMER_MOBILE = 'customerMobile';
  static const String CAFE_NAME = 'cafeName';
  static const String STATUS = 'status';
  static const String CONTACT_NUMBER = 'extraContactNumber';

  Ticket(
      {this.city,
      this.createdBy,
      this.creatorInfo,
      this.firebaseID,
      this.lastEditBy,
      this.lastEditDate,
      this.mainCategory,
      this.openDate,
      this.region,
      this.rowDataAddress,
      this.subCategory,
      this.techInfo,
      this.visitDate,
      this.cafeName,
      this.customerMobile,
      this.customerName,
      this.status});

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
  String? customerName;
  String? cafeName;
  String? customerMobile;
  String? status;
  Map<String, dynamic>? creatorInfo;
  Map<String, dynamic>? techInfo;
}
