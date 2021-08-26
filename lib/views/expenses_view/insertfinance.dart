import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:expense_tracker/utils/apploader.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class User {
  const User(this.name);
  final String name;
}

class InsertFinance extends StatelessWidget {

  InsertFinance({
    @required this.incomeTab,
    this.incomeKey,
    this.expenseKey,
    this.incomeAmountController,
    this.incomeDescriptionController,
    this.expenseAmountController,
    this.expenseDescriptionController,
    this.incomeDateController,
    this.incomeTimeController,
    this.setIncomeDateValidator,
    this.setIncomeTimeValidator,
    this.setExpenseDateValidator,
    this.setExpenseTimeValidator,
    this.expenseDateController,
    this.expenseTimeController,
    this.incomeSavingList,
    this.expenseSavingList,
    this.incomeCategoryList,
    this.expenseCategoryList,
    this.onShowIncomeDatePicker,
    this.onShowIncomeTimePicker,
    this.onShowExpenseDatePicker,
    this.onShowExpenseTimePicker,
    this.incomeOnPressedSubmit,
    this.expenseOnPressedSubmit,
    this.onChangedIncomeSavingType,
    this.onChangedExpenseSavingType,
    this.onChangedIncomeCategory,
    this.onChangedExpenseCategory
  });

  final bool incomeTab;
  bool showLoad = false;

  final GlobalKey<FormState> incomeKey;
  final GlobalKey<FormState> expenseKey;

  final GlobalKey<ScaffoldState> dialogueKey = new GlobalKey<ScaffoldState>();

  final TextEditingController incomeAmountController;
  final TextEditingController incomeDateController;
  final TextEditingController incomeTimeController;
  final TextEditingController incomeDescriptionController;

  final TextEditingController expenseAmountController;
  final TextEditingController expenseDateController;
  final TextEditingController expenseTimeController;
  final TextEditingController expenseDescriptionController;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  final List<String> incomeSavingList;
  final List<String> expenseSavingList;

  final List<String> incomeCategoryList;
  final List<String> expenseCategoryList;

  final Future<DateTime> Function(BuildContext context, DateTime currentValue) onShowIncomeDatePicker;
  final Future<DateTime> Function(BuildContext context, DateTime currentValue) onShowIncomeTimePicker;
  final Future<DateTime> Function(BuildContext context, DateTime currentValue) onShowExpenseDatePicker;
  final Future<DateTime> Function(BuildContext context, DateTime currentValue) onShowExpenseTimePicker;

  final FormFieldValidator<DateTime> setIncomeDateValidator;
  final FormFieldValidator<DateTime> setIncomeTimeValidator;
  final FormFieldValidator<DateTime> setExpenseDateValidator;
  final FormFieldValidator<DateTime> setExpenseTimeValidator;

  final VoidCallback incomeOnPressedSubmit;
  final VoidCallback expenseOnPressedSubmit;

  final ValueChanged onChangedIncomeSavingType;
  final ValueChanged onChangedExpenseSavingType;

  final ValueChanged onChangedIncomeCategory;
  final ValueChanged onChangedExpenseCategory;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: DefaultTabController(
        initialIndex: incomeTab ? 0 : 1,
        length: 2,
        child: Scaffold(
          key: dialogueKey,
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              // indicator: BoxDecoration(
              //   color: Colors.white,
              // ),
              tabs: [
                Tab(
                  text: "Add Income",
                  icon: Container(
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.add_circle,
                      size: 30,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
                Tab(
                  text: "Add Expense",
                  icon: Container(
                    width: 25,
                    height: 25,
                    child: SvgPicture.asset("assets/images/minus_circle.svg",
                      color: Colors.orange[800],
                    ),
                  ),
                )
              ],
            ),
            title: Text("Finance"),
            automaticallyImplyLeading: false,
          ),
          body: showLoad ? AppLoader() :
          TabBarView(
            children: [incomeWidget(context), expenseWidget(context)],
          ),
        ),
      ),
    );
  }

  Widget incomeWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[300],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: incomeKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 30,
                        color: Colors.orange[800],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        validator: (value) {
                          if(value == "")
                              return "Please enter amount!";
                          else if(int.parse(value) == 0)
                            return "Income amount cannot be zero!";
                          else
                            return null;
                        },
                        controller: incomeAmountController,
                        decoration: InputDecoration(
                          // hintText: "Enter Income Value",
                          labelText: "Enter amount",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_outlined),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width - 64,
                      child: DropdownButtonFormField(
                        // value: savingType,
                        itemHeight: 60,
                        validator: (value) => value == null
                            ? "Please select saving type" : null,
                        isExpanded: true,
                        items: incomeSavingList.map((String item) =>
                            DropdownMenuItem(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(capitalize(item),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Divider(color: Colors.grey, height: 4,),
                                  ],
                                ),
                                value: item)).toList(),
                        hint: new Text("Select saving type"),
                        onChanged: onChangedIncomeSavingType,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width - 64,
                      child: DropdownButtonFormField(
                        itemHeight: 60,
                        isExpanded: true,
                        items: incomeCategoryList.map((String item) =>
                            DropdownMenuItem(
                                child: Column(
                                  children: [
                                    Text(capitalize(item),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Divider(color: Colors.grey, height: 4,),
                                  ],
                                ),
                                value: item)).toList(),
                        hint: new Text("Select Income Category"),
                        onChanged: onChangedIncomeCategory,
                        validator: (value) => value == null
                            ? "Please Select Income Category" : null,
                        // value: category,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  validator: MaxLengthValidator(200,
                      errorText: "Maximum character length should be 200 only!"),
                  controller: incomeDescriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a brief description",
                    labelText: "Description",
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.50,
                    child: DateTimeField(
                      format: DateFormat("yyyy-MM-dd"),
                      controller: incomeDateController,
                      decoration: InputDecoration(
                          labelText: 'Choose date',
                          border: OutlineInputBorder()),
                      onShowPicker: onShowIncomeDatePicker,
                      validator: setIncomeDateValidator,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.50,
                    child: DateTimeField(
                        format: DateFormat("hh:mm"),
                        controller: incomeTimeController,
                        decoration: InputDecoration(
                            labelText: 'Choose time',
                            border: OutlineInputBorder()),
                        onShowPicker: onShowIncomeTimePicker,
                        validator: setIncomeTimeValidator,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child: MaterialButton(
                  onPressed: incomeOnPressedSubmit,
                  minWidth: 300.0,
                  height: 40.0,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expenseWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[300],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: expenseKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/minus_circle_outline.svg",
                          width: 25,
                          height: 25,
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        validator: (value) {
                          if(value == "")
                            return "Please enter amount!";
                          else if(int.parse(value) == 0)
                            return "Expense amount cannot be zero!";
                          else
                            return null;
                        },
                        controller: expenseAmountController,
                        decoration: InputDecoration(
                          hintText: "Enter Expense Value",
                          labelText: "Value",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.reduce_capacity),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width - 64,
                      child: DropdownButtonFormField(
                        itemHeight: 60,
                        // value: savingType,
                        validator: (value) => value == null
                            ? "Please select expense type" : null,
                        isExpanded: true,
                        items: expenseSavingList.map((String item) =>
                            DropdownMenuItem(
                              child: Column(
                                children: [
                                  Text(capitalize(item),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Divider(color: Colors.grey, height: 4,),
                                ],
                              ),
                              value: item,
                            )).toList(),
                        hint: new Text("Select expense type"),
                        onChanged: onChangedExpenseSavingType,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width - 64,
                      child: DropdownButtonFormField(
                        itemHeight: 60,
                        isExpanded: true,
                        items: expenseCategoryList.map((String item) =>
                            DropdownMenuItem(
                                child: Column(
                                  children: [
                                    Text(capitalize(item),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Divider(color: Colors.grey, height: 4,),
                                  ],
                                ),
                                value: item)).toList(),
                        hint: new Text("Select Expense category"),
                        onChanged: onChangedExpenseCategory,
                        validator: (value) => value == null
                            ? "Please Select Expense Category" : null,
                        // value: category,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  validator: MaxLengthValidator(200,
                      errorText: "Maximum character length should be 200 only!"),
                  controller: expenseDescriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a brief description",
                    labelText: "Description",
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.50,
                    child: DateTimeField(
                      format: DateFormat("yyyy-MM-dd"),
                      controller: expenseDateController,
                      decoration: InputDecoration(
                          labelText: 'Choose date',
                          border: OutlineInputBorder()),
                      onShowPicker: onShowExpenseDatePicker,
                      autovalidate: true,
                      validator: setExpenseDateValidator,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.50,
                    child: DateTimeField(
                      format: DateFormat("hh:mm"),
                      controller: expenseTimeController,
                      decoration: InputDecoration(
                          labelText: 'Choose time',
                          border: OutlineInputBorder()),
                      onShowPicker: onShowExpenseTimePicker,
                      validator: setExpenseTimeValidator,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child: MaterialButton(
                  onPressed: expenseOnPressedSubmit,
                  minWidth: 300.0,
                  height: 40.0,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }

}