// ✅ lib/views/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/checkout/bloc/checkout_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
  if (state is OrderFailure) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
  } else if (state is PaymentInitiated) {
    final url = state.response['redirect_url'];
    if (url != null) launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
},
      builder: (context, state) {
        final items = state is CartUpdated ? state.items : <Map<String, dynamic>>[];
        final total = state is CartUpdated ? state.total : 0.0;
        final isSubmitting = state is OrderSubmitting;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            title: const Text('Cart',
                style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: items.isEmpty
                ? const _EmptyCartView()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated \$${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('${items.length} items',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: items.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (ctx, i) {
                            if (i < items.length) return _CartItemTile(item: items[i]);
                            return _SummarySection(total: total);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBDF994),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isSubmitting ? null : () {
                context.read<CheckoutBloc>().add(SubmitAndPay());
              },
              child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Go to Payment',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Estimated \$0.00',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('0 items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/empty_cart.png', height: 150),
                const SizedBox(height: 24),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill up your cart with fresh groceries and everyday essentials.\nStart shopping now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text('View trending items',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            item['image'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Icon(Icons.edit, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Add Instructions',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text('${item['qty']}', style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${(item['price'] as double).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
            if (item['originalPrice'] != null)
              Text(
                '\$${(item['originalPrice'] as double).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  final double total;
  const _SummarySection({required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Estimated Total: \$${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),
          ),
        ),
      ],
    );
  }
}
