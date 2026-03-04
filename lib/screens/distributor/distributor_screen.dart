import 'package:asm_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cards/distributor/distributor_card.dart';
import '../../cards/distributor/distributor_search_filter_card.dart';
import '../../models/distributor.dart';
import '../../providers/distributor_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

class DistributorScreen extends ConsumerStatefulWidget {
  const DistributorScreen({super.key});

  @override
  ConsumerState<DistributorScreen> createState() => _DistributorScreenState();
}

class _DistributorScreenState extends ConsumerState<DistributorScreen> {
  String _searchQuery = '';
  List<Distributor> _filteredDistributors = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredList();
  }

  void _updateFilteredList() {
    final allDistributors = ref.read(distributorNotifierProvider);
    if (_searchQuery.isEmpty) {
      _filteredDistributors = allDistributors;
    } else {
      _filteredDistributors = allDistributors
          .where((d) =>
              d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.location.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(distributorNotifierProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRouter.home);
        }
      },
      child: Scaffold(
      appBar: const MRAppBar(
        showBack: false,
        showActions: false,
        titleText: 'Distributors',
        subtitleText: 'Manage your distributors',
      ),
      body: Column(
        children: [
          // Search and Filter
          DistributorSearchFilterCard(
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
          // Distributor List
          Expanded(
            child: _filteredDistributors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.box,
                          size: 80,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Distributors Found',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first distributor to get started',
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _filteredDistributors.length,
                    itemBuilder: (context, index) {
                      final distributor = _filteredDistributors[index];
                      return DistributorCard(
                        distributor: distributor,
                        onTap: () {
                          context.push(
                            '/distributor-detail/${distributor.id}',
                            extra: distributor,
                          );
                        },
                        onEdit: () {
                          context.push(
                            '/add-edit-distributor/${distributor.id}',
                            extra: distributor,
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmation(distributor);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/add-edit-distributor');
        },
        elevation: 4,
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: AppColors.white, size: 24),
        label: Text(
          'Add Distributor',
          style: AppTypography.body.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: const MRBottomNavBar(currentIndex: 4),
      ),
    );
  }

  void _showDeleteConfirmation(Distributor distributor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Distributor'),
        content: Text('Are you sure you want to delete ${distributor.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(distributorNotifierProvider.notifier)
                  .deleteDistributor(distributor.id);
              Navigator.pop(context);
              setState(() => _updateFilteredList());
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
