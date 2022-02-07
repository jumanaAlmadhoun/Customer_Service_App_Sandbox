import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DemoLocalizations {
  DemoLocalizations(this.locale);
  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  Map<String, String>? _localizedValues;

  Future load() async {
    String jsonStringValues =
        await rootBundle.loadString('Languages/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTransletadValue(String? key) {
    return _localizedValues![key];
  }

  static const LocalizationsDelegate<DemoLocalizations> delegate =
      _DemoLocalizationDelegates();
}

class _DemoLocalizationDelegates
    extends LocalizationsDelegate<DemoLocalizations> {
  const _DemoLocalizationDelegates();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalizations> load(Locale locale) async {
    DemoLocalizations localizations = DemoLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_DemoLocalizationDelegates old) => false;
}
