import 'package:customer_service_app/Layouts/Login_Page/login_page.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          try {
            var pref = await SharedPreferences.getInstance();
            pref.remove(LoginHandeler.PHONE_NUMBER);
            pref.remove(LoginHandeler.PASSWORD);
            pref.remove(LoginHandeler.NAME);
            pref.remove(LoginHandeler.ROLE);
            Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) {
              ModalRoute.withName(loginRoute);
              return false;
            });
          } catch (ex) {
            print(ex);
          }
        },
        icon: const Icon(Icons.logout));
  }
}
