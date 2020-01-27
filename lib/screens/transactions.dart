import 'package:flutter/material.dart';
import 'package:money_monitor/model/transaction.dart';
import 'package:money_monitor/screens/add_transaction.dart';
import 'package:money_monitor/util/DBHelper.dart';
import 'package:intl/intl.dart';

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
      future: dbHelper.getMonthlyDateTransactions(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, int position) {
                  final item = snapshot.data[position];
                  return Card(
                      elevation: 2,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text("${DateFormat.yMMMd().format(
                              DateTime.parse(item.transactionDate),
                            )}"),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FutureBuilder<List<MoneyTransaction>>(
                              future: dbHelper.getTransactions(
                                  item.transactionDate.toString()),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (_, int position) {
                                          final item = snapshot.data[position];
                                          return Card(
                                            elevation: 5,
                                            child: ListTile(
                                              leading: Icon(Icons.fastfood),
                                              title: Text(item.description),
                                              subtitle: Text(
                                                  "${item.transactionType} on ${DateFormat.yMMMd().format(DateTime.parse(item.transactionDate))}"),
                                              trailing: Text(item
                                                          .transactionType ==
                                                      'Expense'
                                                  ? '-' + item.amount.toString()
                                                  : '+' +
                                                      item.amount.toString()),
                                              onTap: () {
                                                print(item.id);
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                          ),
                        ],
                      ));
                },
              )
            : Center(
                child: Text("No Transaction yet"),
              );
      },
    );
  }
}
