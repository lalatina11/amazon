import 'package:amazon/src/feature/cart/services/cart_services.dart';
import 'package:amazon/src/feature/cart/widget/cart_card.dart';
import 'package:amazon/src/model/cart_model.dart';
import 'package:flutter/material.dart';

class CartList extends StatefulWidget {
  final String token;
  const CartList({super.key, required this.token});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final CartServices cartServices = CartServices();
  bool isLoading = false;
  List<CartModel> carts = [];

  double get _grandTotal => carts.fold(0, (sum, c) => sum + c.totalPrice);

  // int get _totalItems => carts.fold(0, (sum, c) => sum + c.quantity);

  String _formatPrice(double price) {
    if (price >= 1000000) return '\$${(price / 1000000).toStringAsFixed(2)}M';
    if (price >= 1000) return '\$${(price / 1000).toStringAsFixed(1)}K';
    return '\$${price.toStringAsFixed(2)}';
  }

  void fetchCart() async {
    setState(() => isLoading = true);
    try {
      final res = await cartServices.getAllCarts(token: widget.token);
      if (res.success && res.data != null) {
        final result = res.data as List<dynamic>;
        setState(() {
          carts = result.map((e) => CartModel.fromMap(e)).toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _increment(int index) {
    setState(() {
      final c = carts[index];
      final unitPrice = c.totalPrice / c.quantity;
      carts[index] = c.copyWith(
        quantity: c.quantity + 1,
        totalPrice: unitPrice * (c.quantity + 1),
      );
    });
    // TODO: call cartServices.updateCart(...)
  }

  void _decrement(int index) {
    final c = carts[index];
    if (c.quantity <= 1) {
      _delete(index);
      return;
    }
    setState(() {
      final unitPrice = c.totalPrice / c.quantity;
      carts[index] = c.copyWith(
        quantity: c.quantity - 1,
        totalPrice: unitPrice * (c.quantity - 1),
      );
    });
    // TODO: call cartServices.updateCart(...)
  }

  void _delete(int index) {
    setState(() => carts.removeAt(index));
    // TODO: call cartServices.deleteCart(...)
  }

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && carts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!isLoading && carts.isEmpty) {
      return _buildEmptyCart();
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            itemCount: carts.length,
            itemBuilder: (context, index) => CartCard(
              cart: carts[index],
              onIncrement: () => _increment(index),
              onDecrement: () => _decrement(index),
              onDelete: () => _delete(index),
            ),
          ),
        ),

        // Order summary + checkout
        _buildCheckoutBar(),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to start shopping',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A2E),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Browse Products',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Order summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Subtotal',
                  value: _formatPrice(_grandTotal),
                ),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Shipping', value: 'Free'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFE0E0E0)),
                ),
                _SummaryRow(
                  label: 'Total',
                  value: _formatPrice(_grandTotal),
                  isTotal: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: carts.isEmpty
                  ? null
                  : () {
                      // TODO: navigate to checkout
                    },
              icon: const Icon(Icons.bolt, color: Colors.white, size: 20),
              label: Text(
                'Checkout  •  ${_formatPrice(_grandTotal)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                disabledBackgroundColor: Colors.grey[300],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? const Color(0xFF1A1A2E) : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? const Color(0xFFFF6B35) : const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
