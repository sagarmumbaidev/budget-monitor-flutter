class MoneyTransaction {
  int id;
  double amount;
  String description;
  String transactionType;

  MoneyTransaction(
    this.id,
    this.amount,
    this.description,
    this.transactionType,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'amount': amount,
      'description': description,
      'transaction_type': transactionType,
    };
    return map;
  }

  MoneyTransaction.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    amount = map['amount'];
    description = map['description'];
    transactionType = map['transaction_type'];
  }
}
