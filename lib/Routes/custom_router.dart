import 'package:customer_service_app/Layouts/Creator/Delivery/delivery_type_page.dart';
import 'package:customer_service_app/Layouts/Login_Page/login_page.dart';
import 'package:customer_service_app/Layouts/Tech/tech_open_tickets.dart';
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
      case creatorDeliveryTicketsRoute:
        return MaterialPageRoute(builder: (_) => const DeliveryTicketsPage());
      case creatorDeliveryTypeSelection:
        return MaterialPageRoute(builder: (_) => const DeliveryTypePage());
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
        return MaterialPageRoute(builder: (_) => DownloadPage());
      case techTicketInfoRoute:
        return MaterialPageRoute(
            builder: (_) => TechTicketInfoPage(settings.arguments as Ticket));
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
    }
  }
}
