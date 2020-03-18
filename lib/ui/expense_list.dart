import 'package:expenses_management/constants.dart';
import 'package:expenses_management/widgets/app_card.dart';
import 'package:expenses_management/widgets/common_text.dart';
import 'package:expenses_management/widgets/debug/layout_debug.dart';
import 'package:expenses_management/widgets/destac_text.dart';
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

  bool _showEntries = true;
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[            
        Container(
          color: ColorUtil.backgroundColor(),
          width: width(context),
          height: height(context),
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.arrow_left, color: ColorUtil.backgroundTextColor()),
                    DestacText("Fevereiro/2020", size: 18,),
                    Icon(Icons.arrow_right, color: ColorUtil.backgroundTextColor())
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DestacText("Saldo: ", size: 18,),
                    AnimatedOpacity(
                      opacity: _showBalance ? 1.0 : 0.0,
                      duration: Duration(
                        milliseconds: 200
                      ),
                      child: CommonText("R\$ 1.999.999,99", size: 18,),
                    ),
                    /*
                    _showBalance ? 
                      CommonText("R\$ 1.999.999,99", size: 18,) :                      
                      Container(
                        height: 20,
                        width: 130,
                        color: ColorUtil.backgroundTextColor(),
                      ),
                    */
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: GestureDetector(
                        child: _showBalance ? 
                          Icon(Icons.visibility, color: ColorUtil.backgroundTextColor()) :
                          Icon(Icons.visibility_off, color: ColorUtil.backgroundTextColor()),
                        onTap: () {
                          setState(() {
                            if (_showBalance) {
                              _showBalance = false;
                            } else {
                              _showBalance = true;
                            }
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          padding: EdgeInsets.only(bottom: height(context) * .75),
          margin: EdgeInsets.all(0),
        ),
        AppCard(
          color: ColorUtil.operationsCardColor(),
          width: width(context),
          height: height(context) * .8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _createOperationButton(Icons.add, ColorUtil.revenueColor(), Alignment.topLeft, _newRevenue),
              _createOperationButton(Icons.remove, ColorUtil.expenseColor(), Alignment.topRight, _newExpense),
            ],
          )
        ),
        AnimatedPositioned(
          curve: Curves.linearToEaseOut,
          top: _showEntries ? height(context) * .33 : height(context) * 1,
          child: AppCard(
            color: ColorUtil.entriesCardColor(),
            width: width(context),
            height: height(context),
            child: Column(
              children: <Widget>[
                _filters(),
                _entries()
              ],
            ),
          ), 
          duration: Duration(
            seconds: 1
          ),
        )
      ],
    );
  }

  _createOperationButton(IconData icon, Color iconColor, Alignment alignment, Function function) {
    return Expanded(
      child: Container(
        alignment: alignment,
        padding: EdgeInsets.all(20),
        child: FloatingActionButton(
          child: Icon(icon, color: iconColor, size: 30),
          backgroundColor: ColorUtil.entriesCardColor(),
          onPressed: function
        ),
      ),
    );
  }

  _newRevenue() {
    setState(() {
      _showEntries = false;
    });
  }

  _newExpense() {
    setState(() {
      _showEntries = true;
    });
  }

  _filters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _createFilterOption("Entrada", ColorUtil.filterOptionRevenue()),
        _createFilterOption("Todos", ColorUtil.filterOptionAll()),
        _createFilterOption("Saída", ColorUtil.filterOptionExpense()),
      ],
    );
  }

  _createFilterOption(String label, Color color) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GestureDetector(
        child: DestacText(label, color: color, size: 20),
        onTap: () {          
          print("$label pressionado");
        },
      )
    );
  }

  _entries() {
    return SingleChildScrollView(
      child: Container(
        height: height(context) * .567,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
          scrollDirection: Axis.vertical,
          itemCount: 10,
          itemBuilder: (context, index) {
            return CommonText("Item $index", size: 20, color: ColorUtil.backgroundColor(),);
          }
        ),
      )
    );
  }
}