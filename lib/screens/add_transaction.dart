import 'package:flutter/material.dart';
import 'package:money_monitor/model/transaction.dart';
import 'package:money_monitor/util/DBHelper.dart';
import 'package:intl/intl.dart';

//enum Category { Food, Travel, Other, Market, Bank }

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  static var _transactionType = ['Expense', 'Income'];
  String _defaultSelectedTransactionType = _transactionType[0];
  String appBarTitle;
  String selectCategoryButton = "Select Category";
  int selectCategoryButtonId;
  String selectDate = "Select Date";
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
        padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: ListView(
          children: <Widget>[
            // Expense type section
            ListTile(
              title: DropdownButton(
                  items: _transactionType.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Center(
                        child: Text(dropDownStringItem),
                      ),
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
                  selectCategoryButton,
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('select category'),
                          content: Container(
                            width: double.maxFinite,
                            height: 300.0,
                            child: FutureBuilder(
                              future: dbHelper.getCategories(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? GridView.builder(
                                        itemCount: snapshot.data.length,
                                        gridDelegate:
                                            new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemBuilder: (_, int position) {
                                          final item = snapshot.data[position];
                                          return SimpleDialogOption(
                                            onPressed: () {
                                              setState(() {
                                                selectCategoryButton =
                                                    item.name;
                                                selectCategoryButtonId =
                                                    item.id;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(height: 30),
                                                Icon(Icons.face),
                                                SizedBox(height: 20),
                                                Text(item.name)
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        //child: CircularProgressIndicator(),
                                        child: Text("No Transaction yet"),
                                      );
                              },
                            ),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('CANCEL'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: RaisedButton(
                  elevation: 0,
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text(
                    selectDate,
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                    ).then((date) {
                      setState(() {
                        selectDate = date.toString();
                      });
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
                                _defaultSelectedTransactionType,
                                selectCategoryButtonId,
                                selectDate);
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
