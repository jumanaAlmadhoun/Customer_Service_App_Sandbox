import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/validators.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/customer.dart';
import 'package:customer_service_app/Models/machine.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/machines_provider.dart';
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
  List<String> categorys = [
    'Unclassified',
    'Warranty Visit',
    'Rework Visit',
    'Installation',
    'Paid Visit'
  ];
  String _techName = 'N/A';
  List<String> techs = [];

  List<String>? machineModels;
  List<Customer>? allCustomers;
  List<Machine>? allMachines;
  Customer? selectedCustomer;
  Machine? selectedMachines;
  Map<String, dynamic>? jsonToSend;
  String? _assignDirection = '';

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
                    validator: (value) => validateInput(value, context)!,
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
                        clearCustomerValues();
                      }
                    },
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
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
                    validator: (value) => validateInput(value, context)!,
                    controller: customerName,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_CUSTOMER_NAME)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: customerMobile,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_MOBILE)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: extraNumber,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_EXTRA_NUMBER)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: cafeName,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_CAFE_NAME)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: cafeLocation,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_CAFE_LOCATION)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: problemDesc,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_PROBLEM_DESC)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: recommendation,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_RECOMMENDATION)!),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: visitDate,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_VISIT_SCHEDULE)!),
                    ),
                    onTap: () => pickDate(context),
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: from,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_FROM)!),
                    ),
                    onTap: () => pickTime(context, from!),
                  ),
                  TextFormField(
                    validator: (value) => validateInput(value, context)!,
                    controller: to,
                    decoration: InputDecoration(
                      label: Text(getTranselted(context, LBL_TO)!),
                    ),
                    onTap: () => pickTime(context, to!),
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
                      });
                    },
                  ),
                  _techName != 'N/A'
                      ? RadioGroup<String>.builder(
                          direction: Axis.horizontal,
                          groupValue: _assignDirection!,
                          onChanged: (value) => setState(() {
                            _assignDirection = value;
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
                        _solveByPhone = value!;
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
                      if (validateReport()) {
                        directReport(context);
                      }
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

  void fetchCustomerInfo(BuildContext context, Machine machine) {
    try {
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
          selectedModel!.text = machine.machineModel!;
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

  bool validateReport() {
    if (_techName != 'N/A') {
      if (_assignDirection != null) {
        if (formKey.currentState!.validate()) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
    return true;
  }

  void clearCustomerValues() {
    setState(() {
      customerName!.text = '';
      cafeName!.text = '';
      customerMobile!.text = '';
      customerBalance!.text = '';
      selectedModel!.text = '';
      selectedCustomer = null;
    });
  }

  void directReport(BuildContext context) {
    jsonToSend = getJson();
  }

  Map<String, dynamic>? getJson() {
    return {};
  }
}
