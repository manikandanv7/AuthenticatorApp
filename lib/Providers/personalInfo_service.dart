import 'dart:math';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Personal_info extends ChangeNotifier {
  String _ip = "";
  String get ip => _ip;
  String _location = "";
  String get location => _location;
  String RandomNumber = (999 + Random().nextInt(99999 - 999)).toString();
  getip() async {
    final ipv4 = await Ipify.ipv4();
    _ip = ipv4;
    print("ip address:" + _ip);
    print(DateFormat.yMMMd().add_jm().format(DateTime.now()));
    notifyListeners();
    return _ip;
  }

  getlocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service is disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      return Future.error('Location service is denied');
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location service is denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    print(position);

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    _location = place.locality.toString();
    print(location);

    notifyListeners();
    return location;
  }
}
