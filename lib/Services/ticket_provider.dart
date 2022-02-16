import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];

  Future<void> fetchTickets(String from) async {
    try {
      _tickets.clear();
      List<Ticket> tickets = [];
      var response = await http.get(Uri.parse('$DB_URL$from.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        tickets.add(Ticket(
            machineModel: value[Ticket.MACHINE_MODEL] ?? '',
            assignDate: value[Ticket.ASSIGN_DATE] ?? '',
            cafeLocation: value[Ticket.CAFE_LOCATION] ?? '',
            cafeName: value[Ticket.CAFE_NAME] ?? '',
            city: value[Ticket.CITY] ?? '',
            createdBy: value[Ticket.CREATED_BY] ?? '',
            creationDate: value[Ticket.CREATION_DATE] ?? '',
            customerMobile: value[Ticket.CUSTOMER_MOBILE] ?? '',
            customerName: value[Ticket.CUSTOMER_NAME] ?? '',
            customerNumber: value[Ticket.CUSTOMER_NUMBER] ?? '',
            didContact: value[Ticket.DID_CONTACT] ?? false,
            extraContactNumber: value[Ticket.CONTACT_NUMBER],
            freeParts: value[Ticket.FREE_PARTS] ?? false,
            freeVisit: value[Ticket.FREE_PARTS] ?? false,
            from: value[Ticket.VISIT_START_TIME] ?? '',
            to: value[Ticket.VISIT_END_TIME] ?? '',
            lastEditBy: value[Ticket.LAST_EDIT_BY] ?? '',
            mainCategory: value[Ticket.MAIN_CATEGORY] ?? '',
            problemDesc: value[Ticket.PROBLEM_DESC] ?? '',
            recomendation: value[Ticket.RECOMMENDATION] ?? '',
            region: value[Ticket.REGION] ?? '',
            rowAddress: value[Ticket.ROW_ADDRESS] ?? '',
            machineNumber: value[Ticket.SERIAL_NUMBER] ?? '',
            sheetID: value[Ticket.SHEET_ID] ?? '',
            sheetURL: value[Ticket.SHEET_URL] ?? '',
            status: value[Ticket.STATUS] ?? '',
            subCategory: value[Ticket.SUB_CATEGORY] ?? '',
            techName: value[Ticket.TECH_NAME] ?? '',
            ticketNumber: value[Ticket.TICKET_NUMBER] ?? '',
            visitDate: value[Ticket.VISIT_DATE] ?? '',
            firebaseID: key));
        _tickets = tickets;
        notifyListeners();
      });
    } catch (ex) {
      print(ex);
    }
  }

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

  List<Ticket> get tickets {
    return [..._tickets];
  }
}
