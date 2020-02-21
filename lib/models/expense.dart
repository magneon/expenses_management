class Expense {
  int _expenseId;
  String _expenseName;
  String _expenseDescription;
  String _expenseType;
  String _expenseDate;
  double _expenseValue;

  int get expenseId => this._expenseId;

  set expenseId(int expenseId) => this._expenseId = expenseId;

  String get expenseName => this._expenseName;

  set expenseName(String expenseName) => this._expenseName = expenseName;

  String get expenseDescription => this._expenseDescription;

  set expenseDescription(String expenseDescription) => this._expenseDescription = expenseDescription;

  String get expenseType => this._expenseType;

  set expenseType(String expenseType) => this._expenseType = expenseType;

  String get expenseDate => this._expenseDate;

  set expenseDate(String expenseDate) => this._expenseDate = expenseDate;

  double get expenseValue => this._expenseValue;

  set expenseValue(double expenseValue) => this._expenseValue = expenseValue;

  Expense();

  Expense.fromMap(Map map) {
    this.expenseId = map["id"];
    this.expenseName = map["name"];
    this.expenseDescription = map["description"];
    this.expenseType = map["type"];
    this.expenseDate = map["date"];
    this.expenseValue = map["value"];
  }

  Map toJson() {
    Map map = {
      "name": expenseName,
      "description": expenseDescription,
      "value": expenseValue.toString(),
      "date": expenseDate,
      "type": expenseType
    };

    return map;
  }
}