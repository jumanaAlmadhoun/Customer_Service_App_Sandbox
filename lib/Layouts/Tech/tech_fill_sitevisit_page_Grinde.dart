import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/comment.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/spare_parts_provider.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Tech/check_widget.dart';
import 'package:customer_service_app/Widgets/Tech/machine_check_widget.dart';
import 'package:customer_service_app/Widgets/Tech/spare_part_widget.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/Tech/comment_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Widgets/Tech/text_widget.dart';

class TechFillTicketPageGrinde extends StatefulWidget {
  const TechFillTicketPageGrinde(this.ticket, {Key? key}) : super(key: key);
  final Ticket? ticket;
  @override
  _TechFillTicketPageGrindeState createState() =>
      _TechFillTicketPageGrindeState();
}

class _TechFillTicketPageGrindeState extends State<TechFillTicketPageGrinde>
    with RouteAware {
  double totalPrice = 0;
  bool _isLoading = false;
  List<SparePart> _allParts = [];
  List<SparePart> _selectedParts = [];
  List<Widget> _machineCheckDesign = [];
  List<Widget> _spareParts = [];
  List<Comment> _allComments = [];
  bool _isCash = false;
  List<Ticket> _tickets = [];
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

    Provider.of<SparePartProvider>(context, listen: false)
        .fetchSpareParts()
        .then((value) {
      _allParts = Provider.of<SparePartProvider>(context, listen: false).parts;
      Provider.of<TicketProvider>(context, listen: false).fetchComments().then(
        (value) {
          _allComments =
              Provider.of<TicketProvider>(context, listen: false).comments;
          setState(() {
            _isLoading = false;
          });
          initMachineCheckDesign();
        },
      );
    });
  }

  final formKey = GlobalKey<FormState>();
  String? validateNote(value) {
    if (value.isEmpty) {
      return 'هذا الحقل الزامي';
    } else {
      return null;
    }
  }

  String? validatePartNum(value) {
    /*var isNull = _allParts.firstWhere(
        (element) => element.partNo!.toUpperCase() == value!.toUpperCase());*/
    if (value.isEmpty) {
      return 'أدخل رقم القطعة الصحيح';
    } else {
      return null;
    }
  }

  String? validatePartQuantity(value) {
    if (value.isEmpty || value == 0.toString()) {
      return 'أدخل الكمية الصحيحة';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعبئة معلومات التذكرة'),
      ),
      body: _isLoading
          ? const SpinKitChasingDots(
              color: APP_BAR_COLOR,
            )
          : ListView(
              shrinkWrap: true,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _machineCheckDesign.length,
                  itemBuilder: (context, i) {
                    return _machineCheckDesign[i];
                  },
                ),
                ButtonWidget(
                  text: 'إضافة قطع غيار',
                  onTap: () {
                    setState(() {
                      _machineCheckDesign.add(SparePartWidget(
                        allParts: _allParts,
                        isfree: widget.ticket!.freeParts,
                        partNo: TextEditingController(),
                        qty: TextEditingController(),
                      ));
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonWidget(
                  text: 'التالي',
                  onTap: () {
                    String title = validateTechInput();
                    if (title != NA) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(' الرجاء تعبئة $title'),
                        backgroundColor: ERROR_COLOR,
                      ));
                    } else {
                      Navigator.pushNamed(context, techVisitSummaryRoute,
                          arguments: [
                            widget.ticket,
                            _machineCheckDesign,
                            DB_ASSIGNED_TICKETS
                          ]);
                    }
                  },
                ),
              ],
            ),
    );
  }

  void initMachineCheckDesign() {
    _machineCheckDesign = [
      MachineCheckWidget(
        title: 'فحص البرمجة',
        keyJson: '1',
        validate: validateNote,
        comments: null,
        controller: TextEditingController(),
      ),
      MachineCheckWidget(
        title: 'فحص شاشة المطحنة',
        keyJson: '2',
        validate: validateNote,
        comments: getCommentsByCategory(Comment.CLEAN_COMMENTS),
        controller: TextEditingController(),
      ),
      MachineCheckWidget(
        title: 'فحص مفكك التكتلات',
        keyJson: '3',
        validate: validateNote,
        comments: getCommentsByCategory(Comment.CLEAN_COMMENTS),
        controller: TextEditingController(),
      ),
      MachineCheckWidget(
        title: 'فحص جودة الطحنة',
        keyJson: '4',
        validate: validateNote,
        comments: getCommentsByCategory(Comment.CLEAN_COMMENTS),
        controller: TextEditingController(),
      ),
      MachineCheckWidget(
        title: 'فحص حجر الطحن',
        keyJson: '5',
        validate: validateNote,
        comments: getCommentsByCategory(Comment.CLEAN_COMMENTS),
        controller: TextEditingController(),
      ),
      MachineCheckWidget(
        title: 'فحص كابل الكهرباء',
        keyJson: '6',
        validate: validateNote,
        comments: getCommentsByCategory(Comment.WATER_SRC_COMMENTS),
        controller: TextEditingController(),
      ),
      TextWidget(
        title: 'إجمالي عدد الاكواب',
        jsonKey: 'total_cups',
        validate: validateNote,
        controller: TextEditingController(),
      ),
      CommentWidget(title: 'نوصي بنقل المكينة لمركز الصيانة'),
      CommentWidget(
          title: 'نوصي بتعديل التوصيلات \nوالملاحظات حسب توصيات الشركة'),
      TextWidget(
        title: 'ملاحظات الفني',
        jsonKey: 'tech_notes',
        validate: validateNote,
        controller: TextEditingController(),
      ),
    ];
  }

  String validateTechInput() {
    String title = NA;
    for (int i = 0; i < _machineCheckDesign.length; i++) {
      var entery = _machineCheckDesign[i];
      if (entery is MachineCheckWidget) {
        if (entery.isPass == null) {
          title = entery.title!;
          break;
        }
      } else if (entery is TextWidget) {
        if (entery.controller!.text.isEmpty) {
          title = entery.title!;
          break;
        }
      }
    }
    return title;
  }

  List<CommentWidget>? getCommentsByCategory(String category) {
    try {
      List<CommentWidget> commentWidgets = [];
      List<Comment> categoryComments = _allComments
          .where((element) => element.commentCategory == category)
          .toList();
      categoryComments.forEach((element) {
        commentWidgets.add(CommentWidget(
          title: element.comment,
        ));
      });
      return commentWidgets;
    } catch (ex) {
      print('UI Comments ERROR $ex');
    }
  }
}
