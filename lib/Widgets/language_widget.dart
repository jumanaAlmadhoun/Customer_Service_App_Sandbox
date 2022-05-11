import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

import '../Helpers/layout_constants.dart';
import '../main.dart';

class LanguageWidget extends StatefulWidget {
  Color color;
  LanguageWidget({this.color = Colors.white, Key? key}) : super(key: key);

  @override
  _LanguageWidgetState createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      icon: Icon(
        Icons.language,
        color: widget.color,
      ),
      underline: Container(),
      items: const [
        DropdownMenuItem(
          child: Text('English'),
          value: ENGLISH,
        ),
        DropdownMenuItem(
          child: Text('العربية / Arabic'),
          value: ARABIC,
        ),
      ],
      onChanged: (String? value) {
        if (value == ENGLISH) {
          _changeLanguage(ENGLISH);
        } else {
          _changeLanguage(ARABIC);
        }
      },
    );
  }

  void _changeLanguage(String languageCode) async {
    Locale? _temp = await setLocale(languageCode);
    MyApp.setLocale(context, _temp);
  }
}
