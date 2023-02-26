import 'dart:ffi';
import 'package:example/Providers/authservice.dart';
import 'package:example/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController mobilenumberController = new TextEditingController();
  TextEditingController OTPController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<Authservice>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          child: Stack(children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Stack(children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: height,
                width: Width,
                color: Colors.deepPurple[800],
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
                left: 0,
                top: 250,
                child: Container(
                  width: Width,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          width: Width - 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.deepPurple,
                          ),
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.purple,
                              controller: mobilenumberController,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mobilenumberController.text.length < 10 ||
                                mobilenumberController.text.isEmpty) {
                              showSnackBar(
                                  context, "Enter valid mobile number");
                            } else {
                              authprovider.signin(
                                  mobilenumberController.text, context);
                            }
                          },
                          child: Text(
                            'send OTP',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'OTP',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 35,
                          width: Width - 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.deepPurple,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.purple,
                            controller: OTPController,
                            obscureText: true,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                            height: 50,
                            width: Width - 100,
                            decoration: BoxDecoration(),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Colors.grey[700]),
                                onPressed: () {
                                  authprovider.verifyOtp(
                                      context: context,
                                      userOtp: OTPController.text);
                                },
                                child: Text('LOGIN')))
                      ],
                    ),
                  ),
                ))
          ]),
        ),
        Positioned(
            width: Width,
            top: Width * 0.22,
            child: Center(
              child: Container(
                child: Center(
                  child: Text(
                    'LOGIN',
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
      ])),
    );
  }
}
