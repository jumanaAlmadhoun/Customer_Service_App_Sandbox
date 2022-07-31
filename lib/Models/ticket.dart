// ignore_for_file: constant_identifier_names

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
  static const String TECH_INFO_FIREBASE = 'techInfoFirebase';
  static const String CUSTOMER_NAME = 'customerName';
  static const String CUSTOMER_MOBILE = 'customerMobile';
  static const String CAFE_NAME = 'cafeName';
  static const String STATUS = 'status';
  static const String CONTACT_NUMBER = 'extraContactNumber';
  static const String SEARCH_TEXT = 'searchText';
  static const String CREATION_DATE = 'creationDate';
  static const String MACHINE_MODEL = 'appDescrption';
  static const String CUSTOMER_NUMBER = 'customerNumber';
  static const String SERIAL_NUMBER = 'serialNumber';
  static const String FROM_TABLE = 'fromTable';
  static const String LABOR_CHARGES = 'laborCharges';
  static const String CHARGES_PRICE = 'priceBefore';
  static const String SO_NUMBER = 'soNumber';
  static const String IS_LATE = 'isLate';
  static const String INV_CONF = 'invConf';
  static const String VIDEO = 'viedo';
  static const String IMAGE = 'image';
  static const String TIME = 'time';
  static const String INFO_JSON = 'infoJson';
  static const String IS_CASH = 'isCash';
  static const String TOTAL_AMOUNT = 'total_amount';

  //---------------
  static const String PROBLEM_DESC = 'problemDesc';
  static const String RECOMMENDATION = 'recomendation';
  static const String VISIT_START_TIME = 'from';
  static const String VISIT_END_TIME = 'to';
  static const String DID_CONTACT = 'didContact';
  static const String FREE_VISIT = 'freeVisit';
  static const String FREE_PARTS = 'freeParts';
  static const String CAFE_LOCATION = 'cafeLocation';
  static const String TECH_NAME = 'techName';
  static const String REPORT_URL = 'reportUrl';
  static const String CLOSE_DATE = 'techCloseDate';
  static const String ASSIGN_DATE = 'assignDate';
  static const String TECH_CLOSE_DATE = 'techCloseDate';
  static const String SOLVED = 'solved';

  static const String SHEET_ID = 'sheetID';
  static const String SHEET_URL = 'sheetURL';
  static const String TICKET_NUMBER = 'ticketNumber';

  static const String STA_OPEN = 'Open';
  static const String STA_QUEUE = 'Queue';
  static const String STA_READY_TO_ASSIGN = 'Ready To Assign';
  static const String STA_SOLVED_BY_PHONE = 'Solved By Phone';
  static const String STA_ASSIGNED = 'Assigned';
  static const String STA_PENDING = 'Pending';
  static const String DELIVERY_CATEGORY = 'Delivery';
  static const String PARTS_DELIVERY = 'Parts And Beans';
  static const String NEW_MACHINE_DELIVERY = 'New Machines';
  static const String CUSTOMER_MACHINE_DELIVERY = 'Customer Machines';
  static const String DELIVERY_ITEMS = 'deliveredItems';
  static const String DELIVERY_TYPE = 'deliveryType';

  static const String PICKUP_CATEGORY = 'Pickup';
  static const String OUT_MACHINE = 'exOut';
  static const String IS_URGENT = 'isUrgent';

  static const String CLI_TIME = 'time';
  static const String CLI_NAME = 'name';
  static const String CLI_MOBILE = 'mobile';
  static const String CLI_CAFE_NAME = 'coffeeName';
  static const String CLI_MACHINE_IMAGE = 'image';
  static const String CLI_VIEDO = 'viedo';
  static const String CLI_LOCATION = 'location';
  static const String CLI_PROBLEM_DESC = 'desc';
  static const String CLI_CITY = 'city';
  static const String CLI_CONTACT = 'contact';
  static const String CLI_TICKET_NUMBER = 'ticketNumber';
  static const String CLI_MACHINE_NUMBER = 'machineNumber';
  static const String CLI_MACHINE_MODEL = 'machineModel';
  static const String REPORT_LINK = 'pdfReportUrl';
  static const String INVOICE_LINK = 'pdfInvUrl';
  static const String INVOICE_NAME = 'pdfInvName';
  static const String REPORT_NAME = 'pdfReportName';

  static const String INFO = 'techInfoFirebase';
  static const String PARTS_JSON = 'partsJson';

  static const String IS_APPROVED_BY = 'isApprovedBy';
  static const String IS_APPROVED = 'isApproved';
  static const String IS_REVIEWING = 'isReviewing';
  static const String IS_REVIEWING_BY = 'isReviewingBy';
  static const String LABOR_CHARGE = 'laborCharges';
  static const String CUSTOMER_SIGNATURE = 'sig';
  static const String START_TIME = 'techStartTime';

  Ticket(
      {this.assignDate,
      this.cafeLocation,
      this.cafeName,
      this.city,
      this.createdBy,
      this.creationDate,
      this.customerMobile,
      this.customerName,
      this.customerNumber,
      this.didContact,
      this.extraContactNumber,
      this.freeParts,
      this.freeVisit,
      this.from,
      this.lastEditBy,
      this.machineModel,
      this.machineNumber,
      this.mainCategory,
      this.problemDesc,
      this.recomendation,
      this.region,
      this.rowAddress,
      this.sheetID,
      this.sheetURL,
      this.status,
      this.subCategory,
      this.techName,
      this.ticketNumber,
      this.to,
      this.visitDate,
      this.firebaseID,
      this.fromTable,
      this.laborCharges,
      this.deliveryItems,
      this.deliveryType,
      this.isUrgent,
      this.searchText,
      this.soNumber,
      this.invoiceLink,
      this.invoiceName,
      this.reportLink,
      this.reportName,
      this.label,
      this.routeName,
      this.isLate,
      this.closeDate,
      this.invConf,
      this.video,
      this.machineImage,
      this.time,
      this.dateTime,
      this.isCash,
      this.totalAmount,
      this.info,
      this.parts,
      this.approvedBy,
      this.isApproved,
      this.laborCharge});

  String? machineModel;
  String? assignDate;
  String? cafeLocation;
  String? cafeName;
  String? city;
  String? createdBy;
  String? creationDate;
  String? customerMobile;
  String? customerName;
  String? customerNumber;
  bool? didContact;
  String? extraContactNumber;
  bool? freeParts;
  bool? freeVisit;
  String? from;
  String? lastEditBy;
  String? mainCategory;
  String? problemDesc;
  String? recomendation;
  String? region;
  String? rowAddress;
  String? machineNumber;
  String? sheetID;
  String? sheetURL;
  String? status;
  String? subCategory;
  String? techName;
  String? ticketNumber;
  String? to;
  String? visitDate;
  String? firebaseID;
  String? fromTable;
  double? laborCharges;
  String? deliveryType;
  bool? isUrgent;
  Map<String, dynamic>? deliveryItems;
  String? searchText;
  String? soNumber;
  String? machineImage;
  String? video;
  String? reportName;
  String? reportLink;
  String? invoiceName;
  String? invoiceLink;
  String? label;
  String? routeName;
  String? closeDate;
  bool? isLate;
  bool? invConf;
  String? time;
  DateTime? dateTime;
  bool? isCash;
  double? totalAmount;
  Map<String, dynamic>? info;
  Map<String, dynamic>? parts;
  bool? isApproved;
  String? approvedBy;
  double? laborCharge;
}
