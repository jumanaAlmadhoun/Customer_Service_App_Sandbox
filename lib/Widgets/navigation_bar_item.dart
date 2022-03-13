import 'package:flutter/material.dart';

class NavigationBarItem extends StatefulWidget {
  String text;
  NavigationBarItem({required this.text, Key? key}) : super(key: key);

  @override
  State<NavigationBarItem> createState() => _NavigationBarItemState();
}

class _NavigationBarItemState extends State<NavigationBarItem> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white60,
            onTap: () {},
            child: Container(
              height: 60.0,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.text,
                style: const TextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.bold),
              ),
            ),
          )),
    );
  }
}
