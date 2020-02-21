import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:developer';

import 'package:expenses_management/models/expense.dart';
import 'package:expenses_management/utils/color_util.dart';
import 'package:expenses_management/utils/date_util.dart';
import 'package:intl/intl.dart';

import 'expense_add.dart';

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  GlobalKey _globalKey = new GlobalKey();
  DateFormat _dateFormat;

  double _revenueAmount = 0.0;
  double _expenseAmount = 0.0;
  String defaultItem;

  @override
  void initState() {    
    _dateFormat = DateFormat("MMMM-yyyy", "pt_BR");
    defaultItem = _dateFormat.format(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorUtil.backgroundColor(),
      body: FutureBuilder(        
        future: getExpensesByPeriod(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _revenueAmount = 0.0;
              _expenseAmount = 0.0;

              List<Expense> expenses = snapshot.data;
              
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(                        
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text("Período:", style: TextStyle(fontSize: 18, color: Colors.white),)
                          ),
                          DropdownButton(
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            isDense: true,
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                            underline: DropdownButtonHideUnderline(child: Text("")),                            
                            value: defaultItem,
                            items: createDropdownMenuItemForMonths(),
                            onChanged: (value) {
                              setState(() {
                                defaultItem = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView(
                        shrinkWrap: false,
                        children: createItems(expenses),
                      ),
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Text("Receitas total: ", style: TextStyle(color: ColorUtil.revenueColor(), fontSize: 18),),
                                Text(formatValueToString(_revenueAmount), style: TextStyle(color: ColorUtil.revenueColor(), fontSize: 18),)
                              ],
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Text("Despesas total: ", style: TextStyle(color: ColorUtil.expenseColor(), fontSize: 18),),
                                Text(formatValueToString(_expenseAmount), style: TextStyle(color: ColorUtil.expenseColor(), fontSize: 18),)
                              ],
                            )
                          ),
                          Divider(
                            thickness: 2,
                            endIndent: 20,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Text("Saldo: ", style: TextStyle(color: Colors.white, fontSize: 18),),
                                Text(formatValueToString((_revenueAmount - _expenseAmount)), style: TextStyle(color: Colors.white, fontSize: 18),)
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            break;
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
            break;
          }
        },
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            backgroundColor: ColorUtil.revenueColor(),
            foregroundColor: Colors.black,
            child: Text("+", style: TextStyle(fontSize: 24),),
            onPressed: () async {

              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseAdd()));
              if (result == null) {
                SnackBar snackBar = new SnackBar(
                  backgroundColor: Colors.white,
                  content: Text("Registro salvo!", style: TextStyle(color: Colors.black)),
                );

                Scaffold.of(context).showSnackBar(snackBar);
              }

            },
          );
        },
      ),
    );
  }

  String formatValueToString(double value) {
    NumberFormat numberFormat = NumberFormat("R\$ #,##0.00", "pt_BR");

    return numberFormat.format(value);
  }

  Future<List<Expense>> getExpensesByPeriod(BuildContext context) async {
    List<Expense> expenses = List();
    http.Response response;

    try {
      response = await http.get(Uri.http("192.168.0.138:8080", "/expense/period/${defaultItem.toLowerCase()}"));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        for (var json in json.decode(utf8.decode(response.bodyBytes))) {
          expenses.add(Expense.fromMap(json));
        }
      }
    } on Exception catch (e) {
      log(e.toString());

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Falha de Comunicação", style: TextStyle(color: Colors.white)),
            content: Text("Problema de comunicação com o servidor, tente novamente mais tarde.", style: TextStyle(color: Colors.white),),
            backgroundColor: Color.fromRGBO(255, 255, 255, -1),
            actions: <Widget>[
              RaisedButton(
                color: Color.fromRGBO(255, 255, 255, -1),
                child: Text("OK", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.pop(context);
                }
              ),
            ],
            elevation: 5,            
          );
        }
      );
    }

    return expenses;
  }

  List<Widget> createItems(List<Expense> expenses) {
    List<GestureDetector> gesturesDetectors = List();

    for (Expense expense in expenses) {
      Color cardColor;

      if (expense.expenseType == "SAIDA") {
        _expenseAmount += expense.expenseValue;
        cardColor = ColorUtil.expenseColor();
      } else {
        _revenueAmount += expense.expenseValue;
        cardColor = ColorUtil.revenueColor();
      }

      GestureDetector gestureDetector = GestureDetector(
        child: Card(
          color: cardColor,
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(formatValueToString(expense.expenseValue), style: TextStyle(color: Colors.white, fontSize: 20),)
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(expense.expenseName, style: TextStyle(color: Colors.white, fontSize: 20),)
                      ),
                      Text(DateUtil.formatDate(expense.expenseDate, "yyyy-MM-dd", "dd/MM/yyyy"), style: TextStyle(color: Colors.white, fontSize: 14),),
                    ],
                  )
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseAdd(expenseId: expense.expenseId)));
        },
      );

      gesturesDetectors.add(gestureDetector);
    }

    return gesturesDetectors;
  }

  List<DropdownMenuItem> createDropdownMenuItemForMonths() {
    DateTime now = DateTime.now();
    DateTime past = DateTime.utc(now.year - 1, now.month, 1);

    List<DropdownMenuItem> items = new List();
    for (int i = 0 ; i < 12; i++) {
      past = past.add(Duration(days: 31));
      String date = _dateFormat.format(past);

      DropdownMenuItem month = new DropdownMenuItem(child: Text(date), value: date);
      items.add(month);
    }

    return items;
  }
}