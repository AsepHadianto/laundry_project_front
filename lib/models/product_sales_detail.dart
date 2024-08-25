class ProductSalesDetail {
  final int id;
  final int salesRecordId;
  final int productId;
  final int quantity;
  final double subtotal;

  ProductSalesDetail({
    required this.id,
    required this.salesRecordId,
    required this.productId,
    required this.quantity,
    required this.subtotal,
  });

  factory ProductSalesDetail.fromJson(Map<String, dynamic> json) {
    return ProductSalesDetail(
      id: json['id'],
      salesRecordId: json['sales_record_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      subtotal: json['subtotal'],
    );
  }
}
