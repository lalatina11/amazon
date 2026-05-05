import 'package:amazon/src/constants/global_variables.dart';
import 'package:amazon/src/feature/home/widget/product_list.dart';
import 'package:amazon/src/model/product_model.dart';
import 'package:amazon/src/services/product_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductServices productServices = ProductServices();
  bool isLoading = false;
  List<ProductModel> products = [];

  void fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await productServices.getAllProducts();
      if (res.success || res.data != null) {
        final data = res.data as List<dynamic>;
        final result = data.map((d) => ProductModel.fromMap(d)).toList();
        setState(() {
          products = result;
        });
      }
      print("products $products");
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
      return Scaffold(body: Center(child: Text("An error occured")));
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home')),
        backgroundColor: GlobalVariables.secondaryColor,
      ),
      body: ProductList(products: products),
    );
  }
}
