import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Helpers/validators.dart';
import 'package:customer_service_app/Layouts/Home%20Page/Creator/creator_home_page.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/customer.dart';
import 'package:customer_service_app/Models/machine.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Services/machines_provider.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Services/user_provider.dart';
import 'package:customer_service_app/Util/formatters.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/custom_check_box.dart';
import 'package:customer_service_app/main.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';

class SanremoNewTicketPage extends StatefulWidget {
  const SanremoNewTicketPage({Key? key}) : super(key: key);

  @override
  _SanremoNewTicketPageState createState() => _SanremoNewTicketPageState();
}

class _SanremoNewTicketPageState extends State<SanremoNewTicketPage>
    with RouteAware {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _didContact = false;
  bool _solveByPhone = false;
  bool _freeVisit = false;
  bool _freeParts = false;
  bool _readyToAssign = false;
  TextEditingController? selectedModel = TextEditingController();
  TextEditingController? customerNumber = TextEditingController();
  TextEditingController? customerName = TextEditingController();
  TextEditingController? customerMobile = TextEditingController();
  TextEditingController? cafeName = TextEditingController();
  TextEditingController? cafeLocation = TextEditingController();
  TextEditingController? city = TextEditingController();
  TextEditingController? extraNumber = TextEditingController();
  TextEditingController? machineNumber = TextEditingController();
  TextEditingController? problemDesc = TextEditingController();
  TextEditingController? recommendation = TextEditingController();
  TextEditingController? visitDate = TextEditingController();
  TextEditingController? from = TextEditingController();
  TextEditingController? to = TextEditingController();
  TextEditingController? customerBalance = TextEditingController();
  String selectedCategory = 'Unclassified';
  List<String> categorys = [
    'Unclassified',
    'Warranty Visit',
    'Rework Visit',
    'Installation',
    'Paid Visit'
  ];
  String _techName = 'N/A';
  TextEditingController _selectedCity = TextEditingController();
  String _selectedReg = '';
  List<String> techs = [];
  List<String>? machineModels;
  List<Customer>? allCustomers;
  List<Machine>? allMachines;
  Customer? selectedCustomer;
  Machine? selectedMachines;
  Map<String, dynamic>? ticketHeader;
  Map<String, dynamic>? ticketBody;
  String? _assignDirection = '';
  String? sheetID;
  String? status;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    super.didPush();
    allMachines =
        Provider.of<MachinesProvider>(context, listen: false).machines;
    allCustomers =
        Provider.of<CustomerProvider>(context, listen: false).customers;
    setState(() {
      _isLoading = true;
    });
    await Provider.of<MachinesProvider>(context, listen: false)
        .fetchModels()
        .then((value) {
      machineModels =
          Provider.of<MachinesProvider>(context, listen: false).models;
    });
    await Provider.of<UserProvider>(context, listen: false)
        .fetchTechs()
        .then((value) {
      techs = Provider.of<UserProvider>(context, listen: false).techs;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, NEW_SANREMO_TICKET)!),
      ),
      body: _isLoading
          ? const SpinKitPianoWave(
              color: APP_BAR_COLOR,
            )
          : Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  DropDownField(
                    required: true,
                    controller: selectedModel,
                    value: selectedModel!.text,
                    labelText: getTranselted(context, LBL_MACHINE_MODEL),
                    items: machineModels,
                    onValueChanged: (value) {
                      setState(() {
                        selectedModel!.text = value;
                      });
                    },
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    inputFormatters: [UpperCaseFormatter()],
                    controller: machineNumber,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_MACHINE_NUMBER)!),
                    ),
                    onChanged: (value) {
                      selectedMachines = findMachine(value);
                      if (selectedMachines != null) {
                        fetchCustomerInfo(context, selectedMachines!);
                      } else {
                        customerNumber!.text = '';
                        clearCustomerValues();
                      }
                    },
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: customerNumber,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_CUSTOMER_NUMBER)!),
                    ),
                    onChanged: (value) {
                      selectedCustomer = findCustomer(value);
                      if (selectedCustomer != null) {
                        fetchCustomerByNumber(context, selectedCustomer!);
                      } else {
                        clearCustomerValues();
                      }
                    },
                  ),
                  selectedCustomer != null
                      ? TextFormField(
                          enabled: false,
                          controller: customerBalance,
                          decoration: InputDecoration(
                            label: Text(
                                getTranselted(context, LBL_CUSTOMER_BALANCE)!),
                          ),
                          onChanged: (value) {},
                        )
                      : Container(),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: customerName,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_CUSTOMER_NAME)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: customerMobile,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_MOBILE)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: extraNumber,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_EXTRA_NUMBER)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: cafeName,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_CAFE_NAME)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: cafeLocation,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_CAFE_LOCATION)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: problemDesc,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_PROBLEM_DESC)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: recommendation,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_RECOMMENDATION)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: visitDate,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_VISIT_SCHEDULE)!),
                    ),
                    onTap: () => pickDate(context),
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: from,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_FROM)!),
                    ),
                    onTap: () => pickTime(context, from!),
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context),
                    controller: to,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_TO)!),
                    ),
                    onTap: () => pickTime(context, to!),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton(
                    hint: Text(getTranselted(context, LBL_VISIT_CATEGORY)!),
                    items: categorys
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value.toString();
                      });
                    },
                  ),
                  DropDownField(
                    controller: _selectedCity,
                    value: _selectedCity.text,
                    labelText: getTranselted(context, LBL_CITY),
                    items: cities.map((e) => e['name_ar'].toString()).toList(),
                    onValueChanged: (value) {
                      setState(() {
                        _selectedCity.text = value;
                        var city = cities.firstWhere((element) =>
                            element['name_ar'] == _selectedCity.text);
                        _selectedReg = city['reg_name_ar'];
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropDownField(
                    value: _techName,
                    labelText: getTranselted(context, LBL_TECH_NAME),
                    items: techs,
                    onValueChanged: (value) {
                      setState(() {
                        _techName = value;
                        if (_techName != 'N/A') {
                          _readyToAssign = false;
                        } else {
                          _assignDirection = '';
                        }
                      });
                    },
                    required: true,
                  ),
                  _techName != 'N/A'
                      ? RadioGroup<String>.builder(
                          direction: Axis.horizontal,
                          groupValue: _assignDirection!,
                          onChanged: (value) => setState(() {
                            _assignDirection = value;
                            print(_assignDirection);
                          }),
                          items: [
                            getTranselted(context, LBL_DIRECT_ASSIGN)!,
                            getTranselted(context, LBL_PUSH_QUEUE)!
                          ],
                          itemBuilder: (item) => RadioButtonBuilder(
                            item,
                          ),
                        )
                      : Container(),
                  _techName == 'N/A'
                      ? CustomCheckBox(
                          title: LBL_READY_ASSIGN,
                          value: _readyToAssign,
                          onChanged: (value) {
                            setState(() {
                              _readyToAssign = value!;
                            });
                          },
                        )
                      : Container(),
                  CustomCheckBox(
                    title: LBL_DID_CONTACT,
                    value: _didContact,
                    onChanged: (value) {
                      setState(() {
                        _didContact = value!;
                      });
                    },
                  ),
                  CustomCheckBox(
                    title: LBL_SOLVED_BY_PHONE,
                    value: _solveByPhone,
                    onChanged: (value) {
                      setState(() {
                        if (!_readyToAssign) {
                          _solveByPhone = value!;
                        }
                      });
                    },
                  ),
                  CustomCheckBox(
                    title: LBL_FREE_VISIT,
                    value: _freeVisit,
                    onChanged: (value) {
                      setState(() {
                        _freeVisit = value!;
                      });
                    },
                  ),
                  CustomCheckBox(
                    title: LBL_FREE_PARTS,
                    value: _freeParts,
                    onChanged: (value) {
                      setState(() {
                        _freeParts = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ButtonWidget(
                    text: getTranselted(context, BTN_SUBMIT)!,
                    onTap: () {
                      setState(() async {
                        _isLoading = true;
                        validateReport().then((value) => null);
                      });
                    },
                  )
                ],
              ),
            ),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));
    if (pickedDate == null) {
      return;
    }
    setState(() {
      visitDate!.text = pickedDate.toString().split(' ')[0];
    });
  }

  Future pickTime(
      BuildContext context, TextEditingController controller) async {
    final initialTime = TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime == null) {
      return;
    }
    setState(() {
      controller.text = pickedTime.format(context);
    });
  }

  Machine? findMachine(String machineNumber) {
    try {
      return allMachines!.firstWhere((element) =>
          (element.machineNumber!.toUpperCase().trim() ==
              machineNumber.toUpperCase().trim()));
    } catch (ex) {
      return null;
    }
  }

  Customer? findCustomer(String customerNumber) {
    try {
      return allCustomers!.firstWhere((element) =>
          (element.customerNumber!.toUpperCase().trim() ==
              customerNumber.toUpperCase().trim()));
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  void fetchCustomerInfo(BuildContext context, Machine? machine) {
    try {
      print(machine!.machineModel);
      selectedCustomer = allCustomers!.firstWhere((element) =>
          machine.customerNumber!.toUpperCase().trim() ==
          element.customerNumber!.toUpperCase().trim());
      if (selectedCustomer != null) {
        setState(() {
          customerName!.text = selectedCustomer!.customerName!;
          cafeName!.text = selectedCustomer!.companyName!;
          customerMobile!.text = selectedCustomer!.mobile!;
          customerBalance!.text = selectedCustomer!.balance.toString();
          customerNumber!.text = selectedCustomer!.customerNumber!;
          selectedModel!.text = machine.machineModel.toString();
        });
      }
    } catch (ex) {
      print(ex);
    }
  }

  void fetchCustomerByNumber(BuildContext? context, Customer customer) {
    try {
      customerName!.text = selectedCustomer!.customerName!;
      cafeName!.text = selectedCustomer!.companyName!;
      customerMobile!.text = selectedCustomer!.mobile!;
      customerBalance!.text = selectedCustomer!.balance.toString();
      customerNumber!.text = selectedCustomer!.customerNumber!;
    } catch (ex) {
      print(ex);
    }
  }

  Future<String> validateReport() async {
    String date = DateTime.now().toString().split(' ')[0];
    if (_techName != 'N/A') {
      if (_assignDirection != '') {
        if (formKey.currentState!.validate()) {
          ticketHeader = getTicketHeader();
          if (_assignDirection == getTranselted(context, LBL_DIRECT_ASSIGN)!) {
            ticketHeader!.update(Ticket.STATUS, (value) => Ticket.STA_ASSIGNED,
                ifAbsent: () => Ticket.STA_ASSIGNED);
            ticketHeader!.update(Ticket.ASSIGN_DATE, (value) => date,
                ifAbsent: () => date);
            return await Provider.of<TicketProvider>(context, listen: false)
                .createNewSanremoTicket(ticketHeader,
                    '$DB_URL$DB_ASSIGNED_TICKETS/$_techName.json');
          } else {
            ticketHeader!.update(Ticket.STATUS, (value) => Ticket.STA_QUEUE,
                ifAbsent: () => Ticket.STA_QUEUE);
            return await Provider.of<TicketProvider>(context, listen: false)
                .createNewSanremoTicket(
                    ticketHeader, '$DB_URL$DB_QUEUE_TICKETS/$_techName.json');
          }
        } else {
          return Future.value('N/A');
        }
      } else {
        return Future.value(ASSIGN_DIRECTION_ERR);
      }
    } else {
      return Future.value(ASSIGN_DIRECTION_ERR);
    }
  }

  void clearCustomerValues() {
    setState(() {
      customerName!.text = '';
      cafeName!.text = '';
      customerMobile!.text = '';
      customerBalance!.text = '';
      selectedCustomer = null;
    });
  }

  Map<String, dynamic>? getTicketHeader() {
    return {
      Ticket.CAFE_NAME: cafeName!.text.trim(),
      Ticket.CUSTOMER_MOBILE: customerMobile!.text.trim(),
      Ticket.CUSTOMER_NAME: customerName!.text.trim(),
      Ticket.CONTACT_NUMBER: extraNumber!.text.trim(),
      Ticket.CREATED_BY: userName,
      Ticket.LAST_EDIT_BY: userName,
      Ticket.VISIT_DATE: visitDate!.text,
      Ticket.CREATION_DATE: DateTime.now().toString().split(' ')[0],
      Ticket.SUB_CATEGORY: selectedCategory,
      Ticket.CITY: _selectedCity.text.trim(),
      Ticket.REGION: _selectedReg,
      Ticket.TECH_NAME: _techName,
      Ticket.DID_CONTACT: _didContact,
      Ticket.MAIN_CATEGORY: Ticket.SITE_VISIT_CATEGORY,
      Ticket.MACHINE_MODEL: selectedModel!.text.trim(),
      Ticket.SERIAL_NUMBER: machineNumber!.text.trim(),
      Ticket.CUSTOMER_NUMBER: customerNumber!.text.trim(),
      Ticket.CAFE_LOCATION: cafeLocation!.text.trim(),
      Ticket.PROBLEM_DESC: problemDesc!.text.trim(),
      Ticket.RECOMMENDATION: recommendation!.text.trim(),
      Ticket.VISIT_START_TIME: from!.text.trim(),
      Ticket.VISIT_END_TIME: to!.text.trim(),
      Ticket.FREE_PARTS: _freeParts,
      Ticket.FREE_VISIT: _freeVisit,
    };
  }
}
