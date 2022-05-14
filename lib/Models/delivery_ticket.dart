// ignore_for_file: constant_identifier_names, overridden_fields, annotate_overrides

import 'package:customer_service_app/Models/ticket.dart';

class DeliveryTicket extends Ticket {
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
  static const String CUSTOMER_NAME = 'customerName';
  static const String CUSTOMER_MOBILE = 'customerMobile';
  static const String CAFE_NAME = 'cafeName';
  static const String STATUS = 'status';
  static const String CONTACT_NUMBER = 'extraContactNumber';
  static const String CREATION_DATE = 'creationDate';
  static const String MACHINE_MODEL = 'appDescrption';
  static const String CUSTOMER_NUMBER = 'customerNumber';
  static const String SERIAL_NUMBER = 'serialNumber';
  static const String FROM_TABLE = 'fromTable';
  static const String DID_CONTACT = 'didContact';
  static const String CAFE_LOCATION = 'cafeLocation';
  static const String TECH_NAME = 'techName';

  String? techName;
  String? type;
  String? machineNumber;
  String? machineModel;
  String? customerName;
  String? customerMobile;
  String? extraMobile;
  String? creationDate;
  String? deliveryDate;
  String? status;
  bool? didContact;
  String? city;
  String? mainCategory;
  String? subCategory;
  String? createdBy;
  String? lastEditBy;
  String? cafeName;
}
