// lib/src/models/payment_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;           // Firestore doc ID
  final String orderId;      // Reference back to the Order
  final String tranRef;      // Payment gateway transaction reference
  final double amount;       // Amount actually charged
  final String currency;     // Currency code (e.g. "EGP", "SAR")
  final String status;       // Gateway status code (e.g. "D", "A")
  final String responseCode; // Numeric response code
  final String responseMessage;
  final String method;       // e.g. "Visa", "Mada"
  final DateTime transactionTime;
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.tranRef,
    required this.amount,
    required this.currency,
    required this.status,
    required this.responseCode,
    required this.responseMessage,
    required this.method,
    required this.transactionTime,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'orderId': orderId,
        'tran_ref': tranRef,
        'amount': amount,
        'currency': currency,
        'status': status,
        'response_code': responseCode,
        'response_message': responseMessage,
        'method': method,
        'transaction_time': transactionTime.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  factory PaymentModel.fromMap(String id, Map<String, dynamic> m) {
    return PaymentModel(
      id: id,
      orderId: m['orderId'] as String,
      tranRef: m['tran_ref'] as String,
      amount: (m['amount'] as num).toDouble(),
      currency: m['currency'] as String,
      status: m['status'] as String,
      responseCode: m['response_code'] as String,
      responseMessage: m['response_message'] as String,
      method: m['method'] as String,
      transactionTime: DateTime.parse(m['transaction_time'] as String),
      createdAt: (m['createdAt'] as Timestamp).toDate(),
    );
  }
}
