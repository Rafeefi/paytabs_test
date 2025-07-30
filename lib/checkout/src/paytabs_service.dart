// lib/src/services/paytabs_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class PayTabsService {
  // Use your region’s domain here
  static const _endpoint = 'https://secure.paytabs.sa/payment/request';  
  final int profileId;
  static const serverKey= 'SZJ9L2R9MM-JLJBZBKWR9-2J6MHKRWN2' ;
  PayTabsService({ required this.profileId });

  /// Initiates a Hosted Payment Page session and returns the decoded JSON.
  Future<Map<String, dynamic>> createPaymentPage({
    required String cartId,
    required String cartDescription,
    required String cartCurrency,
    required double cartAmount,
   // String returnUrl = 'https://example.com/return',
   // String callbackUrl = 'https://example.com/callback',
    Map<String, dynamic>? customerDetails,
    Map<String, dynamic>? shippingDetails,
  }) async {
    final payload = {
      'profile_id': profileId,              // your profile ID :contentReference[oaicite:0]{index=0}
      'tran_type': 'sale',                  // sale/auth/etc :contentReference[oaicite:1]{index=1}
      'tran_class': 'ecom',                 // ecom/recurring/etc :contentReference[oaicite:2]{index=2}
      'cart_id': cartId,                    // your order ID :contentReference[oaicite:3]{index=3}
      'cart_description': cartDescription,  // order description :contentReference[oaicite:4]{index=4}
      'cart_currency': cartCurrency,        // e.g. "SAR" :contentReference[oaicite:5]{index=5}
      'cart_amount': cartAmount,            // decimal amount :contentReference[oaicite:6]{index=6}
     //'return': returnUrl,                  // return-URL after pay
     // 'callback': callbackUrl,              // server-to-server callback
    };

    if (customerDetails != null)   payload['customer_details'] = customerDetails;
    if (shippingDetails != null)   payload['shipping_details'] = shippingDetails;

    final res = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': serverKey,           // server key here 
      },
      body: jsonEncode(payload),
    );
       print('▶️ Status: ${res.statusCode}');
  print('▶️ Body: ${res.body}');
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      print('▶️ PayTabs HPP Response: $body');  // logs full JSON 
      return body;
    } else {
      print('❌ PayTabs HPP Error [${res.statusCode}]: ${res.body}');
      throw Exception('PayTabs HPP failed: ${res.statusCode}');
    }
  }
}
