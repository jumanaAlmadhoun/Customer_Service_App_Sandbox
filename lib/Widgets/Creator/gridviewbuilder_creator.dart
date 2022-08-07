// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../Helpers/global_vars.dart';
import '../../Helpers/scripts_constants.dart';
import '../../Routes/route_names.dart';
import '../../Services/ticket_provider.dart';
import '../open_ticket_widget.dart';
import 'custom_list_dialgo.dart';

class GridViewBuilderCreator extends StatefulWidget {
  List list;
  CustomListDialog? dialog;
  GridViewBuilderCreator({Key? key, required this.list, this.dialog})
      : super(key: key);

  @override
  State<GridViewBuilderCreator> createState() => _GridViewBuilderCreatorState();
}

class _GridViewBuilderCreatorState extends State<GridViewBuilderCreator> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, i) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) async {
              print('Shady');
              if (widget.dialog != null) {
                setState(() {
                  _isLoading = true;
                });
                Provider.of<TicketProvider>(context, listen: false)
                    .archiveTicket(widget.list[i], widget.dialog!.value)
                    .then((value) async {
                  if (value == SC_SUCCESS_RESPONSE) {
                    setState(() {
                      _isLoading = false;
                      widget.list.remove(widget.list[i]);
                    });
                  } else {}
                });
              }
            },
            confirmDismiss: (direction) async {
              print('shadddddi');
              widget.dialog = CustomListDialog(
                msg: 'Archive Ticket',
                items: archiveReasons,
              );
              return await showDialog(
                  context: context, builder: (_) => widget.dialog!);
            },
            child: OpenTicketWidget(
              cafeName: widget.list[i].cafeName,
              city: widget.list[i].city,
              customerMobile: widget.list[i].customerMobile,
              customerName: widget.list[i].customerName,
              date: widget.list[i].creationDate,
              didContact: widget.list[i].didContact,
              machineNumber: widget.list[i].machineNumber,
              onTap: () {
                Navigator.pushNamed(context, sanremoEditTicketRoute,
                    arguments: widget.list[i]);
              },
            ),
          );
        },
      ),
    );
  }
}
