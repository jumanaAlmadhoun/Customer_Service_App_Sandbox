import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Layouts/Tech/tech_ticket_summary.dart';

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];

  Future<void> fetchTickets(String from) async {
    try {
      _tickets.clear();
      List<Ticket> tickets = [];
      var response = await http.get(Uri.parse('$DB_URL$from.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        String searchText = '';
        searchText += value[Ticket.MACHINE_MODEL] ?? '';
        searchText += value[Ticket.CAFE_LOCATION] ?? '';
        searchText += value[Ticket.CAFE_NAME] ?? '';
        searchText += value[Ticket.CITY] ?? '';
        searchText += value[Ticket.CREATED_BY] ?? '';
        searchText += value[Ticket.CUSTOMER_MOBILE] ?? '';
        searchText += value[Ticket.CONTACT_NUMBER] ?? '';
        searchText += value[Ticket.TICKET_NUMBER] ?? '';
        searchText += value[Ticket.SERIAL_NUMBER] ?? '';
        searchText += value[Ticket.PROBLEM_DESC] ?? '';
        searchText += value[Ticket.RECOMMENDATION] ?? '';
        Map<String, dynamic> items =
            value[Ticket.DELIVERY_ITEMS] as Map<String, dynamic>;
        if (items != null) {
          items.forEach((key, value) {
            searchText += key.toUpperCase();
            searchText += value[0].toString().toUpperCase();
          });
        }
        searchText = searchText.toUpperCase();
        tickets.add(
          Ticket(
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
              firebaseID: key,
              fromTable: from,
              laborCharges: double.parse(value[Ticket.LABOR_CHRGES] ?? '0'),
              deliveryItems:
                  value[Ticket.DELIVERY_ITEMS] as Map<String, dynamic>,
              deliveryType: value[Ticket.DELIVERY_TYPE] ?? '',
              soNumber: value[Ticket.SO_NUMBER] ?? '',
              searchText: searchText),
        );
      });
      _tickets = tickets;
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  Future<String> createNewSanremoTicket(
      Map<String, dynamic>? ticketHeader, String firebaseURL) async {
    try {
      var chargeResponse = await http.get(Uri.parse(
          '$DB_URL$DB_CHARGES/${ticketHeader![Ticket.MACHINE_MODEL]}.json'));
      var chargeData = jsonDecode(chargeResponse.body) as Map<String, dynamic>;
      print(chargeData);
      if (chargeData != null) {
        String charge = chargeData[Ticket.CHARGES_PRICE].toString();
        print(charge);
        ticketHeader.update(
          Ticket.LABOR_CHRGES,
          (value) => charge,
          ifAbsent: () => charge,
        );
      }
      var json = jsonEncode(ticketHeader);
      var response = await http.get(Uri.parse(
          '$OPEN_NEW_TICKET_SCRIPT?ticketHeaders=$json&firebaseURL=$firebaseURL'));
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        return Future.value(SC_SUCCESS_RESPONSE);
      } else {
        return Future.value(SC_FAILED_RESPONSE);
      }
    } catch (ex) {
      return Future.value(SC_FAILED_RESPONSE);
    }
  }

  List<Ticket> get tickets {
    return [..._tickets];
  }

  Future<String> editSanremoTicket(
      Map<String, dynamic> ticketHeader, Ticket? ticket, String toTable) async {
    var chargeResponse = await http.get(Uri.parse(
        '$DB_URL$DB_CHARGES/${ticketHeader[Ticket.MACHINE_MODEL]}.json'));
    var chargeData = jsonDecode(chargeResponse.body) as Map<String, dynamic>;
    if (chargeData != null) {
      String charge = chargeData[Ticket.CHARGES_PRICE].toString();
      ticketHeader.update(
        Ticket.LABOR_CHRGES,
        (value) => charge,
        ifAbsent: () => charge,
      );
    }
    var json = jsonEncode(ticketHeader);
    var response = await http.get(Uri.parse(
        '$EDIT_SANREMO_TICKET_SCRIPT?ticketHeaders=$json&firebaseID=${ticket!.firebaseID}&fromTable=${ticket.fromTable}&toTable=$toTable&DB_URL=$DB_URL'));
    print(response.body);
    var data = jsonDecode(response.body);
    if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
      return Future.value(SC_SUCCESS_RESPONSE);
    }
    return Future.value(SC_FAILED_RESPONSE);
  }

  Future<String> techSubmitSiteVisit(Map<String, dynamic> json,
      Map<String, dynamic> partJson, String? firebaseID) async {
    try {
      var response = await http.get(
          Uri.parse('$DB_URL$DB_ASSIGNED_TICKETS/$userName/$firebaseID.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.update(
        Ticket.TECH_INFO,
        (value) => {
          'infoJson': jsonEncode(json),
          'partsJson': jsonEncode(partJson),
        },
        ifAbsent: () => {
          'infoJson': jsonEncode(json),
          'partsJson': jsonEncode(partJson),
        },
      );
      await http.patch(
        Uri.parse('$DB_URL$DB_ASSIGNED_TICKETS/$userName/$firebaseID.json'),
        body: jsonEncode(data),
      );
      var ticketJson = jsonEncode(data);
      var infoJson = jsonEncode(json);
      var partsJson = jsonEncode(partJson);
      response = await http.get(Uri.parse(
          '$TECH_FILL_SCRIPT?url=$DB_URL$DB_ASSIGNED_TICKETS/$userName/$firebaseID.json'));
      data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        invoiceName = data['invName'];
        invoiceUrl = data['invLink'];
        reportName = data['name'];
        reportUrl = data['URL'];
        return Future.value(SC_SUCCESS_RESPONSE);
      }
    } catch (ex) {
      print(ex);
    }
    return Future.value(SC_FAILED_RESPONSE);
  }

  Future<String> submitNewDeliveryTicket(
      Map<String, dynamic> json, String firebaseUrl) async {
    try {
      var jsonToSend = jsonEncode(json);
      var response = await http
          .get(Uri.parse('$OPEN_NEW_DELIVERY_TICKET?json=$jsonToSend'));
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        String rowDataAddress = data[SC_ROW_ADDRESS_KEY].toString();
        String ticketNumber = data[SC_TICKET_NUMBER_KEY].toString();
        json.update(
          Ticket.ROW_ADDRESS,
          (value) => rowDataAddress,
          ifAbsent: () => rowDataAddress,
        );
        json.update(
          Ticket.TICKET_NUMBER,
          (value) => ticketNumber,
          ifAbsent: () => ticketNumber,
        );
        await http.post(Uri.parse(firebaseUrl), body: jsonEncode(json));
        return Future.value(SC_SUCCESS_RESPONSE);
      }
      return Future.value(SC_FAILED_RESPONSE);
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }

  Future<String> editDeliveryTicket(
      Map<String, dynamic> json, String firebaseUrl) async {
    try {
      var jsonToSend = jsonEncode(json);
      var response = await http
          .get(Uri.parse('$EDIT_DELIVERY_TICKET_SCRIPT?json=$jsonToSend'));
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        await http.patch(Uri.parse(firebaseUrl), body: jsonEncode(json));
        return Future.value(SC_SUCCESS_RESPONSE);
      }
      return Future.value(SC_FAILED_RESPONSE);
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }

  Future<String> submitNewPickupTicket(
      Map<String, dynamic> json, String firebaseUrl) async {
    try {
      var jsonToSend = jsonEncode(json);
      var response =
          await http.get(Uri.parse('$OPEN_NEW_PICUP_TICKET?json=$jsonToSend'));
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        String rowDataAddress = data[SC_ROW_ADDRESS_KEY].toString();
        String ticketNumber = data[SC_TICKET_NUMBER_KEY].toString();
        json.update(
          Ticket.ROW_ADDRESS,
          (value) => rowDataAddress,
          ifAbsent: () => rowDataAddress,
        );
        json.update(
          Ticket.TICKET_NUMBER,
          (value) => ticketNumber,
          ifAbsent: () => ticketNumber,
        );
        await http.post(Uri.parse(firebaseUrl), body: jsonEncode(json));
        return Future.value(SC_SUCCESS_RESPONSE);
      }
      return Future.value(SC_FAILED_RESPONSE);
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }

  Future<String> editPickupTicket(
      Map<String, dynamic> json, String firebaseUrl) async {
    try {
      var jsonToSend = jsonEncode(json);
      var response = await http
          .get(Uri.parse('$EDIT_PICKUP_TICKET_SCRIPT?json=$jsonToSend'));
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        await http.patch(Uri.parse(firebaseUrl), body: jsonEncode(json));
        return Future.value(SC_SUCCESS_RESPONSE);
      }
      return Future.value(SC_FAILED_RESPONSE);
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }

  Future<String> getBackQueueTicket(Ticket? ticket, String firebaseUrl) async {
    try {
      var response = await http.get(Uri.parse(
          '$RETURN_TICKET_FROM_QUEUE?$SC_ROW_ADDRESS_KEY=${ticket!.rowAddress}'));
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        var firebaseTicke = await http.get(Uri.parse(firebaseUrl));
        var ticketData = jsonDecode(firebaseTicke.body) as Map<String, dynamic>;
        await http.post(Uri.parse('$DB_URL$DB_READY_TO_ASSIGN_TICKETS.json'),
            body: jsonEncode(ticketData));
        await http.delete(Uri.parse(firebaseUrl));
        return Future.value(SC_SUCCESS_RESPONSE);
      } else {
        return Future.value(SC_FAILED_RESPONSE);
      }
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }

  Future<String> sendTicketFromQueue(String firebaseUrl) async {
    try {
      var response = await http
          .get(Uri.parse('$SEND_TICKET_FROM_QUEUE_SCRIPT?url=$firebaseUrl'));
      print(response.body);
      var data = jsonDecode(response.body);
      return Future.value(data[SC_STATUS_KEY]);
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }

  Future<String> archiveTicket(Ticket ticket, String? reason) async {
    String url = '$DB_URL${ticket.fromTable}/${ticket.firebaseID}.json';
    var response = await http.get(Uri.parse(
        '$ARCHIVE_TICKET_SCRIPT?url=$url&reason=$reason&userName=$userName'));
    print(response.body);
    var data = jsonDecode(response.body);
    return data[SC_STATUS_KEY];
  }

  Future<void> fetchCustomerTickets() async {
    try {
      var response =
          await http.get(Uri.parse('$DB_URL$DB_CUSTOMER_TICKETS.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {});
    } catch (ex) {}
  }
}
