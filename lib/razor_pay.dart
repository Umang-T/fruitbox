// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentPage extends StatefulWidget {
  final double totalAmount;

  const RazorpayPaymentPage({Key? key, required this.totalAmount})
      : super(key: key);

  @override
  RazorpayPaymentPageState createState() => RazorpayPaymentPageState();
}

class RazorpayPaymentPageState extends State<RazorpayPaymentPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();
  bool _razorpayInitialized = false;


  @override
  void initState() {
    super.initState();
    initializeRazorpay();
  }

  void initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpayInitialized = true;
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }



  void openCheckout(amount) async {
    if (!_razorpayInitialized) {
      initializeRazorpay();
    }

    amount = amount * 100;
    var options = {
      'key': 'razorpayKey',
      'amount': amount,
      'name': 'fruitbox',
      'description': 'Payment for your order',
      'prefill': {
        'contact': '7894561230',
        'email': 'fruitboxsgsits@gmail.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error during Razorpay checkout: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment successful ${response.paymentId}");
    print("Payment Successful: ${response.paymentId}");
    // Navigate to success screen or perform further actions
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment failure ${response.message}");
    print("Payment Error: ${response.message}");
    // Show error message to the user or perform further actions
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "external wallet ${response.walletName}");
    print("External Wallet: ${response.walletName}");
    // Perform necessary actions if payment is via an external wallet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            openCheckout(widget.totalAmount);
          },
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
