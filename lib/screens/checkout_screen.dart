import 'package:flutter/material.dart';

import '../state/shop_state.dart';
import 'cart_screen.dart';

enum PaymentMethod { upi, card, cod }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Demo User');
  final _phone = TextEditingController(text: '9876543210');
  final _address = TextEditingController(text: '221B Demo Street, Pune, Maharashtra 411001');
  PaymentMethod _payment = PaymentMethod.cod;
  bool _placing = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(ShopState shop) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _placing = true);
    await Future.delayed(const Duration(milliseconds: 800)); // fake network call
    if (!mounted) return;
    final order = shop.placeOrder('${_name.text}, ${_address.text}');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: order.id)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);

    if (shop.cartItems.isEmpty && !_placing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('Your cart is empty')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deliver to',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null,
                  ),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone number'),
                    validator: (v) => v == null || !RegExp(r'^\d{10}$').hasMatch(v.trim())
                        ? 'Enter a 10-digit phone number'
                        : null,
                  ),
                  TextFormField(
                    controller: _address,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (v) => v == null || v.trim().length < 10 ? 'Enter full address' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              child: RadioGroup<PaymentMethod>(
                groupValue: _payment,
                onChanged: (v) => setState(() => _payment = v!),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Text('Payment (demo only — no real payment)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    RadioListTile(value: PaymentMethod.upi, title: Text('UPI')),
                    RadioListTile(value: PaymentMethod.card, title: Text('Credit / Debit Card')),
                    RadioListTile(value: PaymentMethod.cod, title: Text('Cash on Delivery')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            PriceDetails(shop: shop),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Text(rupees(shop.payable),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFB641B),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                onPressed: _placing ? null : () => _placeOrder(shop),
                child: _placing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Confirm Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 96),
                const SizedBox(height: 16),
                const Text('Order placed successfully!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Order ID: $orderId', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                const Text('Expected delivery in 3–5 days'),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
