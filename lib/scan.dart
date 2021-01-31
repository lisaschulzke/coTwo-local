import 'dart:convert';

import 'package:co_two/compnents/custom_scaffold.dart';
import 'package:co_two/compnents/state_control.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'compnents/state_control.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String _scanned = "";
  String _data = "";
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "KUB scannen",
      subtitle: "Scanne einen QR-Code, um einen neuen Raum hinzuzufügen.",
      children: [
        Positioned(
          top: 130,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 8.0, color: const Color(0xFFFFFFFF)),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        width: 300.0,
                        height: 300.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _scanned.isEmpty
                              ? QrCamera(
                                  fit: BoxFit.cover,
                                  onError: (context, error) => Text("Error"),
                                  qrCodeCallback: (code) async {
                                    if (code.contains("http://")) {
                                      setState(() {
                                        _scanned = code;
                                      });
                                    }
                                  },
                                )
                              : RaisedButton(
                                  onPressed: () async {
                                    print(_scanned);
                                    String response = await http.read(_scanned);

                                    Provider.of<StateControl>(context,
                                            listen: false)
                                        .addUrl(_scanned);

                                    if (response.isNotEmpty) {
                                      // response JSON decode, dann mit methode aus statecontrol dem provider übergeben
                                      var newRoom = json.decode(response);
                                      Provider.of<StateControl>(context,
                                              listen: false)
                                          .addRoom(newRoom);
                                      setState(() {
                                        _data = response;
                                      });
                                    }
                                  },
                                  child: Text(
                                      "Get data from $_scanned and scan again..."),
                                ),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30, left: 55, right: 45),
                    child: Text(
                      "Platziere das Scanfenster über einem QR-Code um ihn zu scannen.",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 25),
                    child: Image.asset(
                      'assets/images/qr_code_pink.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text("Data: $_data"),
            ),
          ),
        )
      ],
    );
  }
}
