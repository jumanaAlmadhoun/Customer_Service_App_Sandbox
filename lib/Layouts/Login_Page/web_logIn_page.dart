import 'package:flutter/material.dart';

import '../../Helpers/layout_constants.dart';
import '../../Localization/localization_constants.dart';
import '../../Widgets/button_widget.dart';
import '../../Widgets/language_widget.dart';

class WebLogInPage extends StatefulWidget {
  Function()? onTap;
  TextEditingController phoneNumber;
  TextEditingController password;
  WebLogInPage(
      {required this.phoneNumber,
      required this.password,
      required this.onTap,
      Key? key})
      : super(key: key);

  @override
  State<WebLogInPage> createState() => _WebLogInPageState();
}

class _WebLogInPageState extends State<WebLogInPage> {
  bool _obscureText = true;

  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: double.infinity,
            width: size.width / 2,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 245, 232, 161),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(IMG_LOGO)],
            ),
          ),
          Container(
            height: double.infinity,
            width: size.width / 2,
            padding: const EdgeInsets.all(80),
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranselted(context, LOGIN_TXT)!,
                          style: const TextStyle(
                            color: APP_BAR_COLOR,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        LanguageWidget(
                          color: APP_BAR_COLOR,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
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
                    onTap: widget.onTap,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
