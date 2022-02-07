import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Widgets/language_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, 'login_page')!),
        actions: const [LanguageWidget()],
        // title: ,
      ),
      body: Container(),
    );
  }
}
