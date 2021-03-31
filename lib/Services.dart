import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'Model/customer.dart';

class Services {
  static const ROOT = 'http://192.168.0.105/CustomersDB/customer_actions.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_REC';
  static const _UPDATE_EMP_ACTION = 'UPDATE_REC';
  static const _DELETE_EMP_ACTION = 'DELETE_REC';

  /// Parse Response
  static List<Customer> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
  }

  /// Create the table Customers on Database
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  /// Get all [Customer]s
  static Future<List<Customer>> getCustomers() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getCustomers Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Customer> list = parseResponse(response.body);
        return list;
      } else {
        return List<Customer>();
      }
    } catch (e) {
      return List<Customer>(); // return an empty list on exception/error
    }
  }

  /// Add a [Customer]
  static Future<String> addCustomer(String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('addCustomer Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  /// Update a [Customer]
  static Future<String> updateCustomer(
      String empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('updateCustomer Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  /// Delete a [Customer]
  static Future<String> deleteCustomer(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['id'] = empId;
      final response = await http.post(ROOT, body: map);
      print('deleteCustomer Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
