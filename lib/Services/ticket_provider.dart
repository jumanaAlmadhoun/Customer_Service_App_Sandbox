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
            deliveryItems: value[Ticket.DELIVERY_ITEMS] as Map<String, dynamic>,
            deliveryType: value[Ticket.DELIVERY_TYPE] ?? '',
          ),
        );
      });
      _tickets = tickets;
      notifyListeners();
    } catch (ex) {
      print('ex');
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
        var chargeResponse = await http.get(Uri.parse(
            '$DB_URL$DB_CHARGES/${ticketHeader[Ticket.MACHINE_MODEL]}.json'));
        var chargeData =
            jsonDecode(chargeResponse.body) as Map<String, dynamic>;
        print(chargeData);
        if (chargeData != null) {
          String charge = chargeData[Ticket.CHARGES_PRICE].toString();
          ticketHeader.update(
            Ticket.LABOR_CHRGES,
            (value) => charge,
            ifAbsent: () => charge,
          );
        }
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

  Future<String> editSanremoTicket(
      Map<String, dynamic> ticketHeader, Ticket? ticket, String toTable) async {
    var json = jsonEncode(ticketHeader);

    var response = await http
        .get(Uri.parse('$EDIT_SANREMO_TICKET_SCRIPT?ticketHeaders=$json'));

    print(response.body);
    var data = jsonDecode(response.body);
    if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
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
      if (toTable != ticket!.fromTable) {
        await http.post(Uri.parse('$DB_URL$toTable.json'),
            body: jsonEncode(ticketHeader));
        await http.delete(
            Uri.parse('$DB_URL${ticket.fromTable}/${ticket.firebaseID}.json'));
      } else {
        await http.patch(
            Uri.parse('$DB_URL${ticket.fromTable}/${ticket.firebaseID}.json'),
            body: jsonEncode(ticketHeader));
      }
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
      print(ticketJson);
      print(infoJson);
      print(partsJson);
      response = await http.get(Uri.parse(
          '$TECH_FILL_SCRIPT?url=$DB_URL$DB_ASSIGNED_TICKETS/$userName/$firebaseID.json'));
      data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        response = await http.get(Uri.parse(
            '$DB_URL$DB_ASSIGNED_TICKETS/$userName/$firebaseID.json'));
        data = jsonDecode(response.body) as Map<String, dynamic>;
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
      print(jsonToSend);
      var response = await http
          .get(Uri.parse('$EDIT_DELIVERY_TICKET_SCRIPT?json=$jsonToSend'));
      print(response.body);
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        print(firebaseUrl);
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
      print(jsonToSend);
      var response = await http
          .get(Uri.parse('$EDIT_PICKUP_TICKET_SCRIPT?json=$jsonToSend'));
      print(response.body);
      var data = jsonDecode(response.body);
      if (data[SC_STATUS_KEY] == SC_SUCCESS_RESPONSE) {
        print(firebaseUrl);
        await http.patch(Uri.parse(firebaseUrl), body: jsonEncode(json));
        return Future.value(SC_SUCCESS_RESPONSE);
      }
      return Future.value(SC_FAILED_RESPONSE);
    } catch (ex) {
      print(ex);
      return Future.value(SC_FAILED_RESPONSE);
    }
  }
}
