// ignore_for_file: unused_local_variable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:the_balancer/helpingMethods/methods.dart';
import 'package:the_balancer/providers/userProvider.dart';

import '../providers/activityProvider.dart';

final methods = HelpingMethods();

class LineCharWidget extends StatefulWidget {
  final String year;
  final bool refresh;
  final String category;
  const LineCharWidget(
      {super.key,
      required this.year,
      required this.refresh,
      required this.category});

  @override
  State<LineCharWidget> createState() => _LineCharWidgetState();
}

class _LineCharWidgetState extends State<LineCharWidget> {
  bool isInternetConnected = false;
  bool isMockSelected = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.other) {
      setState(() {
        isInternetConnected = true;
      });
    } else {
      setState(() {
        isInternetConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerobj = Provider.of<ActivityProvider>(context, listen: false);
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final currentUserId =
        Provider.of<UserProvider>(context, listen: false).getCurrentUser.userId;

    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: AspectRatio(
        aspectRatio: 1.75,
        child: isInternetConnected
            ? FutureBuilder(
                future: Provider.of<ActivityProvider>(context)
                    .fetchSelectedYearActivitiesForLineChart(
                        widget.year, currentUserId, widget.refresh),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Center(
                          child: isAndroid
                              ? CircularProgressIndicator(
                                  color: Colors.blue.shade700,
                                )
                              : const CupertinoActivityIndicator(
                                  color: CupertinoColors.activeBlue,
                                  radius: 15.0,
                                )),
                    );
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    var listOfFlSpots =
                        snapshot.data as Map<String, List<FlSpot>>;

                    // pointsToTitles = listOfFlSpots;
                    // List<LineChartBarData> points = [];

                    // for (var category in listOfFlSpots.entries) {
                    //   if(category.value.isNotEmpty ) {
                    //         final point = LineChartBarData(
                    //                   spots: category.value,
                    //                   isCurved: true,
                    //                   preventCurveOverShooting: true,
                    //                   dotData: FlDotData(show: false),
                    //                   color: methods.getColor(category.key),
                    //                 );
                    //           points.add(point);
                    //       } else {
                    //         // final emptyPoint = LineChartBarData(
                    //         //           spots: List<FlSpot>.generate(12, (index) => const FlSpot(0.0, 0.0)),
                    //         //           isCurved: true,
                    //         //           preventCurveOverShooting: true,
                    //         //           dotData: FlDotData(show: false),
                    //         //           color: Colors.transparent,
                    //         //         );
                    //         //   points.add(emptyPoint);
                    //       }
                    // }

                    // return Column(
                    //   children: [
                    //     SizedBox(
                    //       height: screenSize.height * 0.24,
                    //       child: SfCartesianChart(
                    //         tooltipBehavior:
                    //             TooltipBehavior(enable: true, decimalPlaces: 2),
                    //         series: <ChartSeries>[
                    //           for (final category in listOfFlSpots.entries)
                    //             LineSeries(
                    //                 onPointTap: (ChartPointDetails
                    //                     pointInteractionDetails) {
                    //                   // print(category.value.first.x.toString());
                    //                   print('DETAILS');
                    //                   print(pointInteractionDetails.pointIndex);
                    //                   final FlSpot flSpot = category.value[
                    //                       pointInteractionDetails.pointIndex!];
                    //                   final monthIndex = flSpot.x;
                    //                   providerobj.setmonth(monthIndex);
                    //                 },
                    //                 enableTooltip: true,
                    //                 dataSource: category.value,
                    //                 xValueMapper: (datum, _) =>
                    //                     getMonth(datum.x),
                    //                 yValueMapper: (datum, _) => datum.y,
                    //                 color: methods.getColor(category.key),
                    //                 name: category.key,
                    //                 markerSettings: MarkerSettings(
                    //                   isVisible: true,
                    //                   shape: DataMarkerType.circle,
                    //                   borderColor:
                    //                       methods.getColor(category.key),
                    //                   borderWidth: 1.0,
                    //                   color: Colors.white,
                    //                 ))
                    //         ],
                    //         primaryXAxis: CategoryAxis(),

                    //         // primaryYAxis:
                    //       ),
                    //     ),
                    //   ],
                    // );

                    return LineChart(
                      LineChartData(
                          // lineBarsData: points,
                          lineBarsData: [
                            // for (var category in listOfFlSpots.entries)
                            // if(category.value.isNotEmpty)
                            // LineChartBarData(
                            //   spots: category.value,
                            //   isCurved: true,
                            //   preventCurveOverShooting: true,
                            //   dotData: FlDotData(show: false),
                            //   color: methods.getColor(category.key),
                            // ),

                            for (final category in listOfFlSpots.entries)
                              if (category.value.reduce((value, element) {
                                    var val = value.y + element.y;
                                    return FlSpot(value.x, val);
                                  }).y !=
                                  0.0)
                                LineChartBarData(
                                  spots: category.value,
                                  isCurved: true,
                                  preventCurveOverShooting: true,
                                  dotData: FlDotData(show: false),
                                  color: methods.getColor(category.key),
                                )
                          ],
                          borderData: FlBorderData(
                            border: const Border(
                                bottom: BorderSide(), left: BorderSide()),
                          ),
                          gridData: FlGridData(show: false),
                          maxY: 100,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: _bottomTitles,
                            ),
                            leftTitles: AxisTitles(sideTitles: _leftTitles),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineTouchData: LineTouchData()),
                      swapAnimationDuration: const Duration(milliseconds: 150),
                      swapAnimationCurve: Curves.bounceInOut,
                    );
                  }

                  return Center(
                    child: Text(
                      'No Data To Show',
                      style: GoogleFonts.quicksand(
                          color: const Color.fromRGBO(46, 58, 89, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                child: Text('No Internet Connection',
                    style: GoogleFonts.quicksand(
                        color: const Color.fromRGBO(46, 58, 89, 1),
                        fontSize: 20.0)),
              ),
      ),
    );
  }

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 450 &&
      MediaQuery.of(context).size.width <= 1000;

  SideTitles get _leftTitles => SideTitles(
        reservedSize: 30,
        showTitles: true,
        interval: 10,
        getTitlesWidget: (value, meta) {
          String text = value.toStringAsPrecision(2);
          if (value == 0.0) text = '0';
          if (value == 100.0) text = '100';
          return Text(
            "$text%",
            style: GoogleFonts.roboto(
              fontSize: isTablet(context) ? 12 : 8,
              color: Colors.grey,
            ),
          );
        },
      );

  String getMonth(double num) {
    if (num == 0) return 'Jan';
    if (num == 1) return 'Feb';
    if (num == 2) return 'Mar';
    if (num == 3) return 'Apr';
    if (num == 4) return 'May';
    if (num == 5) return 'Jun';
    if (num == 6) return 'Jul';
    if (num == 7) return 'Aug';
    if (num == 8) return 'Sep';
    if (num == 9) return 'Oct';
    if (num == 10) {
      return 'Nov';
    } else {
      return 'Dec';
    }
  }

  SideTitles getSideTitles(Map<String, List<FlSpot>> lisOfFlSpots) {
    final values = lisOfFlSpots.values.toList()[0];

    return SideTitles(
        reservedSize: 30,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = "";

          for (var fl in values) {
            var intVal = fl.x.toInt();

            switch (intVal) {
              case 0:
                text = 'Jan';
                break;
              case 1:
                text = 'Feb';
                break;
              case 2:
                text = 'Mar';
                break;
              case 3:
                text = 'Apr';
                break;
              case 4:
                text = 'May';
                break;
              case 5:
                text = 'Jun';
                break;
              case 6:
                text = 'Jul';
                break;
              case 7:
                text = 'Aug';
                break;
              case 8:
                text = 'Sep';
                break;
              case 9:
                text = 'Oct';
                break;
              case 10:
                text = 'Nov';
                break;
              case 11:
                text = 'Dec';
                break;

              default:
                text = '';
            }

            break;

            // if(fl.x == 0) text = 'Jan';
            // if(fl.x == 1) text = 'Feb';
            // if(fl.x == 2) text = 'Mar';
            // if(fl.x == 3) text = 'Apr';
            // if(fl.x == 4) text = 'May';
            // if(fl.x == 5) text = 'Jun';
            // if(fl.x == 6) text = 'Jul';
            // if(fl.x == 7) text = 'Aug';
            // if(fl.x == 8) text = 'Sep';
            // if(fl.x == 9) text = 'Oct';
            // if(fl.x == 10) text = 'Nov';
            // if(fl.x == 11) text = 'Dec';
          }

          return Text(
            text,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 10),
          );
        });
  }
  
  SideTitles get _bottomTitles => SideTitles(
    reservedSize: 30,
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String text = "";
      switch (value.toInt()) {
        case 0:
          text = "Jan";
          break;
        case 1:
          text = "Feb";
          break;
        case 2:
          text = "Mar";
          break;
        case 3:
          text = "Apr";
          break;
        case 4:
          text = "May";
          break;
        case 5:
          text = "Jun";
          break;
        case 6:
          text = "Jul";
          break;
        case 7:
          text = "Aug";
          break;
        case 8:
          text = "Sep";
          break;
        case 9:
          text = "Oct";
          break;
        case 10:
          text = "Nov";
          break;
        case 11:
          text = "Dec";
          break;
        default:
          text = '';
      }

      return Text(
        text,
        style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 10),
      );
    });
}


