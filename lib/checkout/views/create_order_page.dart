// lib/views/create_order_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paytabs_test/checkout/bloc/checkout_bloc.dart';
import 'checkout_page.dart';

class CreateOrderPage extends StatelessWidget {
  CreateOrderPage({super.key});

  final List<Map<String, dynamic>> veggies = [
    {
      'name': 'Bananas',
      'price': 1.32,
      'image': 'assets/images/banana.jpg',
    },
    {
      'name': 'Carrots',
      'price': 0.66,
      'image': 'assets/images/carrot.jpg',
    },
    {
      'name': 'Onions',
      'price': 0.71,
      'image': 'assets/images/onion.jpg',
    },
    { 
      'name': 'Apples',
      'price': 1.50,
      'image': 'assets/images/apple.jpg',
    },
    {
      'name': 'Lemons',
      'price': 1.10,
      'image': 'assets/images/lemon.jpg',
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Fruits & vegetables',
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.tune, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: veggies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.75
          ),
          itemBuilder: (context, i) {
            final item = veggies[i];
            return Material(
              color: Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(item['image'], height: 80, width: double.infinity, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 12),
                    Text(item['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    //Text(item['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${item['price']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Material(
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => context.read<CheckoutBloc>().add(AddItem(item)),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          final count = state is CartUpdated ? state.items.length : 0;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutPage()),
                ),
                backgroundColor: Colors.black,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              if (count > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
