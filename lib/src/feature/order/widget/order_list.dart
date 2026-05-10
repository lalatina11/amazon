import 'package:amazon/src/feature/order/services/order_services.dart';
import 'package:amazon/src/feature/order/widget/order_card.dart';
import 'package:amazon/src/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderList extends StatefulWidget {
  final String token;
  const OrderList({super.key, required this.token});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList>
    with SingleTickerProviderStateMixin {
  final OrderServices orderServices = OrderServices();
  bool isLoading = false;
  List<OrderModel> orders = [];
  late TabController _tabController;

  final List<String> _statusTabs = [
    'Semua',
    'PENDING',
    'PAID',
    'SHIPPED',
    'DELIVERED',
    'CANCELLED',
  ];

  final Map<String, String> _statusLabel = {
    'PENDING': 'Menunggu',
    'PAID': 'Dibayar',
    'SHIPPED': 'Dikirim',
    'DELIVERED': 'Selesai',
    'CANCELLED': 'Dibatalkan',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final res = await orderServices.getAllOrders(token: widget.token);
      if (res.success && res.data != null) {
        final result = res.data as List<dynamic>;
        setState(() {
          orders = result.map((e) => OrderModel.fromMap(e)).toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<OrderModel> _filteredOrders(String status) {
    if (status == 'Semua') return orders;
    return orders.where((o) => o.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Status tabs
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: const Color(0xFFFF6B35),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFFF6B35),
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            tabs: _statusTabs.map((s) {
              final label = _statusLabel[s] ?? s;
              final count = _filteredOrders(s).length;
              return Tab(
                child: Row(
                  children: [
                    Text(label),
                    if (count > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _statusTabs.map((status) {
              final filtered = _filteredOrders(status);
              if (filtered.isEmpty) return _buildEmpty(status);
              return RefreshIndicator(
                color: const Color(0xFFFF6B35),
                onRefresh: () async => fetchOrders(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => OrderCard(
                    order: filtered[index],
                    statusLabel: _statusLabel,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(String status) {
    final label = _statusLabel[status] ?? 'pesanan';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            status == 'Semua'
                ? 'Belum ada pesanan'
                : 'Tidak ada pesanan $label',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pesanan kamu akan muncul di sini',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
