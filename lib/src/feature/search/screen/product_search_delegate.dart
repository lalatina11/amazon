// lib/feature/search/product_search_delegate.dart
import 'package:amazon/src/feature/search/widget/highlighted_text_widget.dart';
import 'package:amazon/src/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductSearchDelegate extends SearchDelegate<ProductModel?> {
  final List<ProductModel> products;

  ProductSearchDelegate({required this.products});

  // ── What shows in the search bar placeholder
  @override
  String get searchFieldLabel => 'Search products, brands...';

  @override
  TextStyle get searchFieldStyle =>
      const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E));

  // ── Right side actions (clear button)
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1A1A2E)),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  // ── Left side (back button)
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
      onPressed: () => close(context, null),
    );
  }

  // ── Shown while typing — suggestions / recent searches
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildEmptyState();
    }

    final suggestions = _filterProducts(query);
    return _buildResultList(suggestions, isSuggestion: true);
  }

  // ── Shown after pressing search/enter
  @override
  Widget buildResults(BuildContext context) {
    final results = _filterProducts(query);

    if (results.isEmpty) {
      return _buildNotFound();
    }

    return _buildResultList(results, isSuggestion: false);
  }

  // ── Helpers ──────────────────────────────────────────────────

  List<ProductModel> _filterProducts(String query) {
    final q = query.toLowerCase().trim();
    return products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.seller.name.toLowerCase().contains(q);
    }).toList();
  }

  Widget _buildResultList(
    List<ProductModel> items, {
    required bool isSuggestion,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final product = items[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.image,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 52,
                height: 52,
                color: Colors.grey[100],
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          title: HighlightedTextWidget(text: product.name, query: query),
          subtitle: Text(
            _formatPrice(product.price),
            style: const TextStyle(
              color: Color(0xFFFF6B35),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          trailing: isSuggestion
              ? Icon(Icons.north_west, size: 16, color: Colors.grey[400])
              : null,
          onTap: () {
            // If suggestion — fill the query with product name
            if (isSuggestion) {
              query = product.name;
              showResults(context);
            } else {
              // Navigate to product detail and close search
              close(context, product);
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Search for products',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find shoes, bags, hats and more',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different keyword',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  String _formatPrice(String price) {
    final value = double.tryParse(price) ?? 0;
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(2)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(2)}';
  }
}
