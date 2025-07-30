part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
  @override List<Object?> get props => [];
}

class CartUpdated extends CheckoutState {
  final List<Map<String, dynamic>> items;
  final double total;
  const CartUpdated(this.items, this.total);

  @override List<Object?> get props => [items, total];
}

class OrderSubmitting extends CheckoutState {}

class PaymentInitiated extends CheckoutState {
  final Map<String, dynamic> response;
  const PaymentInitiated(this.response);
  @override List<Object?> get props => [response];
}

class OrderFailure extends CheckoutState {
  final String error;
  const OrderFailure(this.error);
  @override List<Object?> get props => [error];
}
