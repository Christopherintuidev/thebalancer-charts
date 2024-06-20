// ignore_for_file: unused_local_variable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:the_balancer/helpingMethods/methods.dart';
import 'package:the_balancer/screens/user_profile_settings_screen.dart';

import '../providers/activityProvider.dart';

//Creating a PieChartData class
class PieChartData {
  final String categoryName;
  final double value;

  PieChartData(this.categoryName, this.value);
}

class PieChartWidget extends StatefulWidget {
  final String? pieChartName;
  final Map<String, double>? desiredPercentages;
  final bool isFromHome;

  const PieChartWidget(
      {super.key,
      this.pieChartName,
      this.desiredPercentages,
      required this.isFromHome});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  final methods = HelpingMethods();
  late Map<String, double> dataMap;
  late Map<String, double> actualPercentages;
  bool isInternetConnected = false;

  @override
  void initState() {
    if (widget.desiredPercentages != null) {
      dataMap = widget.desiredPercentages!;
    } else {
      dataMap = {
        "Nutrition": 5,
        "Excercise": 3,
        "Occupation": 2,
        "Wealth": 2,
        "Creation": 3,
        "Recreation": 2,
        "Kids": 3,
        "Family": 6,
        "Romance": 2,
        "Friends": 2,
        "Spirituality": 3,
        "Self-Love": 3,
      };
    }
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //Checking internet connectivity
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

  List<Color> colorsList = HelpingMethods.pieChartColorsList;

  @override
  Widget build(BuildContext context) {
    bool isTablet(BuildContext context) =>
        MediaQuery.of(context).size.width > 450 &&
        MediaQuery.of(context).size.width <= 1050;
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width <= 450;
    bool isExtraSmallMobile(BuildContext context) =>
        MediaQuery.of(context).size.width <= 340;
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final actualPercentages =
        Provider.of<ActivityProvider>(context).mapOfActualPercentages;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              widget.pieChartName!,
              style: GoogleFonts.poppins(
                  color: const Color.fromRGBO(46, 58, 89, 1),
                  fontSize: isExtraSmallMobile(context)
                      ? 10
                      : isTablet(context)
                          ? 20.0
                          : 16),
            )),
        const SizedBox(
          height: 10,
        ),
        if (isMobile(context) && widget.isFromHome)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10.0,
                    spreadRadius: 5.0),
              ],
              shape: BoxShape.circle,
            ),
            child: PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              initialAngleInDegree: 0,
              colorList: colorsList,
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: false,
              ),
              legendOptions: const LegendOptions(
                showLegends: false,
              ),
            ),
          ),
        if (isMobile(context) && widget.isFromHome == false)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10.0,
                    spreadRadius: 5.0),
              ],
              shape: BoxShape.circle,
            ),
            child: Consumer<ActivityProvider>(
              builder: (context, provider, child) {
                final actualPercentages =
                    provider.actualPercentagesForPieChart();
                final totalSum = actualPercentages.values.fold<double>(
                    0, (previousValue, element) => previousValue + element);

                return isInternetConnected
                    ? totalSum != 0.0
                        ? PieChart(
                            dataMap: actualPercentages,
                            animationDuration:
                                const Duration(milliseconds: 800),
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.2,
                            initialAngleInDegree: 0,
                            colorList: colorsList,
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: false,
                            ),
                            legendOptions: const LegendOptions(
                              showLegends: false,
                            ),
                          )
                        : staticPieChartForMobile(context)
                    : staticPieChartForMobile(context);
              },
            ),
          ),
        if (isTablet(context) && widget.isFromHome)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10.0,
                    spreadRadius: 5.0)
              ],
              shape: BoxShape.circle,
            ),
            child: PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartRadius: MediaQuery.of(context).size.width / 3.0,
              initialAngleInDegree: 0,
              colorList: colorsList,
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: false,
              ),
              legendOptions: const LegendOptions(
                showLegends: false,
              ),
            ),
          ),
        if (isTablet(context) && widget.isFromHome == false)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10.0,
                    spreadRadius: 5.0),
              ],
              shape: BoxShape.circle,
            ),
            child: Consumer<ActivityProvider>(
              builder: (context, provider, child) {
                final actualPercentages =
                    provider.actualPercentagesForPieChart();
                final totalSum = actualPercentages.values.fold<double>(
                    0, (previousValue, element) => previousValue + element);

                return isInternetConnected
                    ? totalSum != 0.0
                        ? PieChart(
                            dataMap: actualPercentages,
                            animationDuration:
                                const Duration(milliseconds: 800),
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.0,
                            initialAngleInDegree: 0,
                            colorList: colorsList,
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: false,
                            ),
                            legendOptions: const LegendOptions(
                              showLegends: false,
                            ),
                          )
                        : staticPieChartForTablet(context)
                    : staticPieChartForTablet(context);
              },
            ),
          ),
      ],
    );
  }

  //Creating a function that will return a static PieChart for mobile
  Widget staticPieChartForMobile(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          dataMap: const {'Activty': 12},
          animationDuration: const Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          initialAngleInDegree: 0,
          colorList: [Colors.grey.shade200],
          baseChartColor: Colors.grey.shade200,
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: false,
          ),
          legendOptions: const LegendOptions(
            showLegends: false,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: Text(
              isInternetConnected ? 'No Activities' : 'No Internet',
              style: GoogleFonts.poppins(
                color: const Color.fromRGBO(46, 58, 89, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Creating a function that will return a static PieChart for tablet
  Widget staticPieChartForTablet(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          dataMap: const {'Activty': 100},
          animationDuration: const Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width / 3.0,
          initialAngleInDegree: 0,
          colorList: [Colors.grey.shade200],
          baseChartColor: Colors.grey.shade200,
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: false,
          ),
          legendOptions: const LegendOptions(
            showLegends: false,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: Text(
              isInternetConnected ? 'No Activities' : 'No Internet',
              style: GoogleFonts.poppins(
                color: const Color.fromRGBO(46, 58, 89, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


