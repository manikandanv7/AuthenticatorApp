import 'package:example/Providers/logdataservice.dart';
import 'package:example/models/Login_details.dart';
import 'package:example/utils/custom_widget.dart';
import 'package:example/utils/dateconversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../Providers/authservice.dart';

class LoginHistory extends StatefulWidget {
  const LoginHistory({super.key});

  @override
  State<LoginHistory> createState() => _LoginHistoryState();
}

class _LoginHistoryState extends State<LoginHistory> {
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<Authservice>(context, listen: false);
    final lds = Provider.of<LogdataService>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    print('${lds.logdetails}in history Screen');
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: Container(
        child: Stack(
          children: [
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
                top: Width * 0.12,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            Positioned(
                width: Width,
                top: Width * 0.22,
                child: Center(
                  child: Container(
                    child: Center(
                      child: Text(
                        'Last Login',
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
                top: height * 0.25,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: height * 0.8,
                  width: Width,
                  color: Colors.black,
                  child: DefaultTabController(
                      initialIndex: 0,
                      length: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width -
                                Width * 0.30,
                            child: const TabBar(
                              indicatorColor: Colors.white,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                  child: Text(
                                    'Today',
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Tab(
                                      child: Text(
                                    'yesterday',
                                  )),
                                ),
                                Tab(child: Text('Others')),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                            height: height * 0.7 - 48,
                            width: Width,
                            child: TabBarView(children: [
                              Container(
                                height: height * 0.7 - 48,
                                width: Width,
                                child: ListView(
                                  children: [
                                    Column(
                                      children: lds.logdetails
                                          .where((element) =>
                                              Dateconversion()
                                                  .convertdate(element.date) ==
                                              Dateconversion().today)
                                          .map<Widget>((e) {
                                        return LoginDetail(data: e);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: height * 0.7 - 48,
                                width: Width,
                                child: ListView(
                                  children: [
                                    Column(
                                      children: lds.logdetails
                                          .where((element) =>
                                              Dateconversion()
                                                  .convertdate(element.date) ==
                                              Dateconversion().yesterday)
                                          .map<Widget>((e) {
                                        return LoginDetail(data: e);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: height * 0.7 - 48,
                                width: Width,
                                child: ListView(
                                  children: [
                                    Column(
                                      children: lds.logdetails
                                          .where((element) =>
                                              Dateconversion().convertdate(
                                                      element.date) !=
                                                  Dateconversion().today &&
                                              Dateconversion().convertdate(
                                                      element.date) !=
                                                  Dateconversion().yesterday)
                                          .map<Widget>((e) {
                                        return LoginDetail(data: e);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ],
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
