// lib/checkout/bloc/checkout_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../src/order_model.dart';
import '../src/payment_model.dart';
import '../src/firestore_service.dart';
import '../src/paytabs_service.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final FirestoreService _firestoreService;
  final PayTabsService _payTabsService;

  CheckoutBloc({
    required FirestoreService firestoreService,
    required int profileId,
  })  : _firestoreService = firestoreService,
        _payTabsService = PayTabsService(profileId: profileId),
        super(const CartUpdated([], 0.0)) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<SubmitAndPay>(_onSubmitAndPay);
  }

  void _onAddItem(AddItem event, Emitter<CheckoutState> emit) {
    final current = state as CartUpdated;
    final items = List<Map<String, dynamic>>.from(current.items);
    final index = items.indexWhere((i) => i['name'] == event.item['name']);

    if (index >= 0) {
      items[index]['qty'] += 1;
    } else {
      items.add({...event.item, 'qty': 1});
    }

    emit(CartUpdated(items, _calculateTotal(items)));
  }

  void _onRemoveItem(RemoveItem event, Emitter<CheckoutState> emit) {
    final current = state as CartUpdated;
    final items = List<Map<String, dynamic>>.from(current.items);
    final index = items.indexWhere((i) => i['name'] == event.item['name']);

    if (index >= 0) {
      if (items[index]['qty'] > 1) {
        items[index]['qty'] -= 1;
      } else {
        items.removeAt(index);
      }
    }

    emit(CartUpdated(items, _calculateTotal(items)));
  }

  Future<void> _onSubmitAndPay(SubmitAndPay event, Emitter<CheckoutState> emit) async {
    final current = state as CartUpdated;
    emit(OrderSubmitting());

    try {
      final order = OrderModel(
        id: '',
        description: 'Grocery Order',
        products: current.items,
        status: 'created',
        customer: null,
        paytabsRef: null,
        createdAt: DateTime.now(),
      );

      final orderId = await _firestoreService.createOrder(order);

      final description = current.items
          .map((item) => '${item['qty']} x ${item['name']}')
          .join(', ');

      final paytabsResponse = await _payTabsService.createPaymentPage(
        cartId: orderId,
        cartDescription: description,
        cartCurrency: 'SAR',
        cartAmount: current.total,
      );

    final redirectUrl = paytabsResponse['redirect_url'];
    final tranRef = paytabsResponse['tran_ref'];

    // 4. Update order with pending status
    await _firestoreService.updateOrderStatus(orderId, 'pending');

    // 5. Save payment in Firestore
    final payment = PaymentModel(
      id: '', // Firestore will auto-generate
      orderId: orderId,
      tranRef: tranRef,
      amount: current.total,
      currency: 'SAR',
      status: 'initiated',
      responseCode: '000',
      responseMessage: 'Initiated successfully',
      method: paytabsResponse['paymentChannel'] ?? 'unknown',
      transactionTime: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await _firestoreService.createPayment(payment);
      emit(PaymentInitiated(paytabsResponse));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (sum, i) => sum + (i['price'] as double) * (i['qty'] as int));
  }
}
