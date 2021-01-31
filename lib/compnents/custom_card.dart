import 'package:animated_background/animated_background.dart';
import 'package:co_two/detail.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //self defined properties to customize customScaffold widget
  final List<Widget> children; // which content is displayed
  final Map<String, dynamic> room;
  final Color color;
  final int particleCount; //what's the name

//constructor takes values of properties (e.g. this.title) and puts it into variable (e.g. title)
//cunstructor only necessary if i want to give individual information by having a global component
  CustomCard({
    Key key,
    this.children,
    @required this.room,
    @required this.particleCount,
    @required this.color,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Detail(oneRoomData: widget.room,)),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                options: ParticleOptions(
                  //TODO: make the count dynamic
                  particleCount: widget.particleCount,
                  spawnMinSpeed: 1.2,
                  spawnMaxSpeed: 5.5,
                  baseColor: Color(0xff81B9BF),
                  minOpacity: 0.1,
                  maxOpacity: 0.9,
                ),
              ),
              vsync: this,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(children: [
                    Positioned(
                      // top: 20,
                      child: Container(
                          child: Row(children: [
                            Container(
                              margin: EdgeInsets.only(right: 10.0),
                              height: 17,
                              width: 17,
                              //TODO: make color dynamic with ppm value
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: (widget.room["day"][0]["ppm"] <= 800)? Colors.green : Colors.red),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.room["title"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(widget.room["subtitle"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12))
                              ],
                            ),
                          ]),
                          padding: EdgeInsets.all(7),
                          // margin: EdgeInsets.only(left: 10.0, right: 0.0),
                          height: 50,
                          width: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                  ])
                ],
              ),
            ),
          ),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
