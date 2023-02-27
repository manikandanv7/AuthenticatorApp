// ignore_for_file: non_constant_identifier_names

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/Providers/logdataservice.dart';
import 'package:example/constants.dart';
import 'package:example/views/LoginHistoryScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:example/Providers/authservice.dart';
import 'package:example/Providers/personalInfo_service.dart';
import '../utils/dateconversion.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final globalKey = GlobalKey();
  Future<File> _captureAndSharePng() async {
    RenderRepaintBoundary? boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final tempDir = await getExternalStorageDirectory();
    final file = await new File('${tempDir!.path}/shareqr.png').create();
    await file.writeAsBytes(pngBytes);
    return file;
  }

  bool isLoading = true;

  Future<void> getlogindetails(LogdataService d) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('logindetails')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        print("I am empty");
      }
      d.initialiseLog(value);

      Future.delayed(Duration(seconds: 2), () {
        //  print("I am Getting Data");

        //  isLoading = false;

        //  d.initialiseLog(value);
      });
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    final authprovider = Provider.of<Authservice>(context, listen: false);
    final Pf = Provider.of<Personal_info>(context, listen: false);
    final lds = Provider.of<LogdataService>(context, listen: false);
    // final ip = Pf.getip();

    authprovider.checkSign();
    // getlogindetails(lds);
    // final location = Pf.getlocation();
    print('i am build....................');
    print("${lds.logdetails} log details in das screen ");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: FutureBuilder(
              // initialData: lds.logdetails,
              future: getlogindetails(lds),
              builder: (context, data) {
                if (lds.logdetails.isEmpty) {
                  getlogindetails(lds);
                  return Center(child: CircularProgressIndicator());
                }
                return Stack(
                  children: [
                    Positioned(
                        child: Container(
                      color: Colors.deepPurple[800],
                    )),
                    Positioned(
                      top: -65,
                      right: -40,
                      child: Container(
                        height: Width * 0.43,
                        width: Width * 0.43,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                            borderRadius: BorderRadius.circular(180)),
                      ),
                    ),
                    Positioned(
                        top: Width * 0.12,
                        right: 20,
                        child: TextButton(
                          onPressed: () {
                            authprovider.userSignOut(context);
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )),
                    Positioned(
                      top: Width * 0.27,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            color: Colors.black),
                        height: height,
                        width: Width,
                      ),
                    ),
                    Positioned(
                        width: Width,
                        top: Width * 0.22,
                        child: Center(
                          child: Container(
                            child: Center(
                              child: const Text(
                                'PLUGIN',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            height: 40,
                            width: 100,
                          ),
                        )),
                    Positioned(
                        top: height * 0.38,
                        width: Width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: height * 0.234,
                              width: Width * 0.7,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        height: height * 0.234,
                                        width: Width * 0.7,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey[900],
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      )),
                                  Positioned(
                                    top: -233,
                                    left: 131,
                                    child: Transform.rotate(
                                      angle: -math.pi / 3.08,
                                      child: Center(
                                        child: Container(
                                            height: 500,
                                            width: 320,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.deepPurple[800],
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 180,
                                    width: 280,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Generated Number',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          Pf.RandomNumber,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginHistory())),
                              child: Container(
                                width: Width * 0.7,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 50,
                                child: Center(
                                    child: Text(
                                  lds.logdetails.last.date == null ||
                                          lds.logdetails.last.date.isEmpty
                                      ? 'No Record Found'
                                      : 'Last Login at ${Dateconversion().lastLogin(lds.logdetails.last.date)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () => _captureAndSharePng().then((value) {
                                authprovider.saveQrtoStorage(
                                    value, Pf.RandomNumber, context);
                                print('Image captures');
                                getlogindetails(lds);
                              }),
                              child: Container(
                                width: Width * 0.7,
                                decoration: BoxDecoration(
                                    color: Colors.grey[700],
                                    borderRadius: BorderRadius.circular(10)),
                                height: 50,
                                child: const Center(
                                    child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )
                          ],
                        )),
                    Positioned(
                        top: height * 0.26,
                        child: Container(
                          alignment: Alignment.center,
                          width: Width,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            height: 125,
                            width: 125,
                            child: RepaintBoundary(
                                key: globalKey,
                                child: QrImage(
                                  data: Pf.RandomNumber,
                                  errorStateBuilder: (cxt, err) {
                                    return Container(
                                      child: const Center(
                                        child: Text(
                                          "Something gone wrong ...",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ),
                        )),
                    // Positioned(
                    //   bottom: 50,
                    //   left: 39,
                    //   child: ,
                    // ),
                    // Positioned(
                    //   bottom: 120,
                    //   left: 39,
                    //   child: ,
                    // )
                  ],
                );
              })),
    );
  }
}
