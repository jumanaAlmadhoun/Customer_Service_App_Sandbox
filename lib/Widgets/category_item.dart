// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../Helpers/layout_constants.dart';

class CategoryItem extends StatelessWidget {
  final String? title;
  final int? number;
  final String? image;
  final onTap;

  const CategoryItem({this.image, this.number, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage(image!), fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ICONS_COLOR, width: 4.0),
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                  Colors.black.withOpacity(.9),
                  Colors.black.withOpacity(.3),
                ])),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(title!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Text(
                '${number ?? ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Transform.translate(
                offset: const Offset(50, -50),
              ),
            ]),
          ),
        ),
      ),

      /*Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          image: DecorationImage(
              image: AssetImage(image!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.luminosity)),
        ),
        child: Column(
          children: [
            const Spacer(),
            // Container(
            //   height: number == null ? 100 : 100,
            //   child: Image.asset(
            //     image!,
            //     fit: BoxFit.contain,
            //   ),
            // ),
            // const Spacer(),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${number ?? ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            const Spacer(),
          ],
        ),
      ),*/
    ); /*Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          // padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(width: 0.7),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 17,
                spreadRadius: -23,
                color: SHADOW_COLOR,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Container(
                      height: number == null ? 100 : 100,
                      child: Image.asset(
                        image!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${number ?? ''}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );*/
  }
}
