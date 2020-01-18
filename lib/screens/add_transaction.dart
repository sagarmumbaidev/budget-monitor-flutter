import 'package:flutter/material.dart';
import 'package:money_monitor/model/transaction.dart';
import 'package:money_monitor/util/DBHelper.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

enum TransactionType { expense, income }

class _AddTransactionState extends State<AddTransaction> {
  static var _transactionType = ['Expense', 'Income'];
  String _defaultSelectedTransactionType = _transactionType[0];
  String appBarTitle;
  var dbHelper;

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    //print(dbHelper.getCategories());
    /*transactions = dbHelper.getTransactions();
    print(transactions);*/
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // Expense type section
            ListTile(
              title: DropdownButton(
                  items: _transactionType.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: _defaultSelectedTransactionType,
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      _defaultSelectedTransactionType = valueSelectedByUser;
                    });
                  }),
            ),
            ListTile(
              title: DropdownButton(
                  items: _transactionType.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: _defaultSelectedTransactionType,
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      _defaultSelectedTransactionType = valueSelectedByUser;
                    });
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: amountController,
                style: textStyle,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  //
                },
                decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  //
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Button section
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Add',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          if (amountController.text.isNotEmpty) {
                            MoneyTransaction mt = MoneyTransaction(
                                null,
                                double.parse(amountController.text),
                                descriptionController.text,
                                _defaultSelectedTransactionType);
                            dbHelper.save(mt);
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
