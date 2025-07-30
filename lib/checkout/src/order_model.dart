import 'package:cloud_firestore/cloud_firestore.dart';
class OrderModel {
  final String id;
  final String description;
  final List<Map<String, dynamic>> products;
  final String status;
  final Map<String, dynamic>? customer;
  final String? paytabsRef;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.description,
    required this.products,
    required this.status,
    this.customer,
    this.paytabsRef,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'description': description,
    'products': products,
    'status': status,
    'customer': customer,
    'paytabsRef': paytabsRef,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      description: map['description'],
      products: List<Map<String, dynamic>>.from(map['products']),
      status: map['status'],
      customer: Map<String, dynamic>.from(map['customer'] ?? {}),
      paytabsRef: map['paytabsRef'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
