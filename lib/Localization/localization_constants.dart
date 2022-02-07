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
const String TIC_SITE_VISIT = 'site_visit_tickets';
const String TIC_DELIVERY = 'delivery_tickets';
const String TIC_EXCHANGE = 'exchange_tickets';
const String TIC_PICK_UP = 'pick_up_tickets';

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
