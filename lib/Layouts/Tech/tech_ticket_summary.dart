import 'dart:convert';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/check_widget.dart';
import 'package:customer_service_app/Widgets/comment_widget.dart';
import 'package:customer_service_app/Widgets/custom_check_box.dart';
import 'package:customer_service_app/Widgets/machine_check_widget.dart';
import 'package:customer_service_app/Widgets/spare_part_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import '../../Widgets/text_widget.dart';
import 'tech_fill_sitevisit_page.dart';

String invoiceUrl = 'N/A';
String reportUrl = 'N/A';
String reportName = 'N/A';
String invoiceName = 'N/A';

class TechTicketSummary extends StatefulWidget {
  TechTicketSummary(this.args);
  List<dynamic>? args;
  double? totalAmount = 0;
  @override
  _TechTicketSummaryState createState() => _TechTicketSummaryState();
}

class _TechTicketSummaryState extends State<TechTicketSummary> with RouteAware {
  Ticket? _ticket;
  List<Widget>? _report;
  List<Widget> _summary = [];
  double laborCharges = 0;
  double totalAmount = 0;
  double partAmount = 0;
  bool _isCach = false;
  bool _isLoading = false;
  SignatureController? signatureController;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    invoiceUrl = 'N/A';
    reportUrl = 'N/A';
    reportName = 'N/A';
    invoiceName = 'N/A';
    print('Summary');
    _ticket = widget.args![0] as Ticket;
    _report = widget.args![1] as List<Widget>;
    if (_ticket!.freeVisit! == false) {
      laborCharges = _ticket!.laborCharges! * 1.15;
    }
    signatureController = SignatureController(penColor: Colors.black);
    initDesign(_report);
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملخص الزيارة'),
      ),
      body: ListView(
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(laborCharges.toStringAsFixed(2)),
                        Text('رسوم الزيارة'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(partAmount.toStringAsFixed(2)),
                        Text('قطع الغيار'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(totalAmount.toStringAsFixed(2)),
                        Text('المجموع'),
                      ],
                    ),
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
                    Checkbox(
                        value: _isCach,
                        onChanged: (value) {
                          setState(() {
                            _isCach = value!;
                            if (_isCach) {
                              laborCharges = laborCharges / 2;
                              totalAmount = laborCharges + partAmount;
                            } else {
                              laborCharges = laborCharges * 2;
                              totalAmount = laborCharges + partAmount;
                            }
                          });
                        }),
                    Text('الدفع كاش'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('توقيع العميل'),
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
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonWidget(
            text: 'إرسال',
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              Uint8List? bytes = await signatureController!.toPngBytes();
              String encoded = base64Encode(bytes!);
              Map<String, dynamic> json = getJson();
              Map<String, dynamic> partJson = getPartJson();
              bool hasParts = partJson.length == 0 ? false : true;
              print(partJson.length);
              print(partJson);
              json.update(
                'sig',
                (value) => encoded,
                ifAbsent: () => encoded,
              );
              json.update('isCash', (value) => _isCach,
                  ifAbsent: () => _isCach);
              json.update('total_amount', (value) => totalAmount,
                  ifAbsent: () => totalAmount);
              json.update('has_parts', (value) => hasParts,
                  ifAbsent: () => hasParts);
              Provider.of<TicketProvider>(context, listen: false)
                  .techSubmitSiteVisit(json, partJson, _ticket!.firebaseID)
                  .then((value) {
                if (value == SC_SUCCESS_RESPONSE) {
                  CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      text: 'تم إغلاق التذكرة بنجاح',
                      title: 'نجاح',
                      onConfirmBtnTap: () {
                        Navigator.pushNamed(context, techDownloadRoute);
                      });
                }
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void initDesign(List<Widget>? report) async {
    report!.forEach((element) {
      if (element is MachineChekWidget) {
        _summary.add(MachineCheckSummaryWidget(element));
      } else if (element is GroupCheckWidget) {
        _summary.add(GroupCheckSummaryWidget(element));
      } else if (element is SparePartWidget) {
        _summary.add(
          SparePartSummaryWidget(element),
        );
        if (element.partNo.text.isNotEmpty && element.qty.text.isNotEmpty) {
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

  Map<String, dynamic> getJson() {
    Map<String, dynamic> map = {};
    int commentCounter = 0;
    int partCounter = 0;
    _report!.forEach((element) {
      if (element is MachineChekWidget) {
        map.update(
          '${element.keyJson}_Comment',
          (value) => element.controller!.text,
          ifAbsent: () => element.controller!.text,
        );
        map.update(
          '${element.keyJson}_Pass',
          (value) => element.isPass,
          ifAbsent: () => element.isPass,
        );
      } else if (element is GroupCheckWidget) {
        map.update(
          '${element.keyJson}_Pass',
          (value) => [
            element.isPassG1,
            element.isPassG2,
            element.isPassG3,
            element.isPassG4
          ],
          ifAbsent: () => [
            element.isPassG1,
            element.isPassG2,
            element.isPassG3,
            element.isPassG4
          ],
        );
        map.update(
          '${element.keyJson}_Comment',
          (value) => [
            element.controllerG1!.text,
            element.controllerG2!.text,
            element.controllerG3!.text,
            element.controllerG4!.text,
          ],
          ifAbsent: () => [
            element.controllerG1!.text,
            element.controllerG2!.text,
            element.controllerG3!.text,
            element.controllerG4!.text,
          ],
        );
        map.update(
          '${element.keyJson}_PassL',
          (value) => [
            element.passG1,
            element.passG2,
            element.passG3,
            element.passG4,
          ],
          ifAbsent: () => [
            element.passG1,
            element.passG2,
            element.passG3,
            element.passG4,
          ],
        );
      } else if (element is CommentWidget) {
        if (element.isSelected) {
          map.update(
            'comment_$commentCounter',
            (value) => element.title,
            ifAbsent: () => element.title,
          );
          if (element.moveToWorkshop) {
            map.update(
              'workshop',
              (value) => element.moveToWorkshop,
              ifAbsent: () => element.moveToWorkshop,
            );
          }
          commentCounter++;
        }
      } else if (element is SparePartWidget) {
        if (element.partNo.text.isNotEmpty && element.qty.text.isNotEmpty) {
          String key = element.partNo.text;
          if (map.containsKey(key)) {
            double qty = double.parse(map[key]);
            qty += double.parse(element.qty.text);
            map[key] = qty.toString();
            partCounter++;
          } else {
            map.update(
              key,
              (value) => element.qty.text,
              ifAbsent: () => element.qty.text,
            );
            partCounter++;
          }
        }
      } else if (element is TextWidget) {
        map.update('${element.jsonKey}', (value) => element.controller.text,
            ifAbsent: () => element.controller.text);
      }
    });

    return map;
  }

  Map<String, dynamic> getPartJson() {
    Map<String, dynamic> map = {};
    int partCounter = 0;

    _report!.forEach((element) {
      if (element is SparePartWidget) {
        if (element.partNo.text.isNotEmpty && element.qty.text.isNotEmpty) {
          String key = element.partNo.text;
          if (map.containsKey(key)) {
            double qty = double.parse(map[key]);
            qty += double.parse(element.qty.text);
            map[key] = qty.toString();
          } else {
            map.update(
              key,
              (value) => element.qty.text,
              ifAbsent: () => element.qty.text,
            );
            partCounter++;
          }
        }
      }
    });
    map.update(
      'partsCount',
      (value) => partCounter,
      ifAbsent: () => partCounter,
    );
    return map;
  }
}

class CommentSummaryWidget extends StatelessWidget {
  CommentSummaryWidget(this.element);
  CommentWidget? element;
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(element!.title!),
            ],
          ),
        ),
      ),
    );
  }
}

class SparePartSummaryWidget extends StatelessWidget {
  SparePartSummaryWidget(this.element);
  SparePartWidget? element;

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
              Text(element!.amount.toStringAsFixed(2)),
              Text(element!.qty.text),
              Text(element!.partNo.text)
            ],
          ),
        ),
      ),
    );
  }
}

class GroupCheckSummaryWidget extends StatelessWidget {
  GroupCheckSummaryWidget(this.element);
  GroupCheckWidget? element;
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
          child: Column(
            children: [
              Text(element!.title!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element!.controllerG1!.text),
                  Text(element!.passG1!),
                  const Text('مجموعة 1'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element!.controllerG2!.text),
                  Text(element!.passG2!),
                  const Text('مجموعة 2'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element!.controllerG3!.text),
                  Text(element!.passG3!),
                  const Text('مجموعة 3'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element!.controllerG4!.text),
                  Text(element!.passG4!),
                  const Text('الشاي'),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MachineCheckSummaryWidget extends StatelessWidget {
  MachineCheckSummaryWidget(this.element);
  final MachineChekWidget? element;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: APP_BAR_COLOR),
            borderRadius: BorderRadius.circular(10),
            color: element!.isPass! ? CONTACTED_COLOR : NOT_CONTACTED_COLOR),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element!.pass!),
                  Text(element!.title!.trim()),
                ],
              ),
              Text(element!.controller!.text)
            ],
          ),
        ),
      ),
    );
  }
}
