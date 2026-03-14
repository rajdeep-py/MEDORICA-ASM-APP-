import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.approved:
        return const Color(0xFF4CAF50);
      case OrderStatus.pending:
        return const Color(0xFFFFC107);
      case OrderStatus.delivered:
        return const Color(0xFF2196F3);
      case OrderStatus.shipped:
        return const Color(0xFF3F51B5);
      case OrderStatus.received:
        return const Color(0xFF8BC34A);
      case OrderStatus.rejected:
        return const Color(0xFFF44336);
      case OrderStatus.cancelled:
        return const Color(0xFF9E9E9E);
    }
  }

  String _getStatusText() {
    return order.status.toString().split('.').last.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.primaryLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withAlpha(200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Shop Name
            Row(
              children: [
                Icon(Iconsax.shop, color: AppColors.quaternary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Shop: ${order.chemistShopName}',
                    style: AppTypography.body.copyWith(
                      color: AppColors.quaternary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Distributor Name
            Row(
              children: [
                Icon(Iconsax.truck, color: AppColors.quaternary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dist: ${order.distributorName}',
                    style: AppTypography.body.copyWith(
                      color: AppColors.quaternary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
