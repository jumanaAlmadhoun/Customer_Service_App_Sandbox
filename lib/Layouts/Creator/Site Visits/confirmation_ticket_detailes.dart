import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Layouts/Tech/tech_ticket_summary.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Tech/check_widget.dart';
import 'package:customer_service_app/Widgets/Tech/comment_widget.dart';
import 'package:customer_service_app/Widgets/Tech/machine_check_widget.dart';
import 'package:customer_service_app/Widgets/Tech/spare_part_widget.dart';
import 'package:customer_service_app/Widgets/Tech/text_widget.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/custom_check_box.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ConfirmationTicketDetails extends StatefulWidget {
  ConfirmationTicketDetails(this.args);
  List<dynamic>? args;

  @override
  State<ConfirmationTicketDetails> createState() =>
      _ConfirmationTicketDetailsState();
}

class _ConfirmationTicketDetailsState extends State<ConfirmationTicketDetails>
    with RouteAware {
  Ticket? _ticket;
  List<Widget>? _report;
  List<Widget> _summary = [];
  double laborCharges = 0;
  double totalAmount = 0;
  double partAmount = 0;
  bool _isCach = false;
  bool _isLoading = false;
  bool _isFreeVisit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    _ticket = widget.args![0] as Ticket;
    _report = widget.args![1] as List<Widget>;
    if (_ticket!.freeVisit! == false) {
      laborCharges = _ticket!.laborCharges! * 1.15;
    }
    initDesign(_report);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Ticket')),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _summary.length,
                  itemBuilder: (context, i) {
                    return _summary[i];
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomCheckBox(
                      title: LBL_FREE_VISIT,
                      value: _ticket!.freeVisit,
                      onChanged: (bool? value) {
                        setState(() {
                          _ticket!.freeVisit = value;
                          Provider.of<TicketProvider>(context, listen: false)
                              .changeLabor(_ticket, value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                  text: 'Approve',
                  onTap: () {
                    // Provider.of<TicketProvider>(context).approveTicket(_ticket);
                  }),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(text: 'Reject', onTap: () {}),
              const SizedBox(
                height: 15,
              ),
            ]),
      ),
    );
  }

  void initDesign(List<Widget>? report) async {
    report!.forEach((element) {
      if (element is MachineCheckWidget) {
        _summary.add(MachineCheckSummaryWidget(element));
      } else if (element is GroupCheckWidget) {
        _summary.add(GroupCheckSummaryWidget(element));
      } else if (element is SparePartWidget) {
        _summary.add(
          ConfirmSparePartSummaryWidget(element, _ticket),
        );
        if (element.partNo!.text.isNotEmpty && element.qty!.text.isNotEmpty) {
          setState(() {
            partAmount += element.amount;
          });
        }
      } else if (element is CommentWidget) {
        if (element.isSelected) {
          _summary.add(
            CommentSummaryWidget(element),
          );
        }
      }
    });
    totalAmount = partAmount + laborCharges;
  }
}

class ConfirmSparePartSummaryWidget extends StatefulWidget {
  ConfirmSparePartSummaryWidget(this.element, this.ticket, {Key? key})
      : super(key: key);
  SparePartWidget? element;
  Ticket? ticket;

  @override
  State<ConfirmSparePartSummaryWidget> createState() =>
      _ConfirmSparePartSummaryWidgetState();
}

class _ConfirmSparePartSummaryWidgetState
    extends State<ConfirmSparePartSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: APP_BAR_COLOR),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.element!.qty!.text),
              Text(widget.element!.partNo!.text),
              CustomCheckBox(
                  title: LBL_FREE_PARTS,
                  value: widget.element!.isFreePart,
                  onChanged: (bool? value) async {
                    setState(() {
                      widget.element!.isFreePart = value;
                      Provider.of<TicketProvider>(context, listen: false)
                          .changePartPrice(widget.ticket, value,
                              widget.element!.partNo!.text);
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
