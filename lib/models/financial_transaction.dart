class FinancialTransactions {
  late String id;
  late String title;
  late String description;
  late String movmentType;
  late String value;

  late String currency;
  late String movmentHistory;

  FinancialTransactions();

  FinancialTransactions.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    description = map['info'];
    id = map['id'];
    movmentType = map['movmentType'];
    value = map['value'];
    currency = map['currency'];
    movmentHistory = map['movmentHistory'];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['title'] = title;
    map['info'] = description;
    map['id'] = id;
    map['movmentType'] = movmentType;
    map['value'] = value;
    map['currency'] = currency;
    map['movmentHistory'] = movmentHistory;

    return map;
  }
}
