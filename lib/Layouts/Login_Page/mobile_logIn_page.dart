import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Helpers/layout_constants.dart';
import '../../Localization/localization_constants.dart';
import '../../Services/login_provider.dart';
import '../../Widgets/button_widget.dart';

class MobileLogInPage extends StatefulWidget {
  Function()? onTap;
  TextEditingController phoneNumber;
  TextEditingController password;
  MobileLogInPage(
      {required this.phoneNumber,
      required this.password,
      required this.onTap,
      Key? key})
      : super(key: key);

  @override
  State<MobileLogInPage> createState() => _MobileLogInPageState();
}

class _MobileLogInPageState extends State<MobileLogInPage> with RouteAware {
  bool _obscureText = true;

  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              controller: widget.phoneNumber,
            ),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: widget.password,
              decoration: InputDecoration(
                labelText: getTranselted(context, PASSWORD_HINT)!,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: _viewPassword,
                ),
                contentPadding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              ),
              obscureText: _obscureText,
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              text: getTranselted(context, LOGIN_TXT).toString(),
              onTap: widget.onTap,
            ),
          ],
        ),
      ]),
    );
  }
}
