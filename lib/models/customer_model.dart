class Customer {
  final int id;
  late final String name;
  late final int phone;
  late final String address;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: int.parse(json['phone'].toString()),
      address: json['address'],
    );
  }
}
