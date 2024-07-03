import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pay/pay.dart';

class GooglePayScreen extends StatefulWidget {
  const GooglePayScreen({super.key});

  @override
  State<GooglePayScreen> createState() => _GooglePayScreenState();
}

class _GooglePayScreenState extends State<GooglePayScreen> {
  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  void onGooglePayResult(paymentResult) {
    // Handle the result here
    log('Google Pay result: $paymentResult');
  }

  Future<String> loadPaymentConfiguration() async {
    try {
      return await rootBundle.loadString('assets/json/sample_payment_configuration.json');
    } catch (e) {
      log('Error loading payment configuration: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Pay'),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<String>(
            future: loadPaymentConfiguration(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading payment configuration');
              } else if (snapshot.hasData) {
                log('Payment configuration loaded: ${snapshot.data}');
                return GooglePayButton(
                  // paymentConfiguration: PaymentConfiguration.fromJsonString(snapshot.data!),
                  paymentConfiguration: PaymentConfiguration.fromJsonString('{"provider": "google_pay", "data": {}}'),
                  paymentItems: _paymentItems,
                  type: GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onGooglePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Text('No payment configuration found');
              }
            },
          ),
        ),
      ),
    );
  }
}
