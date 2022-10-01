// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/global_vars.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/comment.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Services/spare_parts_provider.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Creator/custom_list_dialgo.dart';
import 'package:customer_service_app/Widgets/Creator/custome_dialog.dart';
import 'package:customer_service_app/Widgets/Tech/check_widget.dart';
import 'package:customer_service_app/Widgets/Tech/comment_widget.dart';
import 'package:customer_service_app/Widgets/Tech/machine_check_widget.dart';
import 'package:customer_service_app/Widgets/Tech/spare_part_widget.dart';
import 'package:customer_service_app/Widgets/Tech/text_widget.dart';
import 'package:customer_service_app/Widgets/pending_ticket_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class ConfirmationTickets extends StatefulWidget {
  const ConfirmationTickets({Key? key}) : super(key: key);

  @override
  _ConfirmationTicketsState createState() => _ConfirmationTicketsState();
}

class _ConfirmationTicketsState extends State<ConfirmationTickets>
    with RouteAware {
  List<Ticket> _tickets = [];
  List<Ticket> _showedTickets = [];
  List<SparePart> _allParts = [];
  bool _isLoading = false;
  bool _search = false;
  CustomListDialog? dialog;
  List<Comment> _allComments = [];

  String? validateNote(value) {
    if (value.isEmpty) {
      return 'هذا الحقل الزامي';
    } else {
      return null;
    }
  }

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
        .fetchPendingTickets(DB_WAITING_CONFIRMATION)
        .then((value) {
      Provider.of<SparePartProvider>(context, listen: false)
          .fetchSpareParts()
          .then((value) {
        _allParts =
            Provider.of<SparePartProvider>(context, listen: false).parts;
        Provider.of<TicketProvider>(context, listen: false)
            .fetchComments()
            .then(
          (value) {
            _allComments =
                Provider.of<TicketProvider>(context, listen: false).comments;
            Provider.of<TicketProvider>(context, listen: false)
                .fetchComments()
                .then((value) {
              setState(() {
                _isLoading = false;
                _tickets =
                    Provider.of<TicketProvider>(context, listen: false).tickets;
                _showedTickets = _tickets;
              });
            });
          },
        );
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
                          hintStyle: const TextStyle(color: Colors.white)),
                      style: const TextStyle(color: Colors.white),
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
                  : Text(getTranselted(context, STA_WAITING_CONFIRMATION)!),
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
          widget: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: ListView(children: [
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
                            contentPadding:
                                const EdgeInsets.only(top: 50.0, bottom: 50.0),
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
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _tickets.length,
                itemBuilder: (context, i) {
                  return PendingTicketWidget(
                    cafeName: _tickets[i].cafeName,
                    city: _tickets[i].city,
                    customerMobile: _tickets[i].customerMobile,
                    customerName: _tickets[i].customerName,
                    date: _tickets[i].assignDate,
                    didContact: _tickets[i].didContact,
                    machineNumber: _tickets[i].machineNumber,
                    techName: _tickets[i].techName,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text(
                                  'Do You Want To Review This Ticket?'),
                              title: const Text('Review Ticket'),
                              actions: [
                                MaterialButton(
                                    child: const Text('Yes'),
                                    onPressed: () async {
                                      Provider.of<TicketProvider>(context,
                                              listen: false)
                                          .startReviewTicket(_tickets[i])
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        if (value == NA || value == userName) {
                                          List<Widget> design =
                                              initMachineCheckDesign(
                                                  _tickets[i]);
                                          Navigator.pushNamed(context,
                                              creatorConfirmDetailsRoute,
                                              arguments: [_tickets[i], design]);
                                        } else if (value != userName) {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.warning,
                                              title: 'Ticket Under Review',
                                              text:
                                                  'The Ticket is Reviewing By $value');
                                        }
                                      });
                                    }),
                                MaterialButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  );
                },
              ),
              // Expanded(
              //   child: GridViewBuilderCreator(
              //     dialog: dialog,
              //     list: _showedTickets,
              //   ),
              // ),
            ]),
          )), /*ListView.builder(
                itemCount: _showedTickets.length,
                itemBuilder: (context, i) {
                  return ;
                },
              )*/
    );
  }

  List<Widget> initMachineCheckDesign(Ticket ticket) {
    var techInfo = ticket.info as Map<String, dynamic>;
    var partsInfo = ticket.parts as Map<String, dynamic>;
    print(partsInfo);

    String generalComments = '';
    techInfo.forEach((key, value) {
      generalComments += key.startsWith('comment') ? value : '';
    });
    List<Widget> _machineCheckDesign = [];
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
        enabled: false,
        controller: TextEditingController(text: techInfo['os']),
      ),
      TextWidget(
        title: 'اجمالي عدد الاكواب Total Cup',
        jsonKey: 'total_cups',
        validate: validateNote,
        enabled: false,
        controller: TextEditingController(text: techInfo['total_cups']),
      ),
      TextWidget(
        title: 'اجمالي عدد الاكواب Service',
        jsonKey: 'total_cups_ser',
        validate: validateNote,
        enabled: false,
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
      ),
      TextWidget(
        title: 'ملاحظات الفني',
        jsonKey: 'tech_notes',
        validate: validateNote,
        enabled: false,
        controller: TextEditingController(text: techInfo['tech_notes']),
      ),
    ];
    print(techInfo['tech_notes']);
    try {
      partsInfo.forEach((key, value) {
        if (key != 'partsCount') {
          _machineCheckDesign.add(SparePartWidget(
            allParts: _allParts,
            partNo: TextEditingController(text: key),
            qty: TextEditingController(text: value[PART_QTY_KEY].toString()),
            isFreePart: value[PART_IS_FREE_KEY],
          ));
        }
      });
    } catch (ex) {
      print(ex);
    }
    return _machineCheckDesign;
  }

  List<CommentWidget>? getCommentsByCategory(String category, String techInfo) {
    try {
      List<CommentWidget> commentWidgets = [];
      List<Comment> categoryComments = _allComments
          .where((element) => element.commentCategory == category)
          .toList();
      categoryComments.forEach((element) {
        bool isSelected = false;
        if (techInfo.contains(element.comment!.trim())) {
          print(element.comment);
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
