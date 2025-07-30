import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'checkout/views/create_order_page.dart';
import 'checkout/bloc/checkout_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout/src/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 🚨 Provide your CheckoutBloc here
      create: (_) => CheckoutBloc(firestoreService: FirestoreService(),
                                profileId: 119514),
      child: MaterialApp(
        title: 'PayTabs Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: CreateOrderPage(),
      ),
    );
  }
}
