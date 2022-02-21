import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Routes/route_names.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with RouteAware {
  bool _isLoading = false;
  bool _obscureText = true;

  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString(LoginHandeler.PHONE_NUMBER) != null) {
      userName = prefs.getString(LoginHandeler.NAME).toString();
      role = prefs.getString(LoginHandeler.ROLE).toString();
      Provider.of<LoginHandeler>(context, listen: false)
          .directUser(context, role.toString());
    }
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, LOGIN_TXT)!),
        centerTitle: true,
        actions: const [LanguageWidget()],
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitPumpingHeart(
              color: APP_BAR_COLOR,
            ))
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 150, child: Image.asset(IMG_LOGO)),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: getTranselted(context, PHONE_HINT),
                          suffixIcon: const Icon(Icons.phone),
                          contentPadding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0)),
                      controller: phoneNumber,
                    ),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: password,
                      decoration: InputDecoration(
                        labelText: getTranselted(context, PASSWORD_HINT)!,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: _viewPassword,
                        ),
                        contentPadding:
                            const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      ),
                      obscureText: _obscureText,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      text: getTranselted(context, LOGIN_TXT).toString(),
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        Provider.of<LoginHandeler>(context, listen: false)
                            .loginUser(context, phoneNumber.text.trim(),
                                password.text.trim())
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ]),
            ),
    );
  }
}
