import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/models/Login_details.dart';
import 'package:example/utils/custom_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LogdataService extends ChangeNotifier {
  List<LogDetails> logdetails = [];

  void initialiseLog(QuerySnapshot<Map<String, dynamic>> data) {
    logdetails = [];
    for (int i = 0; i < data.docs.length; i++) {
      logdetails.add(LogDetails(
          ip: data.docs[i]['ip'],
          location: data.docs[i]['location'],
          date: data.docs[i]['date'],
          qr: data.docs[i]['qr']));
    }
    print("I am Completing the data");
    notifyListeners();
  }
  
 
}
