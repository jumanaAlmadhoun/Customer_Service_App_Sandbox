// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Creator/custom_list_dialgo.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Widgets/Creator/gridviewbuilder_creator.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class OpenTickets extends StatefulWidget {
  const OpenTickets({Key? key}) : super(key: key);

  @override
  _OpenTicketsState createState() => _OpenTicketsState();
}

class _OpenTicketsState extends State<OpenTickets> with RouteAware {
  List<Ticket> _tickets = [];
  List<Ticket> _showedTickets = [];
  bool _isLoading = false;
  bool _search = false;
  CustomListDialog? dialog;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    setState(() {
      _isLoading = true;
    });

    Provider.of<TicketProvider>(context, listen: false)
        .fetchTickets(DB_OPEN_TICKETS)
        .then((value) {
      setState(() {
        _isLoading = false;
        _tickets = Provider.of<TicketProvider>(context, listen: false).tickets;
        _showedTickets = _tickets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? AppBar(
              title: _search
                  ? TextFormField(
                      decoration: InputDecoration(
                          hintText: getTranselted(context, LBL_SEARCH)!,
                          hintStyle: const TextStyle(color: Colors.black)),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          try {
                            _showedTickets = _tickets
                                .where((element) => element.searchText!
                                    .contains(value.toUpperCase()))
                                .toList();
                          } catch (ex) {
                            print(ex);
                          }
                        });
                      },
                    )
                  : Text(getTranselted(context, STA_OPEN)!),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _search = !_search;
                      if (!_search) {
                        _showedTickets = _tickets;
                      }
                      print(_search);
                    });
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            )
          : null,
      body: WebLayout(
          navItem: [
            NavigationBarItem(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, creatorHomeRoute, (route) {
                ModalRoute.withName(creatorHomeRoute);
                return false;
              }),
              text: getTranselted(context, HOME_PAGE_TITLE)!,
            ),
            NavigationBarItem(
              onTap: () => Navigator.pushNamed(context, creatorDashBoardRoute),
              text: 'Dashboard',
            ),
            NavigationBarItem(
              onTap: () {},
              text: getTranselted(context, TODAY_TICKETS)!,
            ),
            NavigationBarItem(
              onTap: () {},
              text: getTranselted(context, CUSTOMER_MGMT)!,
            ),
            NavigationBarItem(
              onTap: () {},
              text: getTranselted(context, SETTINGS)!,
            ),
            const LogoutWidget(),
          ],
          widget: _isLoading
              ? const SpinKitRipple(
                  color: ICON_TEX_COLOR,
                )
              : Column(children: [
                  ResponsiveWrapper.of(context).isLargerThan(TABLET)
                      ? Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            alignment: Alignment.center,
                            height: size.height * 0.1,
                            width: size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90.0),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 51, 51, 51),
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 10.0),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    top: 50.0, bottom: 50.0),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: ICONS_COLOR,
                                  size: 35,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (value) {
                                setState(() {
                                  try {
                                    _showedTickets = _tickets
                                        .where((element) => element.searchText!
                                            .contains(value.toUpperCase()))
                                        .toList();
                                  } catch (ex) {
                                    print(ex);
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: GridViewBuilderCreator(
                      dialog: dialog,
                      list: _showedTickets,
                    ),
                  ),
                ])), /*ListView.builder(
                itemCount: _showedTickets.length,
                itemBuilder: (context, i) {
                  return ;
                },
              )*/
    );
  }
}
