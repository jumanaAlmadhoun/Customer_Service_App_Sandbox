// ignore_for_file: constant_identifier_names

import 'package:customer_service_app/Localization/demo_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? getTranselted(BuildContext context, String? key) {
  return DemoLocalizations.of(context).getTransletadValue(key);
}

const String ENGLISH = 'en';
const String ARABIC = 'ar';
const String LANGUAGE_CODE = 'languageCode';
const String HOME_PAGE_TITLE = 'home_page';
const String LOGIN_TXT = 'login_page';
const String TIC_SITE_VISIT = 'site_visit_tickets';
const String TIC_DELIVERY = 'delivery_tickets';
const String TIC_EXCHANGE = 'exchange_tickets';
const String TIC_PICK_UP = 'pick_up_tickets';
const String CUSTOMER_MGMT = 'customer_mgmt';
const String TODAY_TICKETS = 'today_task';
const String SETTINGS = 'settings';
const String TIC_ACCOUNTING = 'accounting_tickets';
const String STA_OPEN = 'open_tickets';
const String STA_WAITING = 'waiting_tickets';
const String STA_QUEUE = 'queue_tickets';
const String STA_ASSIGNED = 'assigned_tickets';
const String STA_PENDING = 'pending_tickets';
const String STA_WAITING_CONFIRMATION = 'waiting_confirmation_tickets';
const String BRAND_SELECTION = 'brand_selection';
const String PASSWORD_HINT = 'password';
const String PHONE_HINT = 'phone_number';
const String NEW_SANREMO_TICKET = 'new_sanremo_ticket';
const String LBL_MACHINE_NUMBER = 'machine_number';
const String LBL_MACHINE_MODEL = 'machine_model';
const String LBL_CUSTOMER_NUMBER = 'customer_number';
const String LBL_CUSTOMER_NAME = 'customer_name';
const String LBL_CUSTOMER_BALANCE = 'customer_balance';
const String LBL_MOBILE = 'mobile';
const String LBL_CAFE_NAME = 'cafe_name';
const String LBL_CAFE_LOCATION = 'cafe_location';
const String LBL_CITY = 'city';
const String LBL_PROBLEM_DESC = 'problem_desc';
const String LBL_RECOMMENDATION = 'recommendation';
const String LBL_VISIT_SCHEDULE = 'visit_schedule';
const String LBL_FROM = 'from';
const String LBL_TO = 'to';
const String LBL_TECH_NAME = 'tech_name';
const String LBL_DID_CONTACT = 'did_contact';
const String LBL_FREE_VISIT = 'free_visit';
const String LBL_FREE_PARTS = 'free_parts';
const String LBL_DIRECT_ASSIGN = 'direct_assign';
const String LBL_PUSH_QUEUE = 'push_queue';
const String LBL_READY_ASSIGN = 'ready_to_assign';
const String LBL_EXTRA_NUMBER = 'add_number';
const String LBL_SOLVED_BY_PHONE = 'solved_by_phone';
const String LBL_VISIT_CATEGORY = 'tickets_category';
const String BTN_SUBMIT = 'submit';
const String MSG_INPUT_VALIDATOR = 'field_error';
const String ERR_TITL = 'error';
const String ERR_UNKWON_TXT = 'field_error';
const String ERR_ASSIGN = 'assign_err';
const String LBL_CUSTOMER_BLOCKED = 'customer_blocked';
const String LBL_SEARCH = 'search';
const String LBL_DATE = 'date_lbl';
const String LBL_CAFE = 'cafe_lbl';
const String LBL_NAME = 'name_lbl';
const String LBL_PHONE = 'phone_lbl';
const String EDIT_SANREMO_TICKET = 'edit_sanremo_ticket';
const String STA_RENT_MACHINES = 'rent_machine';
const String STA_TECHS_REPORT = 'tech_report';
const String STA_WORKSHOP = 'workshop_ticket';
const String LBL_DELIVERY_TYPE = 'delivery_type';
const String LBL_MACHINES = 'machines';
const String LBL_DELIVERY_NEW_MACHINE = 'delivery_new';
const String LBL_DELIVERY_CUSTOMER_MACHINE = 'delivery_cus';
const String LBL_BEANS = 'beans';
const String LBL_ITEM_NO = 'item_no';
const String LBL_QTY = 'qty';
const String LBL_DESCRIPTION = 'desc';
const String LBL_ADD_ITEM = 'add_item';
const String LBL_DELIVERY_CATEGORY = 'delivery_category';
const String LBL_SO_NUMBER = 'so_number';
const String STA_QUEUE_GET_BACK = 'get_back';
const String STA_QUEUE_ASSIGN = 'queue_assign';
const String LBL_URGENT = 'urgent';
const String BTN_SEND = 'send';
const String BTN_CANCEL = 'cancel';
const String LBL_CHOOSE_REASON = 'choose_archive';
const String TIC_CUSTOMER_TICKETS = 'client_ticket';
const String TIC_CUSTOMER_COMP_TICKETS = 'customer_comp_tickets';
const String VIEW_OPEN_TICKETS = 'view_open_tickets';
const String VIEW_CLOSED_TICKETS = 'view_closed_tickets';
const String LOGOUT = 'logout';
const String LBL_CONFIRM_INVOICE = 'inv_confirmation';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale? _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;
    case ARABIC:
      _temp = Locale(languageCode, 'SA');
      break;
  }
  return _temp!;
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}
