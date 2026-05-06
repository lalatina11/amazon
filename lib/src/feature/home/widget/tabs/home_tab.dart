import 'package:amazon/src/constants/global_variables.dart';
import 'package:amazon/src/feature/cart/screen/cart_screen.dart';
import 'package:amazon/src/feature/home/widget/product_list.dart';
import 'package:amazon/src/feature/search/screen/product_search_delegate.dart';
import 'package:amazon/src/feature/single_product/screen/single_product.dart';
import 'package:amazon/src/model/product_model.dart';
import 'package:amazon/src/services/product_services.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ProductServices productServices = ProductServices();
  bool isLoading = false;
  List<ProductModel> products = [];

  void fetchProducts() async {
    try {
      setState(() => isLoading = true);
      final res = await productServices.getAllProducts();
      if (res.success || res.data != null) {
        final data = res.data as List<dynamic>;
        setState(() {
          products = data.map((d) => ProductModel.fromMap(d)).toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _openSearch() async {
    final result = await showSearch<ProductModel?>(
      context: context,
      delegate: ProductSearchDelegate(products: products),
    );

    if (result != null && mounted) {
      Navigator.push(context, SingleProduct.route(product: result));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: GlobalVariables.secondaryColor,
          ),
        ),
      );
    }

    if (!isLoading && products.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text('Something went wrong'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: fetchProducts,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: GlobalVariables.secondaryColor,
        elevation: 0,
        title: GestureDetector(
          onTap: _openSearch,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 18, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  'Search products, brands...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(CartScreen.route());
            },
          ),
        ],
      ),
      body: ProductList(products: products),
    );
  }
}
