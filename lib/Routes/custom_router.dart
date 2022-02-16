import 'package:customer_service_app/Layouts/Home%20Page/Creator/brand_selection_page.dart';
import 'package:customer_service_app/Layouts/Home%20Page/Creator/creator_home_page.dart';
import 'package:customer_service_app/Layouts/Home%20Page/Creator/creator_site_visit_tickets_page.dart';
import 'package:customer_service_app/Layouts/Home%20Page/Creator/open_tickets_page.dart';
import 'package:customer_service_app/Layouts/Home%20Page/Creator/sanremo_new_ticket_page.dart';
import 'package:customer_service_app/Layouts/Login_Page/login_page.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic>? allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case creatorHomeRoute:
        return MaterialPageRoute(builder: (_) => const CreatorHomePage());
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
    }
  }
}
