class ServiceSalesDetail {
  final int id;
  final int salesRecordId;
  final int serviceId;
  final int quantity;
  final double subtotal;

  ServiceSalesDetail({
    required this.id,
    required this.salesRecordId,
    required this.serviceId,
    required this.quantity,
    required this.subtotal,
  });

  factory ServiceSalesDetail.fromJson(Map<String, dynamic> json) {
    return ServiceSalesDetail(
      id: json['id'],
      salesRecordId: json['sales_record_id'],
      serviceId: json['service_id'],
      quantity: json['quantity'],
      subtotal: json['subtotal'],
    );
  }
}
