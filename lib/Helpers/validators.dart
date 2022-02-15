import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/src/widgets/framework.dart';

String? validateInput(String? value, BuildContext context) {
  return value!.isEmpty ? getTranselted(context, MSG_INPUT_VALIDATOR)! : null;
}
