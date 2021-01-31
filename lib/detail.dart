import 'package:co_two/compnents/custom_scaffold.dart';
import 'package:co_two/compnents/empty_screen.dart';
import 'package:co_two/compnents/graph.dart';
import 'package:co_two/compnents/state_control.dart';
import 'package:co_two/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Detail extends StatefulWidget {
  final Map<String, dynamic> oneRoomData;

//constructor
  const Detail({Key key, this.oneRoomData}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<bool> _selections = List.generate(3, (_) => false);
  bool _active = false;
  int _index = 0;

  void _toggleActiveState(int index) {
    // print(_active);
    // print(index);

    setState(() {
      // if (index == 1 || index == 2) {
      //   _active = true;
      // } else {
      //   _active = false;
      // }
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_active);
    // print(widget.oneRoomData["day"]);
    return CustomScaffold(
      title: widget.oneRoomData["title"],
      subtitle: widget.oneRoomData["subtitle"],
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 20),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ToggleSwitch(
                  minWidth: 200,
                  fontSize: 18,
                  inactiveFgColor: Theme.of(context).primaryColor,
                  cornerRadius: 20,
                  initialLabelIndex: _index,
                  labels: ["Heute", "Woche", "Monat"],
                  activeBgColor: Color(0xff81B9BF),
                  inactiveBgColor: Colors.white,
                  onToggle: _toggleActiveState,
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: (_index == 1 || _index == 2
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            width: 150,
                            child: Center(
                              child: Card(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      'assets/images/data_blue.png',
                                      height: 400,
                                      width: 400,
                                    )),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 45, right: 45),
                                      child: Text(
                                        "Du hast noch nicht genügend Daten gesammelt für diese Ansicht.",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Text(
                            //   "Noch nicht genug Daten gesammelt für diese Ansicht ;)",
                            //   style: TextStyle(
                            //       fontSize: 16,
                            //       color: Theme.of(context).primaryColor),
                            // ),
                          )
                        : Center(
                            child: Column(
                              children: [
                                Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      title: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 0),
                                            child: Text(
                                              "CO2",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 30),
                                            child: Text(
                                              // to string necessary because it is a text widget and it always needs to be a string
                                              // and int is not a string so it has to be converted to a string to make it visible in text widget
                                              widget.oneRoomData["day"][0]
                                                      ["ppm"]
                                                  .toString(),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 7, top: 5),
                                            child: Text(
                                              "ppm",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      leading: Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 23,
                                      ),
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(right: 15),
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 20, bottom: 10, right: 8, left: 8),
                                                child: Graph(
                                                    roomData:
                                                        widget.oneRoomData),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ExpansionTile(
                                      title: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 0),
                                            child: Text(
                                              "Temperatur",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 30),
                                            child: Text(
                                              "22,5",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 7, top: 5),
                                            child: Text(
                                              "°C",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      leading: Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 23,
                                      ),
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(right: 15),
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 90, bottom: 10),
                                                child: Graph(
                                                    roomData:
                                                        widget.oneRoomData),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ExpansionTile(
                                      title: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 0),
                                            child: Text(
                                              "Luftfeuchtigkeit",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 30),
                                            child: Text(
                                              "53",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 7, top: 5),
                                            child: Text(
                                              "%",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      leading: Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 23,
                                      ),
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(right: 15),
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 90, bottom: 10),
                                                child: Graph(
                                                    roomData:
                                                        widget.oneRoomData),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
