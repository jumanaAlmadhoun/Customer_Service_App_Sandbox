import 'package:customer_service_app/Helpers/validators.dart';
import 'package:customer_service_app/Layouts/Creator/creator_home_page.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/customer.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class NewDeliveryTicket extends StatefulWidget {
  const NewDeliveryTicket({Key? key}) : super(key: key);

  @override
  _NewDeliveryTicketState createState() => _NewDeliveryTicketState();
}

class _NewDeliveryTicketState extends State<NewDeliveryTicket> with RouteAware {
  List<Widget> items = [];
  List<SparePart> _allParts = [];
  bool _isLoading = false;

  TextEditingController? customerNumber = TextEditingController();
  TextEditingController? customerName = TextEditingController();
  TextEditingController? customerMobile = TextEditingController();
  TextEditingController? cafeName = TextEditingController();
  TextEditingController? cafeLocation = TextEditingController();
  TextEditingController? city = TextEditingController();
  TextEditingController? extraNumber = TextEditingController();
  TextEditingController? customerBalance = TextEditingController();
  TextEditingController? _techNameController = TextEditingController();
  TextEditingController? _machineModelController = TextEditingController();
  TextEditingController? visitDate = TextEditingController();
  TextEditingController? from = TextEditingController();
  TextEditingController? to = TextEditingController();
  String _techName = 'N/A';
  TextEditingController _selectedCity = TextEditingController();
  String _selectedReg = '';
  List<String> techs = [];
  List<Customer>? allCustomers;
  Customer? selectedCustomer;
  Map<String, dynamic>? ticketHeader;

  @override
  void didPush() async {
    super.didPush();
    setState(() {
      _isLoading = true;
    });
    allCustomers =
        Provider.of<CustomerProvider>(context, listen: false).customers;
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
      appBar: AppBar(title: Text(getTranselted(context, TIC_DELIVERY)!)),
      body: ListView(children: [
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
        SearchField(
          controller: _selectedCity,
          hint: getTranselted(context, LBL_CITY),
          suggestions: cities.map((e) => e['name_ar'].toString()).toList(),
          onTap: (value) {
            setState(() {
              _selectedCity.text = value!;
              var city = cities.firstWhere(
                  (element) => element['name_ar'] == _selectedCity.text);
              _selectedReg = city['reg_name_ar'];
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        SearchField(
          initialValue: _techName,
          suggestions: techs,
          hint: getTranselted(context, LBL_TECH_NAME),
          controller: _techNameController,
          onTap: (String? value) {
            setState(() {
              _techName = value!;
            });
          },
        ),
      ]),
    );
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

  void clearCustomerValues() {
    setState(() {
      customerName!.text = '';
      cafeName!.text = '';
      customerMobile!.text = '';
      customerBalance!.text = '';
      selectedCustomer = null;
    });
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
      Ticket.CITY: _selectedCity.text.trim(),
      Ticket.REGION: _selectedReg,
      Ticket.TECH_NAME: _techName,
      Ticket.MAIN_CATEGORY: Ticket.DELIVERY_CATEGORY,
      Ticket.SUB_CATEGORY: Ticket.PARTS_DELIVERY,
      Ticket.CUSTOMER_NUMBER: customerNumber!.text.trim(),
      Ticket.CAFE_LOCATION: cafeLocation!.text.trim(),
      Ticket.VISIT_START_TIME: from!.text.trim(),
      Ticket.VISIT_END_TIME: to!.text.trim(),
    };
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
}
