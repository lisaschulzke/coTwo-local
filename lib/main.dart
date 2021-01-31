import 'dart:convert';

import 'package:co_two/compnents/custom_card.dart';
import 'package:co_two/compnents/custom_scaffold.dart';
import 'package:co_two/compnents/state_control.dart';
import 'package:co_two/scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'compnents/state_control.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => StateControl(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  void reqBackend(BuildContext context) async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    List<String> urls =
        await Provider.of<StateControl>(context, listen: false).read('urlList');

    urls.forEach((url) async {
      String response = await http.read(url);
      if (response.isNotEmpty) {
        // response JSON decode, dann mit methode aus statecontrol dem provider übergeben
        var newRoom = json.decode(response);
        Provider.of<StateControl>(context, listen: false).addRoom(newRoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    reqBackend(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff677792),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            buttonColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light),
      home: Home(title: 'Flutter Demo Home Page'),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Hallo",
      subtitle: " ",
      children: [
        _buildGridView(),
        _buildScanButton(),
      ],
    );
  }

  Widget _buildGridView() {
    return Positioned(
      top: 90,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // Consumer ruft diesen einen Change Notifier auf, und erlaubt Datenzugriff auf StateControl
        child: Consumer<StateControl>(
          builder: (context, stateControl, child) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: stateControl.rooms.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) {
                // print("______________");
                // print(stateControl.rooms);
                // print("______________");
                return CustomCard(
                  particleCount:
                      ((stateControl.rooms[index]["day"][0]["ppm"]) * 0.25)
                          .round(),
                  room: stateControl.rooms[index],
                  color: Colors.greenAccent,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    return Positioned(
      top: 10,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FlatButton(
            height: 40,
            color: Color(0xff677792),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.white, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scan()),
              );
            },
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      "Alfred scannen",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Icon(Icons.camera_alt_rounded),
                ],
              ),
            )),
      )
          // OutlineButton.icon(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => Scan()),
          //       );
          //     },
          //     label: Text("Alfred scannen", style: TextStyle(fontSize: 18),),
          //     icon: Icon(Icons.camera_alt_rounded),
          //     borderSide: BorderSide(color: Colors.white),
          //     textColor: Colors.white,
          //     padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 10.0)),
          ),
    );
  }
}
