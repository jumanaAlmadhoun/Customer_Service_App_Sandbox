import 'package:customer_service_app/Layouts/Home%20Page/Creator/creator_home_page.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic>? allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case creatorHomeRoute:
        return MaterialPageRoute(builder: (_) => const CreatorHomePage());
    }
  }
}
