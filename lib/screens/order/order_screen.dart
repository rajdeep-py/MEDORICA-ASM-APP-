import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/order/order_card.dart';
import '../../cards/order/order_details_bottomsheet.dart';
import '../../cards/order/order_search_filter_card.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  String _searchQuery = '';
  OrderStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(orderNotifierProvider);
    final filteredOrders = _filterOrders(allOrders);

    return Scaffold(
      appBar: const MRAppBar(
        titleText: 'MR Orders',
        subtitleText: 'Track your orders',
        showActions: false,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          OrderSearchFilterCard(
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
            },
            onStatusFilterChanged: (status) {
              setState(() => _selectedStatus = status);
            },
          ),

          // Orders List
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.note_remove,
                          size: 64,
                          color: AppColors.quaternary.withAlpha(150),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.quaternary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try adjusting your search'
                              : 'No orders available',
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary.withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onTap: () => _showOrderDetails(order),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRouter.createOrder);
        },
        elevation: 4,
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: AppColors.white, size: 24),
        label: Text(
          'New Order',
          style: AppTypography.body.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: const MRBottomNavBar(currentIndex: 2),
    );
  }

  List<Order> _filterOrders(List<Order> orders) {
    var filtered = orders;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((order) =>
              order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              order.mrName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              order.chemistShopName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              order.distributorName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != null) {
      filtered = filtered.where((order) => order.status == _selectedStatus).toList();
    }

    return filtered;
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsBottomSheet(order: order),
    );
  }
}
