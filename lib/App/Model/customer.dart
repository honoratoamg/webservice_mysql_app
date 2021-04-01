class Customer {
  String id;
  String firstName;
  String lastName;

  Customer({this.id, this.firstName, this.lastName});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }
}
