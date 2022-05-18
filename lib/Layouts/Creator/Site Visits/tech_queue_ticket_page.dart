import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Routes/route_names.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/open_ticket_widget.dart';
import '../../../Widgets/web_layout.dart';

class TechQueueTicketPage extends StatefulWidget {
  const TechQueueTicketPage(this.tech, {Key? key}) : super(key: key);
  final Tech? tech;

  @override
  State<TechQueueTicketPage> createState() => _TechQueueTicketPageState();
}

class _TechQueueTicketPageState extends State<TechQueueTicketPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? AppBar(title: Text(widget.tech!.name!))
          : null,
      body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: WebLayout(
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
                onTap: () =>
                    Navigator.pushNamed(context, creatorDashBoardRoute),
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
            widget: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveWrapper.of(context)
                            .isSmallerThan(TABLET)
                        ? 1
                        : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                                ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                            ? 3
                            : 4,
                    childAspectRatio: ResponsiveWrapper.of(context)
                            .isSmallerThan(TABLET)
                        ? 2
                        : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                                ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                            ? 1
                            : 1),
                itemCount: widget.tech!.queueTicket!.length,
                itemBuilder: (context, i) {
                  try {
                    return PopupMenuButton(
                      itemBuilder: ((context) => [
                            PopupMenuItem(
                              child: Text(
                                  getTranselted(context, STA_QUEUE_GET_BACK)!),
                              value: 'Back',
                            ),
                            PopupMenuItem(
                              child: Text(
                                  getTranselted(context, STA_QUEUE_ASSIGN)!),
                              value: 'Send',
                            ),
                          ]),
                      onSelected: (String? value) async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (value == 'Back') {
                          setState(() {
                            _isLoading = true;
                          });
                          Provider.of<TicketProvider>(context, listen: false)
                              .getBackQueueTicket(widget.tech!.queueTicket![i],
                                  '$DB_URL$DB_QUEUE_TICKETS/${widget.tech!.name}/${widget.tech!.queueTicket![i].firebaseID}.json')
                              .then((value) {
                            if (value == SC_SUCCESS_RESPONSE) {
                              setState(() {
                                widget.tech!.queueTicket!.removeAt(i);
                                _isLoading = false;
                              });
                            }
                          });
                        } else if (value == 'Send') {
                          setState(() {
                            _isLoading = true;
                          });
                          Provider.of<TicketProvider>(context, listen: false)
                              .sendTicketFromQueue(
                                  '$DB_URL$DB_QUEUE_TICKETS/${widget.tech!.name}/${widget.tech!.queueTicket![i].firebaseID}.json')
                              .then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (value == SC_SUCCESS_RESPONSE) {
                              setState(() {
                                widget.tech!.queueTicket!.removeAt(i);
                                _isLoading = false;
                              });
                            }
                          });
                        }
                      },
                      child: OpenTicketWidget(
                        cafeName: widget.tech!.queueTicket![i].cafeName,
                        city: widget.tech!.queueTicket![i].city,
                        customerMobile:
                            widget.tech!.queueTicket![i].extraContactNumber,
                        customerName: widget.tech!.queueTicket![i].customerName,
                        date: widget.tech!.queueTicket![i].creationDate,
                        didContact: widget.tech!.queueTicket![i].didContact,
                        machineNumber:
                            widget.tech!.queueTicket![i].machineNumber,
                      ),
                    );
                  } catch (e) {
                    throw Exception(e);
                  }
                }),
          )),
    );
  }
}
