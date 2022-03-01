import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/validators.dart';
import 'package:customer_service_app/Layouts/Creator/creator_home_page.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/customer.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Services/spare_parts_provider.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Services/user_provider.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:customer_service_app/Widgets/delivery_item_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class NewPartsDeliveryTicket extends StatefulWidget {
  const NewPartsDeliveryTicket({Key? key}) : super(key: key);

  @override
  _NewPartsDeliveryTicketState createState() => _NewPartsDeliveryTicketState();
}

class _NewPartsDeliveryTicketState extends State<NewPartsDeliveryTicket>
    with RouteAware {
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
  String _selectedCategory = 'N/A';
  List<String> category = ['N/A', 'Tech', 'Courier'];
  List<String> status = ['In Dispatch Area', 'In Transit', 'Delivered'];
  String _selectedStatus = 'In Dispatch Area';
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

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
    });
    await Provider.of<SparePartProvider>(context, listen: false)
        .fetchSpareParts()
        .then((value) {
      _allParts = Provider.of<SparePartProvider>(context, listen: false).parts;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTranselted(context, TIC_DELIVERY)!)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? const SpinKitChasingDots(
                color: APP_BAR_COLOR,
              )
            : ListView(children: [
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
                                : getTranselted(
                                        context, LBL_CUSTOMER_BALANCE)! +
                                    ' ' +
                                    getTranselted(
                                        context, LBL_CUSTOMER_BLOCKED)!,
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
                  suggestions:
                      cities.map((e) => e['name_ar'].toString()).toList(),
                  onTap: (value) {
                    setState(() {
                      _selectedCity.text = value!;
                      var city = cities.firstWhere((element) =>
                          element['name_ar'] == _selectedCity.text);
                      _selectedReg = city['reg_name_ar'];
                    });
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
                  items: status
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  value: _selectedStatus ?? '',
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value.toString();
                    });
                  },
                ),
                _selectedCategory == 'Tech'
                    ? SearchField(
                        suggestions: techs,
                        hint: getTranselted(context, LBL_TECH_NAME),
                        controller: _techNameController,
                        onTap: (String? value) {
                          setState(() {
                            _techName = value!;
                          });
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      return items[i];
                    }),
                const SizedBox(
                  height: 10,
                ),
                ButtonWidget(
                  text: getTranselted(context, LBL_ADD_ITEM)!,
                  onTap: () {
                    setState(() {
                      items.add(DeliveryItemWidget(
                        allParts: _allParts,
                      ));
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonWidget(
                  text: getTranselted(context, BTN_SUBMIT)!,
                  onTap: () async {
                    Map<String, dynamic> json = getTicketHeader()!;
                    await Provider.of<TicketProvider>(context, listen: false)
                        .submitNewDeliveryTicket(
                            json, '$DB_URL$DB_DELIVERY_TICKETS.json');
                  },
                ),
              ]),
      ),
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
    Map<String, dynamic> map = {};
    items.forEach((element) {
      if (element is DeliveryItemWidget) {
        if (map.containsKey(element.partNo.text)) {
          double qty = double.parse(map[element.partNo.text][1]);
          qty += double.parse(element.qty.text);
          map[element.partNo.text][1] = qty;
        } else {
          map.update(
            element.partNo.text,
            (value) => [element.desc.text, element.qty.text],
            ifAbsent: () => [element.desc.text, element.qty.text],
          );
        }
      }
    });
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
      Ticket.DELIVERY_TYPE: _selectedCategory,
      Ticket.CUSTOMER_NUMBER: customerNumber!.text.trim(),
      Ticket.CAFE_LOCATION: cafeLocation!.text.trim(),
      Ticket.VISIT_START_TIME: from!.text.trim(),
      Ticket.VISIT_END_TIME: to!.text.trim(),
      Ticket.DELIVERY_ITEMS: map
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
