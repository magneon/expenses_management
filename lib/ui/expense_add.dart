import 'package:expenses_management/utils/date_util.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:expenses_management/models/expense.dart';
import 'package:expenses_management/utils/color_util.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ExpenseAdd extends StatefulWidget {
  @override
  _ExpenseAddState createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  MoneyMaskedTextController valueMaskController = new MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  MaskedTextController dateMaskController = new MaskedTextController(mask: '00/00/0000');

  Color _defaultColor = ColorUtil.revenueColor();
  int _defaultType = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorUtil.backgroundColor(),
          bottom: TabBar(
            indicatorColor: _defaultColor,
            tabs: <Widget>[
              Tab(child: Text("Receitas", style: TextStyle(color: ColorUtil.revenueColor())), icon: Icon(Icons.add, color: ColorUtil.revenueColor(),)),
              Tab(child: Text("Despesas", style: TextStyle(color: ColorUtil.expenseColor())), icon: Icon(Icons.remove, color: ColorUtil.expenseColor())),
            ],
            onTap: (int value) {
              setState(() {
                _defaultColor = ColorUtil.revenueColor();
                _defaultType = 0;

                if (value == 1) {
                  _defaultType = 1;
                  _defaultColor = ColorUtil.expenseColor();
                }
              });
            },
          )
        ),
        body: TabBarView(
          children: <Widget>[
            createTabView(ColorUtil.revenueColor(), 0),
            createTabView(ColorUtil.expenseColor(), 1),
          ],
        ),
      ),
    );
  }

  Widget createTabView(Color _defaultColor, int tabId) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nome",
                      labelStyle: TextStyle(color: _defaultColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _defaultColor
                        )
                      )
                    ),
                    style: TextStyle(color: _defaultColor),
                    cursorColor: _defaultColor,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      labelStyle: TextStyle(color: _defaultColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _defaultColor
                        )
                      )
                    ),
                    style: TextStyle(color: _defaultColor),
                    cursorColor: _defaultColor
                  ),
                  TextFormField(
                    controller: valueMaskController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: Text("R\$ "),
                      prefixStyle: TextStyle(color: _defaultColor),
                      labelText: "Valor",
                      labelStyle: TextStyle(color: _defaultColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _defaultColor
                        )
                      )
                    ),
                    style: TextStyle(color: _defaultColor),
                    cursorColor: _defaultColor,                      
                  ),
                  TextFormField(
                    controller: dateMaskController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: "Data",
                      labelStyle: TextStyle(color: _defaultColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _defaultColor
                        )
                      )
                    ),
                    style: TextStyle(color: _defaultColor),
                    cursorColor: _defaultColor,                      
                  )
                ],
              )
            ),
          )
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomCenter,
                child: Text("Gravar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                decoration: BoxDecoration(
                  color: _defaultColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              ),
              onTap: () {
                Expense expense = new Expense();
                expense.expenseName = nameController.text;
                expense.expenseDescription = descriptionController.text;
                expense.expenseValue = valueMaskController.numberValue;
                expense.expenseDate = DateUtil.formatDate(dateMaskController.text, "dd/MM/yyyy", "yyyy-MM-dd");
                expense.expenseType = "ENTRADA";

                if (tabId == 1) {
                  expense.expenseType = "SAIDA";
                }

                saveRevenueExpense(expense);
              },
            ),
          )
        )
      ],
    );
  }

  saveRevenueExpense(Expense expense) async {
    String body = json.encode(expense.toJson());
    http.Response response = await http.post(Uri.http("192.168.0.138:8080", "/expense"), body: body, headers: {"Content-Type":"application/json"});

    print(response.statusCode);
  }

}