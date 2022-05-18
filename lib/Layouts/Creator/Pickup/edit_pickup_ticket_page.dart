// ignore_for_file: unused_field, prefer_final_fields, avoid_print, import_of_legacy_library_into_null_safe, unused_local_variable

import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/global_vars.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Helpers/validators.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/customer.dart';
import 'package:customer_service_app/Models/machine.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Services/machines_provider.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Services/user_provider.dart';
import 'package:customer_service_app/Util/formatters.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/custom_check_box.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../creator_home_page.dart';

class EditPickupTicketPage extends StatefulWidget {
  const EditPickupTicketPage(this.argTicket, {Key? key}) : super(key: key);
  final Ticket? argTicket;

  @override
  _EditPickupTicketPageState createState() => _EditPickupTicketPageState();
}

class _EditPickupTicketPageState extends State<EditPickupTicketPage>
    with RouteAware {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _didContact = false;
  Ticket? ticket;
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
  TextEditingController? visitDate = TextEditingController();
  TextEditingController? from = TextEditingController();
  TextEditingController? to = TextEditingController();
  TextEditingController? customerBalance = TextEditingController();
  TextEditingController? _techNameController = TextEditingController();
  TextEditingController? _machineModelController = TextEditingController();

  String _techName = 'N/A';
  TextEditingController _selectedCity = TextEditingController();
  String _selectedReg = '';
  List<String> techs = [];
  List<String>? machineModels = [];
  List<Customer>? allCustomers = [];
  List<Machine>? allMachines = [];
  Customer? selectedCustomer;
  Machine? selectedMachines;
  Map<String, dynamic>? ticketHeader;
  String? _assignDirection = '';
  String _selectedCategory = 'N/A';
  List<String> category = ['N/A', 'Tech', 'Courier'];

  String _selectedStatus = 'Waiting for customer prep';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    super.didPush();
    ticket = widget.argTicket;
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
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, TIC_PICK_UP)!),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              SearchField(
                controller: selectedModel,
                hint: getTranselted(context, LBL_MACHINE_MODEL),
                suggestions:
                    machineModels!.map((e) => SearchFieldListItem(e)).toList(),
                onTap: (value) {
                  setState(() {
                    selectedModel!.text = value.searchKey;
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
                inputFormatters: [UpperCaseFormatter()],
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
                          selectedCustomer!.blocked == ''
                              ? getTranselted(context, LBL_CUSTOMER_BALANCE)!
                              : getTranselted(context, LBL_CUSTOMER_BALANCE)! +
                                  ' ' +
                                  getTranselted(context, LBL_CUSTOMER_BLOCKED)!,
                          style: TextStyle(
                              color: selectedCustomer!.balance! < 0
                                  ? Colors.green
                                  : Colors.red),
                        ),
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
              SearchField(
                controller: _selectedCity,
                hint: getTranselted(context, LBL_CITY),
                suggestions: cities
                    .map((e) => SearchFieldListItem(e['name_ar'].toString()))
                    .toList(),
                onTap: (value) {
                  if (mounted) {
                    setState(() {
                      _selectedCity.text = value.searchKey;
                      var city = cities.firstWhere((element) =>
                          element['name_ar'] == _selectedCity.text);
                      _selectedReg = city['reg_name_ar'];
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton(
                hint: Text(getTranselted(context, LBL_DELIVERY_CATEGORY)!),
                items: category
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value.toString();
                  });
                },
              ),
              DropdownButton(
                hint: Text(getTranselted(context, LBL_DELIVERY_CATEGORY)!),
                items: pickupStatus
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value.toString();
                  });
                },
              ),
              _selectedCategory == 'Tech'
                  ? SearchField(
                      suggestions:
                          techs.map((e) => SearchFieldListItem(e)).toList(),
                      hint: getTranselted(context, LBL_TECH_NAME),
                      controller: _techNameController,
                      onTap: (value) {
                        if (mounted) {
                          setState(() {
                            _techName = value.searchKey;
                          });
                        }
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
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                text: getTranselted(context, BTN_SUBMIT)!,
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  String response = await validateReport();
                  setState(() {
                    _isLoading = false;
                  });
                  if (response == SC_SUCCESS_RESPONSE) {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      onConfirmBtnTap: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            creatorHomeRoute, (route) => route.isFirst);
                      },
                      onCancelBtnTap: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            creatorHomeRoute, (route) => route.isFirst);
                      },
                    );
                  } else if (response == SC_FAILED_RESPONSE) {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: getTranselted(context, ERR_TITL)!,
                        text: getTranselted(context, ERR_UNKWON_TXT)!);
                  } else if (response == ASSIGN_DIRECTION_ERR) {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: getTranselted(context, ERR_TITL)!,
                        text: getTranselted(context, ERR_ASSIGN)!);
                  }
                },
              )
            ],
          ),
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
      return null;
    }
  }

  void fetchCustomerInfo(BuildContext context, Machine? machine) {
    try {
      selectedCustomer = allCustomers!.firstWhere((element) =>
          machine!.customerNumber!.toUpperCase().trim() ==
          element.customerNumber!.toUpperCase().trim());
      if (selectedCustomer != null) {
        setState(() {
          customerName!.text = selectedCustomer!.customerName!;
          cafeName!.text = selectedCustomer!.companyName!;
          customerMobile!.text = selectedCustomer!.mobile!;
          customerBalance!.text = selectedCustomer!.balance!.abs().toString();
          customerNumber!.text = selectedCustomer!.customerNumber!;
          selectedModel!.text = machine!.machineModel.toString();
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
      customerBalance!.text = selectedCustomer!.balance!.abs().toString();
      customerNumber!.text = selectedCustomer!.customerNumber!;
    } catch (ex) {
      print(ex);
    }
  }

  Future<String> validateReport() async {
    String date = DateTime.now().toString().split(' ')[0];
    Map<String, dynamic> json = getTicketHeader()!;
    if (_techName != NA) {
      if (formKey.currentState!.validate()) {
        return await Provider.of<TicketProvider>(context, listen: false)
            .editPickupTicket(
                json, '$DB_URL$DB_PICKUP_TICKETS/${ticket!.firebaseID}.json');
      }
    } else {
      return await Provider.of<TicketProvider>(context, listen: false)
          .editPickupTicket(
              json, '$DB_URL$DB_PICKUP_TICKETS/${ticket!.firebaseID}.json');
    }
    return SC_FAILED_RESPONSE;
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
      Ticket.CREATED_BY: ticket!.createdBy,
      Ticket.CREATION_DATE: ticket!.creationDate,
      Ticket.LAST_EDIT_BY: userName,
      Ticket.VISIT_DATE: visitDate!.text,
      Ticket.DID_CONTACT: _didContact,
      Ticket.CITY: _selectedCity.text.trim(),
      Ticket.REGION: _selectedReg,
      Ticket.TECH_NAME: _techName,
      Ticket.MAIN_CATEGORY: Ticket.PICKUP_CATEGORY,
      Ticket.SUB_CATEGORY: Ticket.PICKUP_CATEGORY,
      Ticket.DELIVERY_TYPE: _selectedCategory,
      Ticket.CUSTOMER_NUMBER: customerNumber!.text.trim(),
      Ticket.CAFE_LOCATION: cafeLocation!.text.trim(),
      Ticket.VISIT_START_TIME: from!.text.trim(),
      Ticket.VISIT_END_TIME: to!.text.trim(),
      // Ticket.DELIVERY_ITEMS: map,
      Ticket.STATUS: _selectedStatus,
      Ticket.ROW_ADDRESS: ticket!.rowAddress,
      Ticket.MACHINE_MODEL: selectedModel!.text,
      Ticket.SERIAL_NUMBER: machineNumber!.text,
    };
  }

  void getData() {
    try {
      customerNumber!.text = ticket!.customerNumber!;
      customerName!.text = ticket!.customerName!;
      customerMobile!.text = ticket!.customerMobile!;
      cafeName!.text = ticket!.cafeName!;
      cafeLocation!.text = ticket!.cafeLocation!;
      city!.text = ticket!.city!;
      extraNumber!.text = ticket!.extraContactNumber!;
      visitDate!.text = ticket!.visitDate!;
      from!.text = ticket!.from!;
      to!.text = ticket!.to!;
      selectedCustomer = allCustomers!.firstWhere(
          (element) => element.customerNumber == ticket!.customerNumber);
      customerBalance!.text = selectedCustomer!.balance!.abs().toString();
      machineNumber!.text = ticket!.machineNumber!;
      selectedModel!.text = ticket!.machineModel!;
      _selectedCategory = ticket!.deliveryType!;
      _selectedStatus = ticket!.status!;
      _selectedCity.text = ticket!.city!;
      _techName = ticket!.techName!;
      _selectedReg = ticket!.region!;
    } catch (ex) {
      print(ex);
    }
  }
}
