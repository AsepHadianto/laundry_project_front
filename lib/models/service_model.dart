class Service {
  final int id;
  late final String namaLayanan;
  late final double harga;
  late final int categoryId;

  Service({
    required this.id,
    required this.namaLayanan,
    required this.harga,
    required this.categoryId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      namaLayanan: json['name'],
      harga: double.parse(json['price'].toString()),
      categoryId: json['category_id'],
    );
  }
}
