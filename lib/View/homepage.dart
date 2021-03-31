import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webservice_mysql_app/Model/customer.dart';
import 'package:webservice_mysql_app/Utils/debouncer.dart';

import '../Services.dart';

class Homepage extends StatefulWidget {
  final String title = 'MySQL Webservice app';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Customer> _customers;
  List<Customer> _filterCustomers;
  Customer _selectedCustomer;
  bool _isUpdating;

  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  GlobalKey<ScaffoldState> _scaffoldKey;

  final _debouncer = Debouncer(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _customers = [];
    _filterCustomers = [];
    _isUpdating = false;
    _scaffoldKey = GlobalKey();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getCustomers();
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    Services.createTable().then((result) {
      if ('success' == result) {
        // Table is created successfully.
        _showSnackBar(context, result);
      }
    });
  }

  /// Add a [Customer]
  _addCustomer() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      print('First or Last name are empty');
      return;
    }
    Services.addCustomer(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getCustomers(); // Refresh on view
        _clearValues();
      }
    });
  }

  /// Get all [Customer]s
  _getCustomers() {
    Services.getCustomers().then((customers) {
      setState(() {
        _customers = customers;
        _filterCustomers = customers;
      });
    });
  }

  /// Update a [Customer]
  _updateCustomer(Customer customer) {
    setState(() {
      _isUpdating = true;
    });
    Services.updateCustomer(
        customer.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getCustomers(); // Refresh on view
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  /// Delete a Customer
  _deleteCustomer(Customer customer) {
    Services.deleteCustomer(customer.id).then((result) {
      if ('success' == result) {
        _getCustomers(); // Refresh on view
      }
    });
  }

  /// Clean the TextField values
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  /// Show the [Customer]'s values in the TextFields
  _showValues(Customer customer) {
    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
  }

  /// Create a table to show the records
  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('FIRST NAME'),
            ),
            DataColumn(
              label: Text('LAST NAME'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          /// Show the Filtered List
          rows: _filterCustomers
              .map(
                (customer) => DataRow(cells: [
              DataCell(
                Text(customer.id),
                onTap: () {
                  _showValues(customer);
                  _selectedCustomer = customer;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  customer.firstName.toUpperCase(),
                ),
                onTap: () {
                  _showValues(customer);
                  _selectedCustomer = customer;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  customer.lastName.toUpperCase(),
                ),
                onTap: () {
                  _showValues(customer);
                  _selectedCustomer = customer;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteCustomer(customer);
                },
              ))
            ]),
          )
              .toList(),
        ),
      ),
    );
  }

  /// SearchField
  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: 'Filter by First name or Last name',
        ),
        onChanged: (string) {
          _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _filterCustomers = _customers
                  .where((u) => (u.firstName
                  .toLowerCase()
                  .contains(string.toLowerCase()) ||
                  u.lastName.toLowerCase().contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title), 
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getCustomers();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Last Name',
                ),
              ),
            ),

            /// Show Add and Update buttons only when updating an customer
            _isUpdating
                ? Row(
              children: [
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    _updateCustomer(_selectedCustomer);
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                : Container(),
            searchField(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCustomer();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
