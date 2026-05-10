import 'package:amazon/src/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final Map<String, String> statusLabel;

  const OrderCard({super.key, required this.order, required this.statusLabel});

  String _formatPrice(String price) {
    final value = double.tryParse(price) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  double _orderTotal() {
    return order.items.fold(0, (sum, item) {
      final price = double.tryParse(item.priceAtPurchase) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  Color _statusColor(String status) {
    return switch (status) {
      'PENDING' => const Color(0xFFF59E0B),
      'PAID' => const Color(0xFF3B82F6),
      'SHIPPED' => const Color(0xFF8B5CF6),
      'DELIVERED' => const Color(0xFF10B981),
      'CANCELLED' => const Color(0xFFEF4444),
      _ => Colors.grey,
    };
  }

  Color _statusBgColor(String status) {
    return switch (status) {
      'PENDING' => const Color(0xFFFEF3C7),
      'PAID' => const Color(0xFFEFF6FF),
      'SHIPPED' => const Color(0xFFF5F3FF),
      'DELIVERED' => const Color(0xFFECFDF5),
      'CANCELLED' => const Color(0xFFFEF2F2),
      _ => Colors.grey.shade100,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'PENDING' => Icons.access_time_rounded,
      'PAID' => Icons.check_circle_outline_rounded,
      'SHIPPED' => Icons.local_shipping_outlined,
      'DELIVERED' => Icons.inventory_2_outlined,
      'CANCELLED' => Icons.cancel_outlined,
      _ => Icons.receipt_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final label = statusLabel[order.status] ?? order.status;
    final color = _statusColor(order.status);
    final bgColor = _statusBgColor(order.status);
    final total = _orderTotal();
    final totalItems = order.items.fold(0, (sum, i) => sum + i.quantity);
    final formattedDate = DateFormat(
      'd MMM yyyy, HH:mm',
      'id_ID',
    ).format(order.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No. Pesanan',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#${order.id.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon(order.status), size: 12, color: color),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF5F5F5)),

          // Items preview
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                ...order.items
                    .take(2)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productId,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity}x  •  ${_formatPrice(item.priceAtPurchase)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                if (order.items.length > 2)
                  Text(
                    '+${order.items.length - 2} produk lainnya',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF5F5F5)),

          // Footer — date + total + action
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalItems barang  •  $formattedDate',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: ${_formatPrice(total.toString())}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // navigate to order detail
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
