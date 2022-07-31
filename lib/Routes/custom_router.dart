// ignore_for_file: unused_import

import 'package:customer_service_app/Layouts/Creator/Customer%20Tickets/customer_ticket_info.dart';
import 'package:customer_service_app/Layouts/Creator/Customer%20Tickets/customer_tickets.dart';
import 'package:customer_service_app/Layouts/Creator/DashBoard/creator_dashboard.dart';
import 'package:customer_service_app/Layouts/Creator/Delivery/delivery_type_page.dart';
import 'package:customer_service_app/Layouts/Creator/Delivery/edit_machine_delivery_ticket.dart';
import 'package:customer_service_app/Layouts/Creator/Delivery/edit_parts_delivery_ticket.dart';
import 'package:customer_service_app/Layouts/Creator/Delivery/new_machine_delivery_ticket.dart';
import 'package:customer_service_app/Layouts/Creator/Delivery/new_parts_delivery_ticket.dart';
import 'package:customer_service_app/Layouts/Creator/Pickup/edit_pickup_ticket_page.dart';
import 'package:customer_service_app/Layouts/Creator/Pickup/new_pickup_ticket_page.dart';
import 'package:customer_service_app/Layouts/Creator/Pickup/pickup_tickets_page.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/assigned_tickets_page.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/confirmation_ticket_detailes.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/confirmation_tickets_page.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/pending_tickets_page.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/queue_tickets_page.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/tech_assigned_tickets.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/tech_queue_ticket_page.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/workshop_tickets_page.dart';
import 'package:customer_service_app/Layouts/Login_Page/login_page.dart';
import 'package:customer_service_app/Layouts/Tech/approved_ticket_details.dart';
import 'package:customer_service_app/Layouts/Tech/approved_tickets_page.dart';
import 'package:customer_service_app/Layouts/Tech/edit_submitted_ticket_page.dart';
import 'package:customer_service_app/Layouts/Tech/machine_number_confirmation_page.dart';
import 'package:customer_service_app/Layouts/Tech/rejected_tickets_page.dart';
import 'package:customer_service_app/Layouts/Tech/tech_close_tickets_page.dart';
import 'package:customer_service_app/Layouts/Tech/tech_open_tickets.dart';
import 'package:customer_service_app/Layouts/Tech/tech_pending_tickets_page.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:flutter/material.dart';
import '../Layouts/Admin/admin_home_page.dart';
import '../Layouts/Admin/rent_machine_dashboard.dart';
import '../Layouts/Admin/tech_report_page.dart';
import '../Layouts/Creator/Delivery/delivery_tickets_page.dart';
import '../Layouts/Creator/Site Visits/brand_selection_page.dart';
import '../Layouts/Creator/Site Visits/creator_site_visit_tickets_page.dart';
import '../Layouts/Creator/Site Visits/edit_sanremo_ticket.dart';
import '../Layouts/Creator/Site Visits/open_tickets_page.dart';
import '../Layouts/Creator/Site Visits/ready_to_assign_tickets_page.dart';
import '../Layouts/Creator/Site Visits/sanremo_new_ticket_page.dart';
import '../Layouts/Creator/creator_home_page.dart';
import '../Layouts/Tech/download_page.dart';
import '../Layouts/Tech/tech_fill_sitevisit_page.dart';
import '../Layouts/Tech/tech_home_page.dart';
import '../Layouts/Tech/tech_ticket_info_page.dart';
import '../Layouts/Tech/tech_ticket_summary.dart';

class CustomRouter {
  static Route<dynamic>? allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case creatorHomeRoute:
        return MaterialPageRoute(builder: (_) => const CreatorHomePage());
      case creatorPendingTicketsRoute:
        return MaterialPageRoute(builder: (_) => const PendingTickets());
      case creatorDashBoardRoute:
        return MaterialPageRoute(builder: (_) => const CreatorDashBoard());
      case creatorQueueTicketsRoute:
        return MaterialPageRoute(builder: (_) => const QueueTikcketsPage());
      case creatorDeliveryTicketsRoute:
        return MaterialPageRoute(builder: (_) => const DeliveryTicketsPage());
      case creatorAssignedTicketRoute:
        return MaterialPageRoute(builder: (_) => const AssignedTikcketsPage());
      case creatorNewPickupTicketRoute:
        return MaterialPageRoute(builder: (_) => const NewPickupTicket());
      case creatorPickupTicketsRoute:
        return MaterialPageRoute(builder: (_) => const PickupTicketsPage());
      case creatorDeliveryTypeSelection:
        return MaterialPageRoute(builder: (_) => const DeliveryTypePage());
      case creatorWorkshopTicketRoute:
        return MaterialPageRoute(builder: (_) => const WorkshopTickets());
      case creatorCustomerTicketsRoute:
        return MaterialPageRoute(builder: (_) => const CustomerTickets());
      case creatorNewMachineDeliveryRoute:
        return MaterialPageRoute(
            builder: (_) => const NewMachineDeliveryTicket());
      case creatorPartsDeliveryRoute:
        return MaterialPageRoute(
            builder: (_) => const NewPartsDeliveryTicket());
      case creatorSiteVisitRoute:
        return MaterialPageRoute(builder: (_) => const CreatorSiteVisitPage());
      case brandSelectionRoute:
        return MaterialPageRoute(builder: (_) => const BrandSelectionPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case sanremoNewTicketRoute:
        return MaterialPageRoute(builder: (_) => const SanremoNewTicketPage());
      case creatorOpenTicketsRoute:
        return MaterialPageRoute(builder: (_) => const OpenTickets());
      case creatorReadyToAssignTicketsRoute:
        return MaterialPageRoute(builder: (_) => const ReadyToAssignTickets());
      case techHomeRoute:
        return MaterialPageRoute(builder: (_) => const TechHomePage());
      case techOpenTicketRoute:
        return MaterialPageRoute(builder: (_) => const TechOpenTicketPage());
      case adminHomeRoute:
        return MaterialPageRoute(builder: (_) => const AdminHomePage());
      case adminRentMachineRoute:
        return MaterialPageRoute(builder: (_) => const RentMachineDashboard());
      case adminTechReportRoute:
        return MaterialPageRoute(builder: (_) => const TechReportPage());
      case techDownloadRoute:
        var args = settings.arguments as List<String>;
        return MaterialPageRoute(
            builder: (_) => DownloadPage(
                  invoiceName: args[0],
                  invoiceURL: args[1],
                  reportName: args[2],
                  reportUrl: args[3],
                ));
      case techCloseTicketsRoute:
        return MaterialPageRoute(builder: (_) => TechCloseTicketsPage());
      case creatorCustomerTicketInfoRoute:
        return MaterialPageRoute(
            builder: (_) => CustomerTicketInfo(settings.arguments as Ticket));
      case techTicketInfoRoute:
        return MaterialPageRoute(
            builder: (_) => TechTicketInfoPage(settings.arguments as Ticket));
      case creatorEditPartsDeliveryRoute:
        return MaterialPageRoute(
            builder: (_) =>
                EditPartsDeliveryTicket(settings.arguments as Ticket));
      case creatorEditPickupTicketRoute:
        return MaterialPageRoute(
            builder: (_) => EditPickupTicketPage(settings.arguments as Ticket));
      case techConfirmMachineNumberRoute:
        return MaterialPageRoute(
            builder: (_) =>
                MachineNumberConfirmationPage(settings.arguments as Ticket));
      case creatorEditNewMachineDeliveryRoute:
        return MaterialPageRoute(
            builder: (_) =>
                EditMachineDeliveryTicket(settings.arguments as Ticket));
      case techFillSiteVisitRoute:
        return MaterialPageRoute(
            builder: (_) => TechFillTicketPage(settings.arguments as Ticket));
      case techVisitSummaryRoute:
        return MaterialPageRoute(
            builder: (_) =>
                TechTicketSummary(settings.arguments as List<dynamic>));
      case sanremoEditTicketRoute:
        return MaterialPageRoute(
            builder: (_) =>
                EditSanremoNewTicketPage(settings.arguments as Ticket));
      case creatorTechAssignedTicketRoute:
        return MaterialPageRoute(
            builder: (_) => TechAssignedTicketPage(settings.arguments as Tech));
      case creatorTechQueueTicketRoute:
        return MaterialPageRoute(
            builder: (_) => TechQueueTicketPage(settings.arguments as Tech));

      case techPendingTicketsRoute:
        return MaterialPageRoute(builder: (_) => TechPendingTicketsPage());
      case techEditRejectedTicketRoute:
        return MaterialPageRoute(
            builder: (_) =>
                EditSubmittedTicketPage(settings.arguments as Ticket));
      case techApprovedTicketRoute:
        return MaterialPageRoute(builder: (_) => ApprovedTicketPage());

      case creatorConfirmTicketRoute:
        return MaterialPageRoute(builder: (_) => ConfirmationTickets());
      case creatorConfirmDetailsRoute:
        return MaterialPageRoute(
            builder: (_) =>
                ConfirmationTicketDetails(settings.arguments as List<dynamic>));
      case techApprovedTicketDetailsRoute:
        return MaterialPageRoute(
            builder: (_) =>
                ApprovedTicketDetails(settings.arguments as List<dynamic>));

      case techRejectedTicketRoute:
        return MaterialPageRoute(builder: (_) => RejectedTicketsPage());
    }
  }
}
