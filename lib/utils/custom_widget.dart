import 'dart:ui';
import 'dart:math' as math;
import 'package:example/models/Login_details.dart';
import 'package:example/utils/dateconversion.dart';
import 'package:flutter/material.dart';

class LoginDetail extends StatelessWidget {
  final LogDetails data;
  const LoginDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: 90,
          width: Width * 0.9,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: 90,
                    width: Width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                  )),
              Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 80,
                      width: Width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Dateconversion().getTime(data.date),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(data.ip, style: TextStyle(color: Colors.white)),
                          Text(data.location,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    height: 80,
                  )),
              Positioned(
                  right: 0,
                  child: data.qr!.isEmpty
                      ? Container()
                      : Container(
                          height: 90,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    '${data.qr}',
                                  ))),
                        ))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
