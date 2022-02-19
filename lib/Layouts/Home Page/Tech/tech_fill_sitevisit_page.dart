import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/spare_parts_provider.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/check_widget.dart';
import 'package:customer_service_app/Widgets/machine_check_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class TechFillTicketPage extends StatefulWidget {
  TechFillTicketPage(this.ticket);
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
                      ));
                    });
                  },
                ),
                ButtonWidget(
                  text: 'التالي',
                  onTap: () {},
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
      ),
      MachineChekWidget(
        title: 'نظافة المكينة العامة',
        keyJson: '2',
      ),
      MachineChekWidget(
        title: 'فحص وجود تهريبات في المكينة',
        keyJson: '3',
      ),
      MachineChekWidget(
        title: 'فحص العدادات',
        keyJson: '4',
      ),
      MachineChekWidget(
        title: 'فحص مصدر الماء',
        keyJson: '5',
      ),
      MachineChekWidget(
        title: 'فحص جودة تسخين الحليب',
        keyJson: '6',
      ),
      MachineChekWidget(
        title: 'فحص التوصيلات والسلامة العامة',
        keyJson: '7',
      ),
      MachineChekWidget(
        title: 'فحص ضغط المضخة الرئيسية (بار)',
        keyJson: '8',
      ),
      MachineChekWidget(
        title: 'فحص وحدة التحكم بالبخار',
        keyJson: '9',
      ),
      MachineChekWidget(
        title: 'فحص قوة البخار',
        keyJson: '10',
      ),
      MachineChekWidget(
        title: 'فحص سرعة الفتح والاغلاق للبخار',
        keyJson: '11',
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
    ];
  }
}

class SparePartWidget extends StatefulWidget {
  SparePartWidget({this.allParts});
  TextEditingController partNo = TextEditingController();
  TextEditingController qty = TextEditingController();
  List<SparePart>? allParts;
  double amount = 0;
  @override
  _SparePartWidgetState createState() => _SparePartWidgetState();
}

class _SparePartWidgetState extends State<SparePartWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: APP_BAR_COLOR),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SearchField(
                    maxSuggestionsInViewPort: 5,
                    searchInputDecoration: const InputDecoration(
                      label: Text('رقم القطعة'),
                    ),
                    controller: widget.partNo,
                    validator: (value) {
                      if (widget.allParts!.firstWhere((element) =>
                                  element.partNo!.toUpperCase() ==
                                  value!.toUpperCase()) ==
                              null ||
                          value!.isEmpty) {
                        return 'رقم القطعة خطأ';
                      } else {
                        return null;
                      }
                    },
                    suggestions: widget.allParts!
                        .map((e) => e.partNo.toString())
                        .toList()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: widget.qty,
                  onChanged: (value) {
                    SparePart part = widget.allParts!.firstWhere((element) =>
                        element.partNo!.toUpperCase() ==
                        widget.partNo.text.toUpperCase());
                    if (part != null && value.isNotEmpty) {
                      setState(() {
                        widget.amount = part.price! * double.parse(value);
                      });
                    }
                  },
                  decoration: const InputDecoration(label: Text('العدد')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
