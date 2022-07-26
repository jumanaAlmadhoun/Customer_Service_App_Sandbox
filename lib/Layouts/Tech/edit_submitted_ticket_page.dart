// ignore_for_file: import_of_legacy_library_into_null_safe, unused_field, prefer_final_fields

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

class EditSubmittedTicketPage extends StatefulWidget {
  const EditSubmittedTicketPage(this.ticket, {Key? key}) : super(key: key);
  final Ticket? ticket;
  @override
  _EditSubmittedTicketPageState createState() =>
      _EditSubmittedTicketPageState();
}

class _EditSubmittedTicketPageState extends State<EditSubmittedTicketPage>
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
                          arguments: [widget.ticket, _machineCheckDesign]);
                    }
                  },
                ),
              ],
            ),
    );
  }

  void initMachineCheckDesign() {
    var techInfo = widget.ticket!.info as Map<String, dynamic>;
    var partsInfo = widget.ticket!.parts as Map<String, dynamic>;
    print(partsInfo);

    String generalComments = '';
    techInfo.forEach((key, value) {
      generalComments += key.startsWith('comment') ? value : '';
    });
    _machineCheckDesign = [
      MachineCheckWidget(
        title: 'قطع مكسورة أو مفقودة',
        keyJson: '1',
        validate: validateNote,
        comments: null,
        pass: techInfo['1_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['1_Pass'],
        controller:
            TextEditingController(text: techInfo['1_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'نظافة المكينة العامة',
        keyJson: '2',
        validate: validateNote,
        pass: techInfo['2_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['2_Pass'],
        comments: getCommentsByCategory(
            Comment.CLEAN_COMMENTS, techInfo['2_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'فحص وجود تهريبات في المكينة',
        keyJson: '3',
        validate: validateNote,
        pass: techInfo['3_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['3_Pass'],
        controller:
            TextEditingController(text: techInfo['3_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'فحص عدادات الماء',
        keyJson: '4',
        validate: validateNote,
        pass: techInfo['4_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['4_Pass'],
        comments: getCommentsByCategory(
            Comment.FLOWMETER_COMMENTS, techInfo['4_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'فحص مصدر الماء',
        keyJson: '5',
        validate: validateNote,
        pass: techInfo['5_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['5_Pass'],
        comments: getCommentsByCategory(
            Comment.WATER_COMMENTS, techInfo['5_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'نوع مصدر الماء',
        keyJson: '6',
        validate: validateNote,
        pass: techInfo['6_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['6_Pass'],
        comments: getCommentsByCategory(
            Comment.WATER_SRC_COMMENTS, techInfo['6_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'فحص التوصيلات والسلامة العامة',
        keyJson: '7',
        validate: validateNote,
        pass: techInfo['7_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['7_Pass'],
        comments: getCommentsByCategory(
            Comment.ELEC_COMMENTS, techInfo['7_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'فحص ضغط المضخة الرئيسية',
        keyJson: '8',
        validate: validateNote,
        pass: techInfo['8_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['8_Pass'],
        controller:
            TextEditingController(text: techInfo['8_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'فحص وحدة التحكم بالبخار',
        keyJson: '9',
        validate: validateNote,
        pass: techInfo['9_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['9_Pass'],
        comments: getCommentsByCategory(
            Comment.STEAM_COMMENTS, techInfo['9_Comment'].toString()),
      ),
      MachineCheckWidget(
        title: 'فحص قوة البخار',
        keyJson: '10',
        validate: validateNote,
        pass: techInfo['10_Pass'] ? 'نجاح' : 'فشل',
        isPass: techInfo['10_Pass'],
        controller:
            TextEditingController(text: techInfo['10_Comment'].toString()),
      ),
      TextWidget(
        title: 'إصدار برنامج التشغيل',
        jsonKey: 'os',
        validate: validateNote,
        controller: TextEditingController(text: techInfo['os']),
      ),
      TextWidget(
        title: 'اجمالي عدد الاكواب Total Cup',
        jsonKey: 'total_cups',
        validate: validateNote,
        controller: TextEditingController(text: techInfo['total_cups']),
      ),
      TextWidget(
        title: 'اجمالي عدد الاكواب Service',
        jsonKey: 'total_cups_ser',
        validate: validateNote,
        controller: TextEditingController(text: techInfo['total_cups_ser']),
      ),
      GroupCheckWidget(
        title: 'قياس الضغط (بار / psi)',
        keyJson: 'G1',
        controllerG1: TextEditingController(text: techInfo['G1_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G1_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G1_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G1_Comment'][3]),
        isPassG1: techInfo['G1_Pass'][0],
        isPassG2: techInfo['G1_Pass'][1],
        isPassG3: techInfo['G1_Pass'][2],
        isPassG4: techInfo['G1_Pass'][3],
        passG1: techInfo['G1_PassL'][0],
        passG2: techInfo['G1_PassL'][1],
        passG3: techInfo['G1_PassL'][2],
        passG4: techInfo['G1_PassL'][3],
      ),
      GroupCheckWidget(
        title: 'فحص الاستخلاص الافتراضي',
        keyJson: 'G2',
        controllerG1: TextEditingController(text: techInfo['G2_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G2_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G2_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G2_Comment'][3]),
        isPassG1: techInfo['G2_Pass'][0],
        isPassG2: techInfo['G2_Pass'][1],
        isPassG3: techInfo['G2_Pass'][2],
        isPassG4: techInfo['G2_Pass'][3],
        passG1: techInfo['G2_PassL'][0],
        passG2: techInfo['G2_PassL'][1],
        passG3: techInfo['G2_PassL'][2],
        passG4: techInfo['G2_PassL'][3],
      ),
      GroupCheckWidget(
        title: 'وزن الماء (جرام/10ثواني)',
        keyJson: 'G3',
        controllerG1: TextEditingController(text: techInfo['G3_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G3_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G3_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G3_Comment'][3]),
        isPassG1: techInfo['G3_Pass'][0],
        isPassG2: techInfo['G3_Pass'][1],
        isPassG3: techInfo['G3_Pass'][2],
        isPassG4: techInfo['G3_Pass'][3],
        passG1: techInfo['G3_PassL'][0],
        passG2: techInfo['G3_PassL'][1],
        passG3: techInfo['G3_PassL'][2],
        passG4: techInfo['G3_PassL'][3],
      ),
      GroupCheckWidget(
        title: 'فحص الترطيب (جرام/10ثواني)',
        keyJson: 'G4',
        controllerG1: TextEditingController(text: techInfo['G4_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G4_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G4_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G4_Comment'][3]),
        isPassG1: techInfo['G4_Pass'][0],
        isPassG2: techInfo['G4_Pass'][1],
        isPassG3: techInfo['G4_Pass'][2],
        isPassG4: techInfo['G4_Pass'][3],
        passG1: techInfo['G4_PassL'][0],
        passG2: techInfo['G4_PassL'][1],
        passG3: techInfo['G4_PassL'][2],
        passG4: techInfo['G4_PassL'][3],
      ),
      GroupCheckWidget(
        title: 'فحص البورتفيلتر',
        keyJson: 'G5',
        controllerG1: TextEditingController(text: techInfo['G5_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G5_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G5_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G5_Comment'][3]),
        isPassG1: techInfo['G5_Pass'][0],
        isPassG2: techInfo['G5_Pass'][1],
        isPassG3: techInfo['G5_Pass'][2],
        isPassG4: techInfo['G5_Pass'][3],
        passG1: techInfo['G5_PassL'][0],
        passG2: techInfo['G5_PassL'][1],
        passG3: techInfo['G5_PassL'][2],
        passG4: techInfo['G5_PassL'][3],
      ),
      GroupCheckWidget(
        title: 'جلود ودش المجموعة',
        keyJson: 'G6',
        controllerG1: TextEditingController(text: techInfo['G6_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G6_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G6_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G6_Comment'][3]),
        isPassG1: techInfo['G6_Pass'][0],
        isPassG2: techInfo['G6_Pass'][1],
        isPassG3: techInfo['G6_Pass'][2],
        isPassG4: techInfo['G6_Pass'][3],
        passG1: techInfo['G6_PassL'][0],
        passG2: techInfo['G6_PassL'][1],
        passG3: techInfo['G6_PassL'][2],
        passG4: techInfo['G6_PassL'][3],
      ),
      GroupCheckWidget(
        title: 'TDS = (0-120ppm)',
        keyJson: 'G7',
        controllerG1: TextEditingController(text: techInfo['G7_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G7_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G7_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G7_Comment'][3]),
        isPassG1: techInfo['G7_Pass'][0],
        isPassG2: techInfo['G7_Pass'][1],
        isPassG3: techInfo['G7_Pass'][2],
        isPassG4: techInfo['G7_Pass'][3],
        passG1: techInfo['G7_PassL'][0],
        passG2: techInfo['G7_PassL'][1],
        passG3: techInfo['G7_PassL'][2],
        passG4: techInfo['G7_PassL'][3],
      ),
      GroupCheckWidget(
        title: 'PH = (7.0-7.5)',
        keyJson: 'G8',
        controllerG1: TextEditingController(text: techInfo['G8_Comment'][0]),
        controllerG2: TextEditingController(text: techInfo['G8_Comment'][1]),
        controllerG3: TextEditingController(text: techInfo['G8_Comment'][2]),
        controllerG4: TextEditingController(text: techInfo['G8_Comment'][3]),
        isPassG1: techInfo['G8_Pass'][0],
        isPassG2: techInfo['G8_Pass'][1],
        isPassG3: techInfo['G8_Pass'][2],
        isPassG4: techInfo['G8_Pass'][3],
        passG1: techInfo['G8_PassL'][0],
        passG2: techInfo['G8_PassL'][1],
        passG3: techInfo['G8_PassL'][2],
        passG4: techInfo['G8_PassL'][3],
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
      CommentWidget(
        title: 'تم تنظيف عداد المياه',
        isSelected: generalComments.contains('تم تنظيف عداد المياه'),
      ),
      CommentWidget(
        title: 'تم تنظيف مجرى المياه',
        isSelected: generalComments.contains('تم تنظيف مجرى المياه'),
      ),
      CommentWidget(
        title: 'تم تفريغ الغلاية عدة مرات لوجود املاح',
        isSelected:
            generalComments.contains('تم تفريغ الغلاية عدة مرات لوجود املاح'),
      ),
      CommentWidget(
        title: 'تم تنظيف المجموعة/المجموعات',
        isSelected: generalComments.contains('تم تنظيف المجموعة/المجموعات'),
      ),
      CommentWidget(
        title: 'تم صيانة وحدة التبخير',
        isSelected: generalComments.contains('تم صيانة وحدة التبخير'),
      ),
      CommentWidget(
        title: 'تم تحديث برنامج التشغيل',
        isSelected: generalComments.contains('تم تحديث برنامج التشغيل'),
      ),
      CommentWidget(
        title: 'تم فك وتنظيف وحدة الترطيب',
        isSelected: generalComments.contains('تم فك وتنظيف وحدة الترطيب'),
      ),
      CommentWidget(
        title: 'تم فك المجموعة وتنظيف المقنن',
        isSelected: generalComments.contains('تم فك المجموعة وتنظيف المقنن'),
      ),
      CommentWidget(
        title: 'يوجد فرق كميات لايمكن حله في الموقع',
        isSelected:
            generalComments.contains('يوجد فرق كميات لايمكن حله في الموقع'),
      ),
      CommentWidget(
        title: 'يوجد تكلسات لايمكن تنظيفها في الموقع',
        isSelected:
            generalComments.contains('يوجد تكلسات لايمكن تنظيفها في الموقع'),
      ),
      CommentWidget(
        title: 'نوصي بنقل المكينة لمركز الصيانة',
        isSelected: generalComments.contains('نوصي بنقل المكينة لمركز الصيانة'),
      ),
      CommentWidget(
        title: 'نوصي بتعديل التوصيلات \nوالملاحظات حسب توصيات الشركة',
        isSelected: generalComments
            .contains('نوصي بتعديل التوصيلات \nوالملاحظات حسب توصيات الشركة'),
      )
    ];
    try {
      partsInfo.forEach((key, value) {
        if (key != 'partsCount') {
          _machineCheckDesign.add(SparePartWidget(
            allParts: _allParts,
            partNo: TextEditingController(text: key),
            qty: TextEditingController(text: value.toString()),
          ));
        }
      });
    } catch (ex) {
      print(ex);
    }
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

  List<CommentWidget>? getCommentsByCategory(String category, String techInfo) {
    try {
      List<CommentWidget> commentWidgets = [];
      List<Comment> categoryComments = _allComments
          .where((element) => element.commentCategory == category)
          .toList();
      categoryComments.forEach((element) {
        bool isSelected = false;
        if (techInfo.contains(element.comment!)) {
          isSelected = true;
        }
        commentWidgets
            .add(CommentWidget(title: element.comment, isSelected: isSelected));
      });
      return commentWidgets;
    } catch (ex) {
      print('UI Comments ERROR $ex');
    }
  }
}
