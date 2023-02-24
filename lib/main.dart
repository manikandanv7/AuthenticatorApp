import 'package:example/Providers/logdataservice.dart';
import 'package:example/Providers/authservice.dart';
import 'package:example/views/LoginHistoryScreen.dart';
import 'package:example/views/dashboardscreen.dart';
import 'package:example/views/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:example/Providers/personalInfo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isloggedIn = prefs.getBool('is_signedin') ?? false;
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await Personal_info().getlocation();
//  await Personal_info().getip();

  runApp(MyApp(
    isloggedIn: isloggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isloggedIn;
  const MyApp({super.key, required this.isloggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Authservice>(create: (_) => Authservice()),
        ChangeNotifierProvider<Personal_info>(create: (_) => Personal_info()),
        ChangeNotifierProvider<LogdataService>(create: (_) => LogdataService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isloggedIn ? DashboardScreen() : LoginScreen(),
        title: "FlutterAuthenticator",
      ),
    );
  }
}
