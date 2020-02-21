import 'dart:developer';

import 'package:expenses_management/utils/date_util.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:expenses_management/models/expense.dart';
import 'package:expenses_management/utils/color_util.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ExpenseAdd extends StatefulWidget {

  int expenseId;

  ExpenseAdd({this.expenseId});

  @override
  _ExpenseAddState createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
  GlobalKey<FormState> _firstTabGlobalKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _secondTabGlobalKey = new GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  MoneyMaskedTextController _valueMaskController = new MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  MaskedTextController _dateMaskController = new MaskedTextController(mask: '00/00/0000');

  Color _defaultColor = ColorUtil.revenueColor();

  @override
  void initState() {
    super.initState();
  }

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

                if (value == 1) {
                  _defaultColor = ColorUtil.expenseColor();
                }
              });
            },
          )
        ),
        body: TabBarView(
          children: <Widget>[
            createTabView(ColorUtil.revenueColor(), 0, _firstTabGlobalKey),
            createTabView(ColorUtil.expenseColor(), 1, _secondTabGlobalKey),
          ],
        ),
      ),
    );
  }

  Widget createTabView(Color _defaultColor, int tabId, GlobalKey<FormState> key) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: key,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório";
                      }

                      return null;
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        key.currentState.validate();
                      }
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
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
                    cursorColor: _defaultColor,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório";
                      }

                      return null;
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        key.currentState.validate();
                      }
                    },
                  ),
                  TextFormField(
                    controller: _valueMaskController,
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
                    validator: (value) {
                      if (_valueMaskController.numberValue <= 0.0) {
                        return "Campo obrigatório";
                      }

                      return null;
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        key.currentState.validate();
                      }
                    },
                  ),
                  TextFormField(
                    controller: _dateMaskController,
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório";
                      }

                      return null;
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        key.currentState.validate();
                      }
                    },
                  )
                ],
              )
            ),
          )
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(100, 20, 100, 50),
            child: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.bottomCenter,
                    child: Text("Gravar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                    decoration: BoxDecoration(
                      color: _defaultColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                  onTap: () async {
                    var result;

                    if (key.currentState.validate()) {
                      Expense expense = new Expense();
                      expense.expenseName = _nameController.text;
                      expense.expenseDescription = _descriptionController.text;
                      expense.expenseValue = _valueMaskController.numberValue;
                      expense.expenseDate = DateUtil.formatDate(_dateMaskController.text, "dd/MM/yyyy", "yyyy-MM-dd");
                      expense.expenseType = "ENTRADA";

                      if (tabId == 1) {
                        expense.expenseType = "SAIDA";
                      }

                      result = await _saveRevenueExpense(expense);

                      _nameController.clear();
                      _descriptionController.clear();
                      _valueMaskController.updateValue(0.0);
                      _dateMaskController.clear();

                      Navigator.pop(context);

                    }

                    return result;
                  },
                );
              }
            ),
          )
        )
      ],
    );
  }

  Future<bool> _saveRevenueExpense(Expense expense) async {
    String body = json.encode(expense.toJson());
    http.Response response;

    try {
       response = await http.post(Uri.http("192.168.0.138:8080", "/expense"), body: body, headers: {"Content-Type":"application/json"});
       if (response.statusCode == 200 || response.statusCode == 201) {
         return true;
       }

       return false;
    } on Exception catch(e) {
      log(e.toString());

      return false;
    }
  }
}