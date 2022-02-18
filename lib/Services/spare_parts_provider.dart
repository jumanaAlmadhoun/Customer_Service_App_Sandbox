import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class SparePartProvider with ChangeNotifier {
  List<SparePart> _parts = [];

  Future<void> fetchSpareParts() async {
    _parts.clear();
    var response = await http.get(Uri.parse('$DB_URL$DB_SPARE_PARTS.json'));
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    List<SparePart> parts = [];
    data.forEach((key, value) {
      parts.add(SparePart(
          desc: value[SparePart.DESC] ?? '',
          price: value[SparePart.PRICE] ?? 0,
          partNo: value[SparePart.PART_NO]));
    });
  }
}
