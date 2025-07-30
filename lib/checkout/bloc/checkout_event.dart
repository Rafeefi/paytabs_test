part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override List<Object?> get props => [];
}

class AddItem extends CheckoutEvent {
  final Map<String, dynamic> item;
  const AddItem(this.item);
  @override List<Object?> get props => [item];
}

class RemoveItem extends CheckoutEvent {
  final Map<String, dynamic> item;
  const RemoveItem(this.item);
  @override List<Object?> get props => [item];
}

class SubmitAndPay extends CheckoutEvent {}
