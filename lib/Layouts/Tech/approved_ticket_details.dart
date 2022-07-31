import 'dart:convert';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Layouts/Tech/tech_ticket_summary.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
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
import 'package:signature/signature.dart';

bool pageLoading = false;

class ApprovedTicketDetails extends StatefulWidget {
  ApprovedTicketDetails(this.args);
  List<dynamic>? args;

  @override
  State<ApprovedTicketDetails> createState() => _ApprovedTicketDetailsState();
}

String invoiceUrl = 'N/A';
String reportUrl = 'N/A';
String reportName = 'N/A';
String invoiceName = 'N/A';

class _ApprovedTicketDetailsState extends State<ApprovedTicketDetails>
    with RouteAware {
  Ticket? _ticket;
  List<Widget>? _report;
  List<Widget> _summary = [];
  double laborCharges = 0;
  double partAmount = 0;
  bool _isCach = false;
  bool _isLoading = false;
  bool _isSubmitting = false;
  double totalAmount = 0;
  List<SparePart>? _allParts;
  SignatureController? signatureController;

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
    _allParts = widget.args![2] as List<SparePart>;
    signatureController = SignatureController(penColor: Colors.black);
    print(_ticket!.freeVisit);
    if (_ticket!.freeVisit == false) {
      laborCharges = _ticket!.laborCharges! * 1.15;
      if (_ticket!.isCash!) {
        laborCharges = laborCharges / 2;
      }
      totalAmount += laborCharges;
    }
    initDesign(_report, _ticket);
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
                    border: Border.all(color: APP_BAR_COLOR),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${laborCharges.toStringAsFixed(2)}'),
                        const Text('أجور الزيارة'),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
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
                        Text(getTotalAmount(_report)),
                        const Text('المجموع'),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('توقيع العميل'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: APP_BAR_COLOR),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Signature(
                        controller: signatureController!,
                        backgroundColor: Colors.white,
                        height: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    MaterialButton(
                        child: const Text('مسح التوقيع'),
                        onPressed: () {
                          signatureController!.clear();
                        })
                  ],
                ),
              ),
              ButtonWidget(
                  text: 'إرسال',
                  onTap: () async {
                    if (signatureController!.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      Uint8List? bytes =
                          await signatureController!.toPngBytes();
                      String encoded = base64Encode(bytes!);
                      Provider.of<TicketProvider>(context, listen: false)
                          .finalizeTechTicket(_ticket, encoded)
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                        if (value == SC_SUCCESS_RESPONSE) {
                          CoolAlert.show(
                              barrierDismissible: false,
                              context: context,
                              type: CoolAlertType.success,
                              text: 'تم إغلاق التذكرة بنجاح',
                              title: 'نجاح',
                              onConfirmBtnTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    techDownloadRoute,
                                    ModalRoute.withName(techHomeRoute),
                                    arguments: <String>[
                                      invoiceName,
                                      invoiceUrl,
                                      reportName,
                                      reportUrl
                                    ]);
                              });
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('توقيع العميل إلزامي'),
                        backgroundColor: ERROR_COLOR,
                      ));
                    }
                  }),
              const SizedBox(
                height: 15,
              )
            ]),
      ),
    );
  }

  void initDesign(List<Widget>? report, Ticket? ticket) async {
    report!.forEach((element) {
      if (element is MachineCheckWidget) {
        _summary.add(MachineCheckSummaryWidget(element));
      } else if (element is GroupCheckWidget) {
        _summary.add(GroupCheckSummaryWidget(element));
      } else if (element is SparePartWidget) {
        _summary.add(
          ApprovedSparePartWidget(
            element,
            _ticket,
            _allParts!,
          ),
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
  }

  String getTotalAmount(List<Widget>? report) {
    double amount = laborCharges;
    report!.forEach((element) {
      if (element is SparePartWidget) {
        if (element.isFreePart == false) {
          amount +=
              element.selectedPart!.price! * double.parse(element.qty!.text);
        }
      }
    });
    return amount.toStringAsFixed(2);
  }
}

class ApprovedSparePartWidget extends StatefulWidget {
  ApprovedSparePartWidget(this.element, this.ticket, this.allParts, {Key? key})
      : super(key: key);
  SparePartWidget? element;
  Ticket? ticket;
  List<SparePart> allParts;

  @override
  State<ApprovedSparePartWidget> createState() =>
      _ApprovedSparePartWidgetState();
}

class _ApprovedSparePartWidgetState extends State<ApprovedSparePartWidget> {
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
              widget.element!.isFreePart!
                  ? Text('0')
                  : Text(
                      getPartPrice(
                          widget.element!.partNo!.text,
                          widget.element!.qty!.text,
                          widget.allParts,
                          widget.ticket),
                    ),
              Text(widget.element!.qty!.text),
              Text(widget.element!.partNo!.text),
            ],
          ),
        ),
      ),
    );
  }

  String getPartPrice(
      String partNumber, String qty, List<SparePart> allParts, Ticket? ticket) {
    String price = '0';
    if (ticket!.freeParts! == false) {
      SparePart part =
          allParts.firstWhere((element) => element.partNo == partNumber);
      if (part != null) {
        double quantity = double.parse(qty);
        price = (part.price! * quantity).toStringAsFixed(2);
        return price;
      }
      return price;
    } else {
      return '0';
    }
  }
}
