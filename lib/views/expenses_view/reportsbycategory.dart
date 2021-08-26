import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:expense_tracker/utils/loadCsvDataScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_html/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:expense_tracker/utils/apploader.dart';
import 'package:expense_tracker/utils/loading_screen.dart';
import 'package:expense_tracker/views/expenses_view/insertfinance.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// import 'package:table_calendar/table_calendar.dart';

class ReportsByCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ReportsByCategoryState();
  }
}

class ReportsByCategoryState extends State<ReportsByCategory> with TickerProviderStateMixin{

  bool showAppLoader = true;
  bool showDialogViewButton = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldTabKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> loadingKey = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _dialogueKey2 = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _incomeKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _expenseKey = new GlobalKey<FormState>();

  ValueNotifier<DateTime> _dateTimeNotifier;

  String selectedMonth;
  String selectedMonthName;
  String selectedYear;
  String selectedDate;
  String selectedDateValue;
  String selectedDay;

  List<String> _incomeCategoryList = [];
  List<int> _incomeCategoryId = [];
  List<String> _expenseCategoryList = [];
  List<int> _expenseCategoryId = [];
  int _incomeCategory, _expenseCategory;

  List<String> _incomeSavingList = [];
  List<int> _incomeSavingId = [];
  List<String> _expenseSavingList = [];
  List<int> _expenseSavingId = [];
  int _incomeSavingType, _expenseSavingType;

  TextEditingController _incomeDateController = TextEditingController();
  TextEditingController _incomeTimeController = TextEditingController();

  TextEditingController _expenseDateController = TextEditingController();
  TextEditingController _expenseTimeController = TextEditingController();

  final dateFormat = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("hh:mm");

  TextEditingController _incomeAmountController = TextEditingController();
  TextEditingController _incomeDescriptionController = TextEditingController();

  TextEditingController _expenseAmountController = TextEditingController();
  TextEditingController _expenseDescriptionController = TextEditingController();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  List<int> dateData = [
    01,
    02,
    03,
    04,
    05,
    06,
    07,
    08,
    09,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
  ];

  List<String> dayData = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
  ];

  List<String> monthData = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
  ];

  List<String> categoryNameData = [
    "Food",
    "Groceries",
    "Rent",
    "Study",
    "Travel",
    "Internet",
    "Health",
    "Education",
    "Movie",
    "Entertainment",
    "Electronics",
    "Relatives",
    "Party",
    "Dance class",
    "Gym",
    "Shopping",
    "Electric current",
    "Farming",
  ];

  List<double> _incomeData = [
    190.00,
    280.00,
    370.00,
    460.00,
    550.00,
    640.00,
    730.00,
    820.00,
    910.00,
    190.00,
    280.00,
    370.00,
    460.00,
    550.00,
    640.00,
    730.00,
    820.00,
    910.00,
  ];

  List<double> _expenseData = [
    100.00,
    0.00,
    300.00,
    0.00,
    500.00,
    0.00,
    700.00,
    0.00,
    900.00,
    0.00,
    200.00,
    0.00,
    400.00,
    0.00,
    600.00,
    0.00,
    800.00,
    0.00,
  ];

  List<Color> colorData = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.pink,
    Colors.deepOrange,
    Colors.purple,
    Colors.indigoAccent,
    Colors.teal,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.pink,
    Colors.deepOrange,
    Colors.purple,
    Colors.indigoAccent,
    Colors.teal
  ];

  List<ChartData> incomeChartData = [];
  List<ChartData> expenseChartData = [];

  List<ChartData> allChartData = [];

  List<DateTimeData> allDateTimeData = [];

  double totalIncomeDaily;
  double totalExpenseDaily;
  double totalBalanceDaily;
  bool isLoadingDaily = true;

  double totalIncomeWeekly;
  double totalExpenseWeekly;
  double totalBalanceWeekly;
  bool isLoadingWeekly = true;

  double totalIncomeMonthly;
  double totalExpenseMonthly;
  double totalBalanceMonthly;
  bool isLoadingMonthly = true;

  double totalIncomeYearly = 0.0;
  double totalExpenseYearly = 0.0;
  double totalBalanceYearly = 0.0;
  bool isLoadingYearly = true;

  @override
  void initState() {
    super.initState();

    _incomeDateController.text = dateFormat.format(DateTime.now());
    _incomeTimeController.text = timeFormat.format(DateTime.now());

    _expenseDateController.text = dateFormat.format(DateTime.now());
    _expenseTimeController.text = timeFormat.format(DateTime.now());

    _dateTimeNotifier = ValueNotifier<DateTime>(DateTime.now());
    setSelectedDate(_dateTimeNotifier.value);
  }

  getYearlyFinanceDetails(String selectedMonth, String selectedYear) async {

    incomeChartData.clear();
    expenseChartData.clear();
    for(int i=0; i<categoryNameData.length; i++) {
      String category = categoryNameData[i];
      bool isIncomeData = _expenseData[i] == 0.00;
      allDateTimeData.add(DateTimeData(dayData[i], dateData[i], monthData[i]));
      if(isIncomeData) {
        double amount = _incomeData[i];
        totalIncomeYearly = totalIncomeYearly + amount;
        setState(() {
          incomeChartData.add(ChartData(category, allDateTimeData[i], isIncomeData, amount, colorData[incomeChartData.length]));
          allChartData.add(ChartData(category, allDateTimeData[i], isIncomeData, amount, colorData[incomeChartData.length]));
        });
      } else {
        double amount = _expenseData[i];
        totalExpenseYearly = totalExpenseYearly + amount;
        setState(() {
          expenseChartData.add(ChartData(category, allDateTimeData[i], isIncomeData, amount, colorData[expenseChartData.length]));
          allChartData.add(ChartData(category, allDateTimeData[i], isIncomeData, amount, colorData[incomeChartData.length]));
        });
      }
    }

    setState(() {
      totalBalanceYearly = totalIncomeYearly - totalExpenseYearly;
    });

    setState(() {
      showAppLoader = false;
    });
  }

  void setSelectedDate(DateTime dateTime) {
    setState(() {
      selectedDate = dateTime.day.toString();
      selectedMonth = dateTime.month.toString();
      selectedYear = dateTime.year.toString();
    });

    switch(dateTime.weekday) {
      case 1: {
        selectedDay = "Mon";
      }
      break;
      case 2: {
        selectedDay = "Tue";
      }
      break;
      case 3: {
        selectedDay = "Wed";
      }
      break;
      case 4: {
        selectedDay = "Thu";
      }
      break;
      case 5: {
        selectedDay = "Fri";
      }
      break;
      case 6: {
        selectedDay = "Sat";
      }
      break;
      case 7: {
        selectedDay = "Sun";
      }
      break;
      default: {
        selectedDay = "Mon";
      }
      break;
    }

    switch(dateTime.month) {
      case 1: {
        setState(() {
          selectedMonthName = "Jan";
        });
      }
      break;
      case 2: {
        setState(() {
          selectedMonthName = "Feb";
        });
      }
      break;
      case 3: {
        setState(() {
          selectedMonthName = "Mar";
        });
      }
      break;
      case 4: {
        setState(() {
          selectedMonthName = "Apr";
        });
      }
      break;
      case 5: {
        setState(() {
          selectedMonthName = "May";
        });
      }
      break;
      case 6: {
        setState(() {
          selectedMonthName = "Jun";
        });
      }
      break;
      case 7: {
        setState(() {
          selectedMonthName = "Jul";
        });
      }
      break;
      case 8: {
        setState(() {
          selectedMonthName = "Aug";
        });
      }
      break;
      case 9: {
        setState(() {
          selectedMonthName = "Sep";
        });
      }
      break;
      case 10: {
        setState(() {
          selectedMonthName = "Oct";
        });
      }
      break;
      case 11: {
        setState(() {
          selectedMonthName = "Nov";
        });
      }
      break;
      case 12: {
        setState(() {
          selectedMonthName = "Dec";
        });
      }
      break;
      default: {
        setState(() {
          selectedMonthName = "Jan";
        });
      }
      break;
    }
    selectedDateValue = selectedDate + " "+ selectedMonthName;
    this.getYearlyFinanceDetails(selectedMonth, selectedYear);
  }

  String getWeekDay(int weekday) {
    switch(weekday) {
      case 1: {
        return "Mon";
      }
      break;
      case 2: {
        return "Tue";
      }
      break;
      case 3: {
        return "Wed";
      }
      break;
      case 4: {
        return "Thu";
      }
      break;
      case 5: {
        return "Fri";
      }
      break;
      case 6: {
        return "Sat";
      }
      break;
      case 7: {
        return "Sun";
      }
      break;
      default: {
        return "Mon";
      }
      break;
    }
  }

  String getMonthValue(int month) {
    switch(month) {
      case 1: {
        return "Jan";
      }
      break;
      case 2: {
        return "Feb";
      }
      break;
      case 3: {
        return "Mar";
      }
      break;
      case 4: {
        return "Apr";
      }
      break;
      case 5: {
        return "May";
      }
      break;
      case 6: {
        return "Jun";
      }
      break;
      case 7: {
        return "Jul";
      }
      break;
      case 8: {
        return "Aug";
      }
      break;
      case 9: {
        return "Sep";
      }
      break;
      case 10: {
        return "Oct";
      }
      break;
      case 11: {
        return "Nov";
      }
      break;
      case 12: {
        return "Dec";
      }
      break;
      default: {
        return "Jan";
      }
      break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('zh'),
        Locale('fr'),
        Locale('es'),
        Locale('de'),
        Locale('ru'),
        Locale('ja'),
        Locale('ar'),
        Locale('fa'),
      ],
      home: showAppLoader ? AppLoader()
          : Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Expense Tracker'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    showMonthPicker(
                      context: context,
                      firstDate: DateTime(2017),
                      lastDate: DateTime(DateTime.now().year + 1, 9),
                      initialDate: _dateTimeNotifier.value ?? DateTime.now(),
                      locale: Locale('en', 'US'),
                    ).then((date) {
                      if (date != null) {
                        _dateTimeNotifier.value = date;
                        setState(() {
                          setSelectedDate(date);
                        });
                      }
                    });

                  },
                  child: Center(
                    child: Text(selectedMonthName+" "+selectedYear,
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
              ),
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(top: 2.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:  DefaultTabController(
              initialIndex: 1,
              length: 3,
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.black,
                appBar: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  indicator: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 5.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    // color: Colors.blue,
                  ),
                  tabs: [
                    Tab(
                      text: "Daily",
                    ),
                    Tab(
                      text: "Monthly",
                    ),
                    Tab(
                      text: "Total",
                    )
                  ],
                ),
                body: TabBarView(
                  children: [
                    dailyWidget(context),
                    monthlyWidget(context),
                    totalWidget(context),
                  ],
                ),
              ),
            ),
          ),

      ),
    );
  }

  Widget dailyWidget(BuildContext context) {

    return showAppLoader ? AppLoader()
        : SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white38,
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0)
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Income",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          Text("₹"+totalIncomeDaily.toString(),
                              style: TextStyle(color: Colors.green, fontSize: 16)),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Expense",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          Text("₹"+totalExpenseDaily.toString(),
                              style: TextStyle(color: Colors.red, fontSize: 16)),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Balance",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          Text("₹"+totalBalanceDaily.toString(),
                              style: TextStyle(color: Colors.blue, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            ListView.builder(
                shrinkWrap: true,
                itemCount: allChartData.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  double totalIncome = 0.0;
                  double totalExpense = 0.0;
                  ChartData perDayData = allChartData[index];
                  for(int i=0; i < allChartData.length; i++) {
                    if(allChartData[i].isIncomeData) {
                      totalIncome = totalIncome + perDayData.amount;
                    } else {
                      totalExpense = totalExpense + perDayData.amount;
                    }
                  }

                  int year = 2021;
                  int month = 12;
                  int day = perDayData.dateTimeData.date;
                  String monthValue = perDayData.dateTimeData.month;
                  String dailyDateValue = day.toString() + " " + monthValue;

                  DateTime date = DateTime(year, month, day);
                  String weekDay = getWeekDay(date.weekday);
                  return Card(
                    color: Colors.black,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      color: Colors.blueGrey[900],
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dailyDateValue,
                                        style: TextStyle(color: Colors.white60, fontSize: 16)),
                                    Text(weekDay,
                                        style: TextStyle(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text("₹"+totalIncome.toString(),
                                  style: TextStyle(color: Colors.green, fontSize: 16)),
                              Spacer(),
                              Text("₹"+totalExpense.toString(),
                                  style: TextStyle(color: Colors.red, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: allChartData.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                ChartData financeDatas = allChartData[index];
                                bool isIncomeData = financeDatas.isIncomeData;
                                String category = financeDatas.categoryName;

                                return Row(
                                  children: [
                                    SvgPicture.asset("assets/images/icon_logo.svg",
                                      // placeholderBuilder: (context) =>
                                      //     CircularProgressIndicator(),
                                      height: 40.0,
                                      width: 40.0,
                                      fit: BoxFit.contain,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 0),
                                      width: MediaQuery.of(context).size.width/1.38,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(category,
                                                  style: TextStyle(color: Colors.white60, fontSize: 16)),
                                              Spacer(),
                                              Text("₹"+financeDatas.amount.toString(),
                                                  style: TextStyle(color: isIncomeData
                                                      ? Colors.green : Colors.red, fontSize: 16)),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                          // Divider(height: 20, thickness: 2, color: Colors.black),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget monthlyWidget(BuildContext context) {

    return showAppLoader ? AppLoader()
        : SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.0,),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryNameData.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String monthName = monthData[index];
                    String monthlyIncome = _incomeData[index].toString();
                    String monthlyExpense = _expenseData[index].toString();
                    return Card(
                      color: Colors.black,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        color: Colors.blueGrey[900],
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white60,
                                      width: 1.0
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0)
                                  ),
                                ),
                                child: Text(monthName,
                                    style: TextStyle(color: Colors.white60, fontSize: 16)),
                              ),
                              // onTap: () {
                              //   setState(() {
                              //     _tabController.animateTo(0,
                              //         duration: Duration(milliseconds: 500), curve: Curves.ease);
                              //   });
                              // },
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 70,
                              child: Text("₹"+monthlyIncome,
                                  style: TextStyle(color: Colors.green, fontSize: 16)),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 70,
                              child: Text("₹"+monthlyExpense,
                                  style: TextStyle(color: Colors.red, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ]),
      ),
    );
  }

  Widget totalWidget(BuildContext context) {

    return showAppLoader ? AppLoader()
        : Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white38,
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0)
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Income",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          Text("₹"+totalIncomeYearly.toString(),
                              style: TextStyle(color: Colors.green, fontSize: 16)),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Expense",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          Text("₹"+totalExpenseYearly.toString(),
                              style: TextStyle(color: Colors.red, fontSize: 16)),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Balance",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          Text("₹"+totalBalanceYearly.toString(),
                              style: TextStyle(color: Colors.blue, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            MaterialButton(
              onPressed: () {
                generateCsv();
              },
              color: Colors.cyanAccent,
              child: Text("Export data to CSV"),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.70,
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Scaffold(
                  key: _scaffoldTabKey,
                  backgroundColor: Colors.black,
                  appBar: TabBar(
                    // controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    indicator: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    tabs: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.35,
                        alignment: Alignment.topCenter,
                        child: Tab(
                          text: "Income",
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2.35,
                        alignment: Alignment.topCenter,
                        child: Tab(
                          text: "Expense",
                        ),
                      ),
                    ],
                  ),
                  body: TabBarView(
                    // controller: _tabController,
                    children: [
                      incomeTab(context),
                      expenseTab(context),
                    ],
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Widget incomeTab(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: incomeChartData.length == 0 ?
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          child: Center(
            child: Text("No data available!",
              style: TextStyle(
                  color: Colors.red
              ),
            ),
          ),
        ) : Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SfCircularChart(
                title: ChartTitle(text: "Income Chart",
                    textStyle: TextStyle(color: Colors.white60, fontSize: 16)
                ),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: incomeChartData,
                    pointColorMapper:(ChartData data,  _) => data.color,
                    xValueMapper: (ChartData data, _) => data.categoryName,
                    yValueMapper: (ChartData data, _) {
                      num percent = (data.amount / totalIncomeYearly) * 100;
                      return percent;
                    },
                    explode: true,
                    dataLabelMapper: (ChartData data, _) {
                      num percent = (data.amount / totalIncomeYearly) * 100;
                      String label = data.categoryName + "\n" + percent.toStringAsFixed(2)+"%";
                      return label;
                    },
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        useSeriesColor: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        connectorLineSettings: ConnectorLineSettings(
                            type: ConnectorType.curve
                        ),
                        showCumulativeValues: true,
                        labelIntersectAction: LabelIntersectAction.none
                    ),
                    enableSmartLabels: true,
                    enableTooltip: true,
                  )
                ]
            ),
            SizedBox(height: 10,),
            ListView.builder(
                shrinkWrap: true,
                itemCount: incomeChartData.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  return Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    color: Colors.blueGrey[900],
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/icon_logo.svg",
                          // placeholderBuilder: (context) =>
                          //     CircularProgressIndicator(),
                          height: 40.0,
                          width: 40.0,
                          fit: BoxFit.contain,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 0),
                          width: MediaQuery.of(context).size.width/1.38,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(incomeChartData[index].categoryName,
                                      style: TextStyle(color: Colors.white60, fontSize: 16)),
                                  Spacer(),
                                  Text("₹"+incomeChartData[index].amount.toString(), style: TextStyle(color: Colors.green, fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget expenseTab(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: expenseChartData.length == 0 ?
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          child: Center(
            child: Text("No data available!",
              style: TextStyle(
                  color: Colors.red
              ),
            ),
          ),
        ) : Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SfCircularChart(
                title: ChartTitle(text: "Expense Chart",
                    textStyle: TextStyle(color: Colors.white60, fontSize: 16)
                ),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                      dataSource: expenseChartData,
                      pointColorMapper:(ChartData data,  _) => data.color,
                      xValueMapper: (ChartData data, _) => data.categoryName,
                      yValueMapper: (ChartData data, _) {
                        num percent = (data.amount / totalExpenseYearly) * 100;
                        return percent;
                      },
                      explode: true,
                      dataLabelMapper: (ChartData data, _) {
                        num percent = (data.amount / totalExpenseYearly) * 100;
                        String label = data.categoryName + "\n" + percent.toStringAsFixed(2)+"%";
                        return label;
                      },
                      dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          connectorLineSettings: ConnectorLineSettings(
                              type: ConnectorType.curve
                          ),
                          showCumulativeValues: true,
                          labelIntersectAction: LabelIntersectAction.none
                      ),
                      enableSmartLabels: true,
                      enableTooltip: true
                  )
                ]
            ),
            SizedBox(height: 10,),
            ListView.builder(
                shrinkWrap: true,
                itemCount: expenseChartData.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  return Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    color: Colors.blueGrey[900],
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/icon_logo.svg",
                          // placeholderBuilder: (context) =>
                          //     CircularProgressIndicator(),
                          height: 40.0,
                          width: 40.0,
                          fit: BoxFit.contain,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 0),
                          width: MediaQuery.of(context).size.width/1.38,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(expenseChartData[index].categoryName,
                                      style: TextStyle(color: Colors.white60, fontSize: 16)),
                                  Spacer(),
                                  Text("₹"+expenseChartData[index].amount.toString(),  style: TextStyle(color: Colors.red, fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  generateCsv() async {

    List<List<dynamic>> listdata = List<List<dynamic>>();
    List<dynamic> stringList = List();

    for(int i=0; i<allChartData.length; i++) {
      stringList.add(allChartData[i].categoryName);
      stringList.add(allChartData[i].amount.toString());
      stringList.add(allChartData[i].dateTimeData.day +" "+ allChartData[i].dateTimeData.date.toString() +" "+ allChartData[i].dateTimeData.month);
      listdata.add(stringList);
      stringList.clear();
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if(statuses[Permission.storage].isGranted) {
      String csvData = const ListToCsvConverter().convert(listdata);
      final String directory = (await getExternalStorageDirectory()).absolute.path;
      final path = "$directory/expense_tracker.csv";
      print(path);
      final File file = File(path);
      await file.writeAsString(csvData);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return LoadCsvDataScreen(path: path);
          },
        ),
      );
    }
  }

}

class ChartData {
  ChartData(this.categoryName, this.dateTimeData, this.isIncomeData, this.amount, [this.color]);

  final String categoryName;
  final DateTimeData dateTimeData;
  final bool isIncomeData;
  final double amount;
  final Color color;
}

class DateTimeData {
  DateTimeData(this.day, this.date, this.month);

  final String day;
  final int date;
  final String month;
}
