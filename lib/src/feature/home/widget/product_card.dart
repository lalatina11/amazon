import 'package:amazon/src/feature/single_product/screen/single_product.dart';
import 'package:amazon/src/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isWishlisted = false;

  String _formatPrice(String price) {
    final value = double.tryParse(price) ?? 0;
    if (value >= 1000000) {
      return 'Rp${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'Rp${(value / 1000).toStringAsFixed(1)}K';
    }
    return 'Rp${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(SingleProduct.route(product: widget.product));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      widget.product.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Wishlist button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _isWishlisted = !_isWishlisted),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: _isWishlisted ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Category badge - derived from name
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _extractCategory(widget.product.name),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product name
                    Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),

                    // Seller row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundImage: NetworkImage(
                            widget.product.seller.image,
                          ),
                          onBackgroundImageError: (_, __) {},
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.product.seller.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Price + cart button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatPrice(widget.product.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // add to cart
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A2E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractCategory(String productName) {
    const categories = [
      'Shoes',
      'Bags',
      'Hat',
      'Shirt',
      'Pants',
      'Jacket',
      'Gloves',
    ];
    for (final cat in categories) {
      if (productName.contains(cat)) return cat.toUpperCase();
    }
    return 'New';
  }
}
