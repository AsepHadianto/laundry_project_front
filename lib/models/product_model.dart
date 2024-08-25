class Product {
  final int id;
  late final String namaProduk;
  late final int stok;
  late final double harga;
  late final int categoryId;

  Product({
    required this.id,
    required this.namaProduk,
    required this.stok,
    required this.harga,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      namaProduk: json['name'],
      stok: json['stock'],
      harga: double.parse(json['price'].toString()),
      categoryId: json['category_id'],
    );
  }
}
