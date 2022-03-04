import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/logout_widget.dart';
import 'package:customer_service_app/Widgets/Admin/primary_text.dart';
import 'package:flutter/material.dart';

class TechTicketInfoPage extends StatefulWidget {
  TechTicketInfoPage(this.ticket);
  Ticket? ticket;
  @override
  _TechTicketInfoPageState createState() => _TechTicketInfoPageState();
}

class _TechTicketInfoPageState extends State<TechTicketInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات التذكرة'),
        actions: const [LogoutWidget()],
      ),
      body: ListView(
        children: [
          TicketInfoCard(
            title: 'تاريخ التذكرة',
            content: widget.ticket!.assignDate,
          ),
          TicketInfoCard(
            title: 'اسم العميل',
            content: widget.ticket!.customerName,
          ),
          TicketInfoCard(
            title: 'رقم التواصل',
            content: widget.ticket!.extraContactNumber,
          ),
          TicketInfoCard(
            title: 'اسم المقهى',
            content: widget.ticket!.cafeName,
          ),
          TicketInfoCard(
            title: 'عنوان المقهى',
            content: widget.ticket!.cafeLocation,
            isURL: true,
          ),
          TicketInfoCard(
            title: 'المدينة',
            content: widget.ticket!.city,
          ),
          TicketInfoCard(
            title: 'وصف المشكلة',
            content: widget.ticket!.problemDesc,
          ),
          TicketInfoCard(
            title: 'موديل المكينة',
            content: widget.ticket!.machineModel,
          ),
          TicketInfoCard(
            title: 'رقم المكينة',
            content: widget.ticket!.machineNumber,
          ),
          TicketInfoCard(
            title: 'التوصية الفنية',
            content: widget.ticket!.recomendation,
          ),
          TicketInfoCard(
            title: 'التاريخ المحدد للزيارة',
            content: widget.ticket!.visitDate,
          ),
          TicketInfoCard(
            title: 'الوقت المحدد للزيارة',
            content: '${widget.ticket!.from} To ${widget.ticket!.to}',
          ),
          ButtonWidget(
            text: 'التالي',
            onTap: () {
              Navigator.pushNamed(context, techFillSiteVisitRoute,
                  arguments: widget.ticket);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonWidget(
            text: 'رفض التذكرة',
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class TicketInfoCard extends StatelessWidget {
  TicketInfoCard({this.content, this.isURL = false, this.title});
  final String? title;
  final String? content;
  final bool? isURL;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: APP_BAR_COLOR),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryText(
                  text: title,
                ),
                PrimaryText(
                  text: content,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: isURL! ? () {} : () {},
    );
  }
}
