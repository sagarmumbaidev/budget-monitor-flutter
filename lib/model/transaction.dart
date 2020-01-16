import 'package:flutter/foundation.dart';

class Transaction {
  final int id;
  final String note;
  final double amount;
  final DateTime date;

  Transaction({
    @required this.id,
    @required this.note,
    @required this.amount,
    @required this.date,
  });
}
