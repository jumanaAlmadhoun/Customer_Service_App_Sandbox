import 'dart:convert';

import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TicketProvider with ChangeNotifier {
  Future<String> createNewSanremoTicket(
      Map<String, dynamic>? ticketHeader, String firebaseURL) async {
    try {
      var json = jsonEncode(ticketHeader);
      var response = await http
          .get(Uri.parse('$OPEN_NEW_TICKET_SCRIPT?ticketHeaders=$json'));
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        String sheetID = data[SC_SHEET_ID_KEY];
        String sheetURL = data[SC_SHEET_URL_KEY];
        String rowAddress = data[SC_ROW_ADDRESS_KEY].toString();
        String ticketNumber = data[SC_TICKET_NUMBER_KEY].toString();
        ticketHeader!.update(Ticket.SHEET_ID, (value) => sheetID,
            ifAbsent: () => sheetID);
        ticketHeader.update(Ticket.ROW_ADDRESS, (value) => rowAddress,
            ifAbsent: () => rowAddress);
        ticketHeader.update(Ticket.SHEET_URL, (value) => sheetURL,
            ifAbsent: () => sheetURL);
        ticketHeader.update(Ticket.TICKET_NUMBER, (value) => ticketNumber,
            ifAbsent: () => ticketNumber);
        await http.post(Uri.parse(firebaseURL), body: jsonEncode(ticketHeader));
        return Future.value(SC_SUCCESS_RESPONSE);
      } else {
        return Future.value(SC_FAILED_RESPONSE);
      }
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }
}
