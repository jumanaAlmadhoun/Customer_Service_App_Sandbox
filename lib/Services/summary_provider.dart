// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

int openTickets = -1;
int readyToAssignTickets = -1;
int queueTickets = -1;
int assignedTickets = -1;
int pendingTickets = -1;
int siteVisitTickets = -1;
int deliveryTickets = -1;
int exchangeTickets = -1;
int pickupTickets = -1;
int accountingTickets = -1;
int deliveryOpenTickets = -1;
int deliveryAssignedTickets = -1;
int workShopTickets = 0;
int customerCompTickets = -1;
List<Tech> techs = [];
List<Ticket> allTickets = [];

class SummaryProvider with ChangeNotifier {
  Future<void> fetchSummary() async {
    techs.clear();
    openTickets = 0;
    readyToAssignTickets = 0;
    pendingTickets = 0;
    queueTickets = 0;
    assignedTickets = 0;
    customerCompTickets = 0;
    siteVisitTickets = -1;
    accountingTickets = -1;
    deliveryOpenTickets = -1;
    deliveryAssignedTickets = -1;
    try {
      print('object');
      techs.clear();
      allTickets.clear();
      get(Uri.parse('$DB_URL$DB_SITE_VISITS.json')).then((value) {
        openTickets = 0;
        readyToAssignTickets = 0;
        pendingTickets = 0;
        queueTickets = 0;
        assignedTickets = 0;
        customerCompTickets = 0;
        siteVisitTickets = 0;
        accountingTickets = 0;
        deliveryOpenTickets = 0;
        deliveryAssignedTickets = 0;
        var data = jsonDecode(value.body) as Map<String, dynamic>;
        data.forEach((key, value) {
          switch (key) {
            case DB_OPEN_TICKETS:
              openTickets = value.length;
              var innerData = value as Map<String, dynamic>;
              List<Ticket> tempTickets = parseTickets(innerData,
                  DB_OPEN_TICKETS, 'Open Tickets', sanremoEditTicketRoute);
              allTickets.addAll(tempTickets);
              break;
            case DB_DELIVERY_TICKETS:
              deliveryTickets = value.length;
              break;
            case DB_PICKUP_TICKETS:
              pickupTickets = value.length;
              break;
            case DB_ASSIGNED_TICKETS:
              var assignedTable = value as Map<String, dynamic>;
              assignedTable.forEach((key, value) {
                var innerData = value as Map<String, dynamic>;
                assignedTickets += innerData.length;
                for (var i = 0; i < techs.length; i++) {
                  if (techs[i].name == key) {
                    techs[i].assignedTickets = parseTickets(
                        innerData,
                        '$DB_ASSIGNED_TICKETS/${techs[i].name}',
                        'Assigned Tickets',
                        null);
                    allTickets.addAll(parseTickets(innerData,
                        DB_ASSIGNED_TICKETS, 'Assigned Tickets', null));
                  }
                }
                techs.add(Tech(
                    name: key,
                    assignedTickets: parseTickets(
                        innerData,
                        '$DB_ASSIGNED_TICKETS/$key',
                        'Assigned Tickets',
                        null)));
                allTickets.addAll(parseTickets(
                    innerData, DB_ASSIGNED_TICKETS, 'Assigned Tickets', null));
              });
              break;
            case DB_QUEUE_TICKETS:
              var queueTable = value as Map<String, dynamic>;
              queueTable.forEach((key, value) {
                var innerData = value as Map<String, dynamic>;
                queueTickets += innerData.length;
                for (var i = 0; i < techs.length; i++) {
                  if (techs[i].name == key) {
                    techs[i].queueTicket = parseTickets(
                        innerData,
                        '$DB_QUEUE_TICKETS/${techs[i].name}',
                        'Queue Tickets',
                        null);
                    allTickets.addAll(parseTickets(
                        innerData, DB_QUEUE_TICKETS, 'Queue Tickets', null));
                  }
                }
                techs.add(Tech(
                    name: key,
                    queueTicket: parseTickets(innerData,
                        '$DB_QUEUE_TICKETS/$key', 'Queue Tickets', null)));
                allTickets.addAll(parseTickets(
                    innerData, DB_QUEUE_TICKETS, 'Queue Tickets', null));
              });
              break;
            case DB_PENDING_TICKETS:
              pendingTickets = value.length;
              break;
            case DB_READY_TO_ASSIGN_TICKETS:
              readyToAssignTickets = value.length;
              var innerData = value as Map<String, dynamic>;
              List<Ticket> tempTickets = parseTickets(
                  innerData,
                  DB_READY_TO_ASSIGN_TICKETS,
                  'Ready To Assign Tickets',
                  sanremoEditTicketRoute);
              allTickets.addAll(tempTickets);
              break;
            case DB_WORKSHOP_TICKETS:
              workShopTickets = value.length;
              break;
            case DB_COMPLAINT_TICKETS:
              customerCompTickets = value.length;
              break;
          }
        });
        siteVisitTickets = assignedTickets +
            openTickets +
            queueTickets +
            pendingTickets +
            readyToAssignTickets +
            workShopTickets;
        notifyListeners();
      });
      // get(Uri.parse('$DB_URL$DB_EXCHANGE_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   exchangeTickets = data == null ? 0 : data.length;
      //   notifyListeners();
      // });
      // get(Uri.parse('$DB_URL$DB_DELIVERY_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   deliveryTickets = data == null ? 0 : data.length;
      //   notifyListeners();
      // });
      // get(Uri.parse('$DB_URL$DB_PICKUP_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   pickupTickets = data == null ? 0 : data.length;
      //   notifyListeners();
      // });

      // get(Uri.parse('$DB_URL$DB_OPEN_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   openTickets = data == null ? 0 : data.length;
      //   siteVisitTickets += openTickets;
      //   notifyListeners();
      // });
      // get(Uri.parse('$DB_URL$DB_READY_TO_ASSIGN_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   readyToAssignTickets = data == null ? 0 : data.length;
      //   siteVisitTickets += readyToAssignTickets;
      //   notifyListeners();
      // });
      // get(Uri.parse('$DB_URL$DB_PENDING_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   pendingTickets = data == null ? 0 : data.length;
      //   siteVisitTickets += pendingTickets;
      //   notifyListeners();
      // });

      // get(Uri.parse('$DB_URL$DB_QUEUE_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   if (data != null) {
      //     data.forEach((key, value) {
      //       var innerData = value as Map<String, dynamic>;
      //       queueTickets += innerData.length;
      //       for (var i = 0; i < techs.length; i++) {
      //         if (techs[i].name == key) {
      //           techs[i].queueTicket = parseTickets(innerData);
      //         }
      //       }
      //       techs.add(Tech(name: key, queueTicket: parseTickets(innerData)));
      //     });
      //   }
      //   notifyListeners();
      // });
      // get(Uri.parse('$DB_URL$DB_ASSIGNED_TICKETS.json')).then((value) {
      //   var data = jsonDecode(value.body) as Map<String, dynamic>;
      //   if (data != null) {
      //     data.forEach((key, value) {
      //       var innerData = value as Map<String, dynamic>;
      //       assignedTickets += innerData.length;
      //       for (var i = 0; i < techs.length; i++) {
      //         if (techs[i].name == key) {
      //           techs[i].assignedTickets = parseTickets(innerData);
      //         }
      //       }
      //       techs
      //           .add(Tech(name: key, assignedTickets: parseTickets(innerData)));
      //       print(techs.length);
      //     });
      //   }
      //   notifyListeners();
      // });
    } catch (ex) {
      print(ex);
    }
  }

  List<Ticket> parseTickets(Map<String, dynamic> data, String fromTable,
      String label, String? routeName) {
    List<Ticket> tickets = [];
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
            extraContactNumber: value[Ticket.CONTACT_NUMBER] ?? '',
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
            fromTable: fromTable,
            laborCharges: double.parse(value[Ticket.LABOR_CHRGES] ?? '0'),
            deliveryItems: value[Ticket.DELIVERY_ITEMS] as Map<String, dynamic>,
            deliveryType: value[Ticket.DELIVERY_TYPE] ?? '',
            soNumber: value[Ticket.SO_NUMBER] ?? '',
            searchText: searchText,
            label: label,
            routeName: routeName),
      );
    });
    return tickets;
  }
}
