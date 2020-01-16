import 'package:flutter/material.dart';
import 'package:money_monitor/screens/add_transaction.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
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

  ListView getTransactionListView() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 5.0,
            child: ListTile(
              title: Text('trsansaction title'),
              subtitle: Text('trsansaction subtitle'),
              trailing: Text('12.00'),
              onTap: () {
                debugPrint('list is tapped');
              },
            ),
          );
        });
  }
}
