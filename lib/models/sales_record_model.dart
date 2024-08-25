class SalesRecord {
  final int id;
  final int userId;
  final int customerId;
  final String date;
  final double totalAmount;

  SalesRecord({
    required this.id,
    required this.userId,
    required this.customerId,
    required this.date,
    required this.totalAmount,
  });

  factory SalesRecord.fromJson(Map<String, dynamic> json) {
    return SalesRecord(
      id: json['id'],
      userId: json['user_id'],
      customerId: json['customer_id'],
      date: json['date'],
      totalAmount: json['total_amount'],
    );
  }
}
