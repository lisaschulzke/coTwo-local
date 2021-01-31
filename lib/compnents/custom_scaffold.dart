import 'package:co_two/detail.dart';
import 'package:co_two/main.dart';
import 'package:co_two/scan.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //self defined properties to customize customScaffold widget
  final List<Widget> children; // which content is displayed
  final String title;
  final String subtitle; //what's the name

//constructor takes values of properties (e.g. this.title) and puts it into variable (e.g. title)
//cunstructor only necessary if i want to give individual information by having a global component
  CustomScaffold(
      {Key key, @required this.children, @required this.title, this.subtitle})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    //is only valid in the build function, and is later used in the stack widget --> property children receives variable stackChildren
    List<Widget> stackChildren = [];

    // stackchildren contains elipse, because this is what i want to have in every screen
    stackChildren.add(_buildElipse(context));

    this.children.forEach((child) {
      stackChildren.add(child);
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffC0C5CD),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
          color: Colors.white,
        ),
        title: Text(
          this.title,
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Color(0xff677792),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                }),
            ListTile(
              title: Text("Scan"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scan()),
                );
              },
            ),
            ListTile(
              title: Text("Journal"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Detail()),
                );
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }

  Widget _buildElipse(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        child: Text(
          this.subtitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        padding: EdgeInsets.only(left: 75),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(MediaQuery.of(context).size.width, 60)),
          color: Color(0xffC677792),
        ),
      ),
    );
  }
}
