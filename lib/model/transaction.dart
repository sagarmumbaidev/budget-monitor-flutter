class MoneyTransaction {
  int id;
  double amount;
  String description;
  String transactionType;
  int categoryId;
  String category;
  String transactionDate;

  MoneyTransaction(
    this.id,
    this.amount,
    this.description,
    this.transactionType,
    this.categoryId,
    this.transactionDate,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'amount': amount,
      'description': description,
      'transaction_type': transactionType,
      'category_id': categoryId,
      'transaction_date': transactionDate,
    };
    return map;
  }

  MoneyTransaction.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    amount = map['amount'];
    description = map['description'];
    transactionType = map['transaction_type'];
    category = map['name'];
    transactionDate = map['transaction_date'];
  }
}
