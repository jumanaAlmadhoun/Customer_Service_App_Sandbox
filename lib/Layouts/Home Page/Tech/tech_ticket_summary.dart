import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Widgets/check_widget.dart';
import 'package:customer_service_app/Widgets/comment_widget.dart';
import 'package:customer_service_app/Widgets/machine_check_widget.dart';
import 'package:customer_service_app/Widgets/spare_part_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';

class TechTicketSummary extends StatefulWidget {
  TechTicketSummary(this.args);
  List<dynamic>? args;
  @override
  _TechTicketSummaryState createState() => _TechTicketSummaryState();
}

class _TechTicketSummaryState extends State<TechTicketSummary> with RouteAware {
  Ticket? _ticket;
  List<Widget>? _report;
  List<Widget> _summary = [];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    print('Summary');
    _ticket = widget.args![0] as Ticket;
    _report = widget.args![1] as List<Widget>;
    initDesign(_report);
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملخص الزيارة'),
      ),
      body: ListView(children: _summary),
    );
  }

  void initDesign(List<Widget>? report) {
    print('object');
    report!.forEach((element) {
      if (element is MachineChekWidget) {
        _summary.add(MachineCheckSummaryWidget(element));
      } else if (element is GroupCheckWidget) {
        _summary.add(GroupCheckSummaryWidget(element));
      } else if (element is SparePartWidget) {
        _summary.add(
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
                    Text(element.amount.toStringAsFixed(2)),
                    Text(element.qty.text),
                    Text(element.partNo.text)
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (element is CommentWidget) {
        if (element.isSelected) {
          _summary.add(
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
                      Text(element.title!),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
    });
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
