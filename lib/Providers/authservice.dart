import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:example/Providers/logdataservice.dart';
import 'package:example/Providers/personalInfo_service.dart';

import 'package:example/constants.dart';
import 'package:example/models/Login_details.dart';
import 'package:example/utils/custom_widget.dart';

import 'package:example/views/dashboardscreen.dart';
import 'package:example/views/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../utils/snackbar.dart';

class Authservice extends ChangeNotifier {
  String? _uid;
  String get uid => _uid!;
  String verification_Id = '';
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  // String? _lastlogin = "";
  // String get lastlogin => _lastlogin!;
  // List<LogDetails> logdetails = [];
  Authservice() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool("is_signedin") ?? false;
    final latestdoc = await store
        .collection('users')
        .doc(_uid)
        .collection('logindetails')
        .snapshots()
        .last;
    // final snap = latestdoc.docs.elementAt(0);
    // // print('$snap hiiiiiiiiiiiiiiiiii');
    // _lastlogin = snap['date'].toString();

    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await store.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS..........................");
      return true;
    } else {
      print("NEW USER.........................................");
      return false;
    }
  }

  void signin(String number, BuildContext context) async {
    try {
      auth.verifyPhoneNumber(
          phoneNumber: "+91$number",
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            verification_Id = verificationId;
          },
          codeAutoRetrievalTimeout: (String x) {});
      print(number + "...............................................");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String userOtp,
  }) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verification_Id, smsCode: userOtp);

      User? user = (await auth.signInWithCredential(creds)).user;

      if (user != null) {
        _uid = user.uid;
        setSignIn();
        notifyListeners();
        checkExistingUser().then((value) => {
              if (value == false)
                {saveUsertoFirestore(user.phoneNumber.toString(), user.uid)}
            });

        saveLogDatatoFirestore(context);
        SharedPreferences sf = await SharedPreferences.getInstance();
        sf.setBool('saved', true);
        // final lds = Provider.of<LogdataService>(context, listen: false);
        // final data = await store
        //     .collection('users')
        //     .doc(_uid)
        //     .collection('logindetails')
        //     .get();
        // lds.initialiseLog(data);
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());

      notifyListeners();
    }
  }

  void saveLogDatatoFirestore(BuildContext context) async {
    final ipadd = await Personal_info().getip();
    final locationad = await Personal_info().getlocation();
    final logtime = DateTime.now().millisecondsSinceEpoch.toString();

    LogDetails log = LogDetails(
        ip: ipadd.toString(),
        location: locationad.toString(),
        date: logtime.toString(),
        qr: '');

    final QuerySnapshot querySnap = await store
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('logindetails')
        .get();
    final int documents = querySnap.docs.length;

    await store
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('logindetails')
        .doc('${documents + 1}')
        .set(log.toMap())
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ),
            ));
  }

  void saveUsertoFirestore(String mobilenumber, String uid) async {
    UserModel user1 = new UserModel(
        phoneNumber: mobilenumber,
        uid: uid,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString());
    await store.collection("users").doc(uid).set(user1.toMap());
  }

  void saveQrtoStorage(
      File file, String generatedNumber, BuildContext ctx) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    final saved = await sf.getBool('saved');
    if (saved == true) {
      UploadTask uploadTask =
          storage.ref().child('QRCODE/$generatedNumber').putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      updateQrdatatoFiretore(downloadUrl);

      sf.setBool('saved', false);
      showSnackBar(ctx, "Qr Saved Successfully!");
    } else {
      showSnackBar(ctx, 'Qr Already saved,Login again to generate new Qr!');
    }
  }

  void updateQrdatatoFiretore(String url) async {
    final QuerySnapshot qSnap = await store
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('logindetails')
        .get();
    final int documents = qSnap.docs.length;
    // print('$documents.................');
    // print('${auth.currentUser!.uid}.....................');
    // print(url);
    await store
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('logindetails')
        .doc('${documents}')
        .update({"qr": url});
  }

  Future userSignOut(BuildContext context) async {
    await auth.signOut();
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    sharedPreferences.clear();
    notifyListeners();
  }
}
