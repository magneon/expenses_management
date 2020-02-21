import 'package:flutter/material.dart';

import 'package:expenses_management/ui/expense_list.dart';
import 'package:expenses_management/utils/color_util.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("pt_BR");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ExpenseList(),
    theme: ThemeData(
      canvasColor: ColorUtil.backgroundColor()
    ),
  ));
}