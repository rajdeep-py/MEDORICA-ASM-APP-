import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class DistributorSearchFilterCard extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String?) onFilterChange;

  const DistributorSearchFilterCard({
    super.key,
    required this.onSearch,
    required this.onFilterChange,
  });

  @override
  State<DistributorSearchFilterCard> createState() =>
      _DistributorSearchFilterCardState();
}

class _DistributorSearchFilterCardState
    extends State<DistributorSearchFilterCard> {
  late TextEditingController _searchController;
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                hintText: 'Search distributor...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.quaternary,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: AppColors.quaternary,
                  size: 18,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 34,
                  minHeight: 34,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
              ),
              style: AppTypography.body.copyWith(color: AppColors.primary),
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: AppColors.primaryLight,
            margin: const EdgeInsets.symmetric(horizontal: 6),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedFilter = value);
              widget.onFilterChange(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Distributors'),
              ),
              const PopupMenuItem(
                value: 'lowOrder',
                child: Text('Low Min. Order'),
              ),
              const PopupMenuItem(
                value: 'fastDelivery',
                child: Text('Fast Delivery'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Iconsax.setting_3,
                color: _selectedFilter != null
                    ? AppColors.primary
                    : AppColors.quaternary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
