import 'package:cloud_firestore/cloud_firestore.dart';
import '/checkout/src/order_model.dart';
import '/checkout/src/payment_model.dart';


class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<String> createOrder(OrderModel order) async {
    final docRef = _db.collection('orders').doc();
    await docRef.set(order.toMap());
    return docRef.id;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> saveCustomerData(String orderId, Map<String, dynamic> customer) async {
    await _db.collection('orders').doc(orderId).update({
      'customer': customer,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<String> createPayment(PaymentModel payment) async {
    final docRef = _db.collection('payments').doc();
    await docRef.set(payment.toMap());
    return docRef.id;
  }
}
