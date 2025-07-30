import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paytabs_test/checkout/bloc/checkout_bloc.dart';
import 'checkout_page.dart';

class PaymentFailPage extends StatelessWidget {
  const PaymentFailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cancel, color: Colors.red, size: 80),
            SizedBox(height: 16),
            Text('Payment Failed or Cancelled.', style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}