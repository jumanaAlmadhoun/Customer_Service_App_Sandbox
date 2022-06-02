// ignore_for_file: import_of_legacy_library_into_null_safe, unused_field, prefer_final_fields

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/spare_parts_provider.dart';
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

class TechFillTicketPage extends StatefulWidget {
  const TechFillTicketPage(this.ticket, {Key? key}) : super(key: key);
  final Ticket? ticket;
  @override
  _TechFillTicketPageState createState() => _TechFillTicketPageState();
}

class _TechFillTicketPageState extends State<TechFillTicketPage>
    with RouteAware {
  double totalPrice = 0;
  bool _isLoading = false;
  List<SparePart> _allParts = [];
  List<SparePart> _selectedParts = [];
  List<Widget> _machineCheckDesign = [];
  List<Widget> _spareParts = [];
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
      setState(() {
        _isLoading = false;
      });
    });

    initMachineCheckDesign();
  }

  final formKey = GlobalKey<FormState>();
  String? validateNote(value) {
    if (value.isEmpty) {
      return 'required';
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
                          arguments: [widget.ticket, _machineCheckDesign]);
                    }
                  },
                ),
              ],
            ),
    );
  }

  void initMachineCheckDesign() {
    _machineCheckDesign = [
      MachineChekWidget(
        title: 'قطع مكسورة أو مفقودة',
        keyJson: '1',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'نظافة المكينة العامة',
        keyJson: '2',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص وجود تهريبات في المكينة',
        keyJson: '3',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص العدادات',
        keyJson: '4',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص مصدر الماء',
        keyJson: '5',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص جودة تسخين الحليب',
        keyJson: '6',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص التوصيلات والسلامة العامة',
        keyJson: '7',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص ضغط المضخة الرئيسية (بار)',
        keyJson: '8',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص وحدة التحكم بالبخار',
        keyJson: '9',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص قوة البخار',
        keyJson: '10',
        validate: validateNote,
      ),
      MachineChekWidget(
        title: 'فحص سرعة الفتح والاغلاق للبخار',
        keyJson: '11',
        validate: validateNote,
      ),
      TextWidget(
        title: 'عدد الأكواب',
        jsonKey: 'total_cups',
        validate: validateNote,
      ),
      TextWidget(
        title: 'إصدار برنامج التشغيل',
        jsonKey: 'os',
        validate: validateNote,
      ),
      GroupCheckWidget(
        title: 'ضغط رأس المجموعة',
        keyJson: 'G1',
      ),
      GroupCheckWidget(
        title: 'فحص جودة الاستخلاص',
        keyJson: 'G2',
      ),
      GroupCheckWidget(
        title: 'فحص البورت فيلتر',
        keyJson: 'G3',
      ),
      GroupCheckWidget(
        title: 'جلود ودش المجموعة',
        keyJson: 'G4',
      ),
      GroupCheckWidget(
        title: 'وزن الاستخلاص (ماء)',
        keyJson: 'G5',
      ),
      GroupCheckWidget(
        title: 'TDS = (0-120ppm)',
        keyJson: 'G6',
      ),
      GroupCheckWidget(
        title: 'PH = (7.0-7.5)',
        keyJson: 'G7',
      ),
      // CommentWidget(
      //   title: 'القاطع الكهربائي غير مطابق لتوصيات السلامة العامة والمعايير',
      // ),
      // CommentWidget(
      //   title: 'لايوجد قاطع كهربائي',
      // ),
      // CommentWidget(title: 'لايوجد ارضي'),
      // CommentWidget(title: 'الارضي غير فعال'),
      // CommentWidget(title: 'توصيل ثنائي القطبية 110'),
      // CommentWidget(title: 'توصيل غير صحيح من قبل المستخدم'),
      // CommentWidget(title: 'مصدر الماء غير مطابق للمعايير و التوصيات'),
      // CommentWidget(title: 'تدفق مصدر الماء متغير/ضعيف\n مما يؤثر على المكينة'),
      // CommentWidget(title: 'نسبة قاعدية الماء غير مطابقة للمعايير'),
      // CommentWidget(title: 'نسبة المواد الصلبة المذابة غير مطابقة للمعايير'),
      // CommentWidget(title: 'تكلسات املاح مرئية داخل المكينة'),
      CommentWidget(title: 'تم تنظيف عداد المياه'),
      CommentWidget(title: 'تم تنظيف مجرى المياه'),
      CommentWidget(title: 'تم تفريغ الغلاية عدة مرات لوجود املاح'),
      CommentWidget(title: 'تم تنظيف المجموعة/المجموعات'),
      CommentWidget(title: 'تم صيانة وحدة التبخير'),
      CommentWidget(title: 'تم تحديث برنامج التشغيل'),
      CommentWidget(title: 'تم فك وتنظيف وحدة الترطيب'),
      CommentWidget(title: 'تم فك المجموعة وتنظيف المقنن'),
      CommentWidget(title: 'يوجد فرق كميات لايمكن حله في الموقع'),
      CommentWidget(title: 'يوجد تكلسات لايمكن تنظيفها في الموقع'),
      CommentWidget(title: 'نوصي بنقل المكينة لمركز الصيانة'),
      CommentWidget(
          title: 'نوصي بتعديل التوصيلات \nوالملاحظات حسب توصيات الشركة')
    ];
  }

  String validateTechInput() {
    String title = NA;
    for (int i = 0; i < _machineCheckDesign.length; i++) {
      var entery = _machineCheckDesign[i];
      if (entery is MachineChekWidget) {
        if (entery.isPass == null) {
          title = entery.title!;
          break;
        }
      } else if (entery is TextWidget) {
        if (entery.controller.text.isEmpty) {
          title = entery.title!;
          break;
        }
      }
    }
    return title;
  }
}
