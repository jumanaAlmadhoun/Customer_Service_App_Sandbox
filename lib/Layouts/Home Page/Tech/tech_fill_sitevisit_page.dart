import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Widgets/check_widget.dart';
import 'package:customer_service_app/Widgets/machine_check_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class TechFillTicketPage extends StatefulWidget {
  TechFillTicketPage(this.ticket);
  final Ticket? ticket;
  @override
  _TechFillTicketPageState createState() => _TechFillTicketPageState();
}

class _TechFillTicketPageState extends State<TechFillTicketPage>
    with RouteAware {
  bool _isLoading = false;
  List<SparePart> _allParts = [];
  List<SparePart> _selectedParts = [];
  List<Widget> _machineCheckDesign = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    initMachineCheckDesign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعبئة معلومات التذكرة'),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: _machineCheckDesign,
          )
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
