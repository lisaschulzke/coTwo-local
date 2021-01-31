import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  final Map<String, dynamic> roomData;

  const Graph({Key key, this.roomData}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<FlSpot> getSpots() {
    List<FlSpot> spots = [];
    // print("#### length: ${widget.roomData.length}");
    for (var i = 0; i < widget.roomData["day"].length; i++) {
      spots.add(
        FlSpot((widget.roomData["day"][i]["timestamp"]).toDouble(),
            (widget.roomData["day"][i]["ppm"]).toDouble()),
      );
    }
    return spots;
  }

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.15,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 1.0, left: 10.0, top: 0, bottom: 0),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: FlatButton(
            child: Container(),
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            // child: Text(
            //   'avg',
            //   style: TextStyle(
            //       fontSize: 12,
            //       color:
            //           showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            // ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    List<double> intervals = [];
    getSpots().forEach((spot) {
      intervals.add(spot.x);
    });
    intervals.sort();
    print("intervals:");
    print(intervals);
    print("first: ${intervals.first.toString()}");
    print("last: ${intervals.last.toString()}");

    print("range: ${(intervals.last - intervals.first)}");

    print("interval: ${((intervals.last - intervals.first) / 4).toString()}");
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[300],
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey[300],
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: ((intervals.last - intervals.first) / 4),
          // interval: null,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            DateTime dateTime =
            //hier anstatt millis bla datetime.parse einfügen, da anders format aus backend
            // in mockbackend noch daten ändern
                DateTime.fromMillisecondsSinceEpoch(value.toInt());
            print("date: $dateTime");
            print("value $value");
            return DateFormat("HH:mm").format(dateTime);
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.grey[300], width: 1)),
      minX: intervals.first,
      maxX: intervals.last,
      minY: 350,
      maxY: 2500,
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
