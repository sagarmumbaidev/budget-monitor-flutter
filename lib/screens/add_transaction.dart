import 'package:flutter/material.dart';
import 'package:money_monitor/model/category.dart';
import 'package:money_monitor/model/transaction.dart';
import 'package:money_monitor/util/DBHelper.dart';

//enum Category { Food, Travel, Other, Market, Bank }

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

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
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: RaisedButton(
                elevation: 0,
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  'Select Category',
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  dbHelper.getCategories().then((val) {
                    for (var item in val) {
                      print(item.name);
                    }
                  });
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Select Category '),
                          children: <Widget>[
                            dbHelper.getCategories().then((val) {
                              for (var item in val) {
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Food'),
                                );
                              }
                            }),
                          ],
                        );
                      });
                },
              ),
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

  /*Future<Departments> _asyncSimpleDialog(BuildContext context) async {
    return await showDialog<Departments>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Departments '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Production);
                },
                child: const Text('Production'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Research);
                },
                child: const Text('Research'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Purchasing);
                },
                child: const Text('Purchasing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Marketing);
                },
                child: const Text('Marketing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Accounting);
                },
                child: const Text('Accounting'),
              )
            ],
          );
        });
  }*/
}

/*
showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: 30, left: 20, right: 20, bottom: 20),
                          width: MediaQuery.of(context).size.width - 400,
                          height: MediaQuery.of(context).size.height - 400,
                          color: Colors.white,
                          child: FutureBuilder<List<Category>>(
                            future: dbHelper.getCategories(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, int position) {
                                        final item = snapshot.data[position];
                                        return Card(
                                          child: ListTile(
                                            title: Text(item.name),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      //child: CircularProgressIndicator(),
                                      child: Text("No category present"),
                                    );
                            },
                          ),
                        );
                      });
* */
