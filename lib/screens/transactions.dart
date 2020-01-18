import 'package:flutter/material.dart';
import 'package:money_monitor/model/transaction.dart';
import 'package:money_monitor/screens/add_transaction.dart';
import 'package:money_monitor/util/DBHelper.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  var dbHelper;
  var transactions;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: getTransactionListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTransaction()));
        },
        tooltip: 'Add transaction',
        child: Icon(Icons.monetization_on),
      ),
    );
  }

  getTransactionListView() {
    return FutureBuilder<List<MoneyTransaction>>(
      future: dbHelper.getTransactions(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, int position) {
                  final item = snapshot.data[position];
                  return Card(
                    child: ListTile(
                      title: Text(item.description),
                      subtitle: Text(item.transactionType),
                      trailing: Text(item.transactionType == 'Expense'
                          ? '-' + item.amount.toString()
                          : '+' + item.amount.toString()),
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
