import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cards/chemist_shop/chemist_shop_card.dart';
import '../../cards/chemist_shop/chemist_shop_search_filter_card.dart';
import '../../models/chemist_shop.dart';
import '../../providers/chemist_shop_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

class ChemistShopScreen extends ConsumerStatefulWidget {
  const ChemistShopScreen({super.key});

  @override
  ConsumerState<ChemistShopScreen> createState() => _ChemistShopScreenState();
}

class _ChemistShopScreenState extends ConsumerState<ChemistShopScreen> {
  String _searchQuery = '';
  List<ChemistShop> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredList();
  }

  void _updateFilteredList() {
    final allShops = ref.read(chemistShopNotifierProvider);
    if (_searchQuery.isEmpty) {
      _filteredShops = allShops;
    } else {
      _filteredShops = allShops
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.mrName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(chemistShopNotifierProvider);

    return Scaffold(
      appBar: const MRAppBar(
        showBack: false,
        showActions: false,
        titleText: 'Chemist Shops',
        subtitleText: 'Manage your retail partners',
      ),
      body: Column(
        children: [
          // Search and Filter
          ChemistShopSearchFilterCard(
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
                _updateFilteredList();
              });
            },
            onFilterChange: (filter) {
              // Handle filter changes
            },
          ),
          // Shop List
          Expanded(
            child: _filteredShops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.shop,
                          size: 80,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Chemist Shops Found',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first chemist shop to get started',
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = _filteredShops[index];
                      return ChemistShopCard(
                        shop: shop,
                        onTap: () {
                          context.push(
                            '/chemist-shop-detail/${shop.id}',
                            extra: shop,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      
      bottomNavigationBar: const MRBottomNavBar(currentIndex: 3),
    );
  }
}
