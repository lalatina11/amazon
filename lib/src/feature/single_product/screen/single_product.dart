import 'package:amazon/src/feature/auth/services/auth_cubit.dart';
import 'package:amazon/src/feature/auth/services/auth_state.dart';
import 'package:amazon/src/feature/cart/screen/cart_screen.dart';
import 'package:amazon/src/feature/cart/services/cart_services.dart';
import 'package:amazon/src/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleProduct extends StatefulWidget {
  final ProductModel product;
  const SingleProduct({super.key, required this.product});
  static MaterialPageRoute route({required ProductModel product}) =>
      MaterialPageRoute(builder: (context) => SingleProduct(product: product));

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  final CartServices cartServices = CartServices();
  int _quantity = 1;
  bool _isWishlisted = false;

  String _formatPrice(String price) {
    final value = double.tryParse(price) ?? 0;
    if (value >= 1000000) return 'Rp${(value / 1000000).toStringAsFixed(2)}M';
    if (value >= 1000) return 'Rp${(value / 1000).toStringAsFixed(1)}K';
    return 'Rp${value.toStringAsFixed(2)}';
  }

  double _totalPrice() {
    final value = double.tryParse(widget.product.price) ?? 0;
    return value * _quantity;
  }

  String _extractCategory(String name) {
    const cats = ['Shoes', 'Bags', 'Hat', 'Shirt', 'Pants', 'Jacket', 'Gloves'];
    for (final c in cats) {
      if (name.contains(c)) return c;
    }
    return 'New';
  }

  void _handleAddToCart({required String token}) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final res = await cartServices.addToCart(
      token: token,
      productId: widget.product.id,
      qty: _quantity,
    );
    debugPrint("res $res");
    if (!res.success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(res.message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text('Berhasil menambahkan produk ke'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    navigator.push(CartScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ─── Hero App Bar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: size.height * 0.45,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      _isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: _isWishlisted
                          ? Colors.red
                          : const Color(0xFF1A1A2E),
                    ),
                    onPressed: () =>
                        setState(() => _isWishlisted = !_isWishlisted),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Color(0xFF1A1A2E),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[100],
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // category badge
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _extractCategory(product.name).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Content ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
              child: Column(
                children: [
                  // Main card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + price row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A2E),
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _formatPrice(product.price),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF6B35),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Star rating (static display)
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < 4 ? Icons.star : Icons.star_half,
                                size: 16,
                                color: Colors.amber[600],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '4.5 (128 reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 20),

                        // Description
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Seller card
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(product.seller.image),
                          backgroundColor: Colors.grey[200],
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sold by',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                product.seller.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              Text(
                                product.seller.address,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF1A1A2E)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Visit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity + delivery info card
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoggedIn) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // Quantity selector
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Jumlah',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        _QtyButton(
                                          icon: Icons.remove,
                                          onTap: () {
                                            if (_quantity > 1) {
                                              setState(() => _quantity--);
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            '$_quantity',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1A1A2E),
                                            ),
                                          ),
                                        ),
                                        _QtyButton(
                                          icon: Icons.add,
                                          onTap: () =>
                                              setState(() => _quantity++),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                              const Divider(
                                height: 1,
                                color: Color(0xFFF0F0F0),
                              ),
                              const SizedBox(height: 16),

                              // Delivery info
                              _InfoRow(
                                icon: Icons.local_shipping_outlined,
                                label: 'Free delivery',
                                value: 'Est. 3–5 days',
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                icon: Icons.verified_outlined,
                                label: 'Authentic product',
                                value: 'Verified seller',
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                icon: Icons.refresh_outlined,
                                label: '30-day returns',
                                value: 'No questions asked',
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ─── Bottom Action Bar ───────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoggedIn) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total ($_quantity item${_quantity > 1 ? 's' : ''})',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      Text(
                        _formatPrice(_totalPrice().toString()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Buttons row
                  Row(
                    children: [
                      // Add to cart
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _handleAddToCart(token: state.token),
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                          ),
                          label: const Text('+ Keranjang'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1A1A2E),
                            side: const BorderSide(color: Color(0xFF1A1A2E)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Checkout
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // navigate to checkout
                          },
                          icon: const Icon(
                            Icons.bolt,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Column(mainAxisSize: MainAxisSize.min);
          },
        ),
      ),
    );
  }
}

// ─── Helper widgets ────────────────────────────────────────────────────────

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1A1A2E)),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFFF6B35)),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}
