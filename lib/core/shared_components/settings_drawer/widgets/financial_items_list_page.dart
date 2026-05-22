import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/dashboard_list_item.dart';
import 'package:bill_subscription_notifier/features/bills/data/models/bill_model.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_bloc.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_event.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_state.dart';
import 'package:bill_subscription_notifier/features/subscriptions/data/models/subscription_model.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_event.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FinancialType {
  bills,
  subscriptions,
}

class FinancialItemsListPage extends StatefulWidget {
  final String title;
  final String totalLabel;
  final String totalAmount;
  final FinancialType type;
  final VoidCallback? onBack;

  const FinancialItemsListPage({
    super.key,
    required this.title,
    required this.totalLabel,
    required this.totalAmount,
    required this.type,
    this.onBack,
  });

  @override
  State<FinancialItemsListPage> createState() => _FinancialItemsListPageState();
}

class _FinancialItemsListPageState extends State<FinancialItemsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilterChip = 'All';
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.type == FinancialType.bills) {
        context.read<BillBloc>().add(LoadBills());
      } else {
        context.read<SubscriptionBloc>().add(LoadSubscriptions());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPipeline() async {
    if (widget.type == FinancialType.bills) {
      context.read<BillBloc>().add(RefreshBills());
    } else {
      context.read<SubscriptionBloc>().add(LoadSubscriptions());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Theme Token Mapping (Clean Light Theme)
    const primaryColor = Color(0xFF2563EB); // Vibrant Royal Blue
    const backgroundColor = Color(0xFFF8FAFC); // Clean Slate Tint

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 16),
              onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Search ledger records...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.toLowerCase().trim();
                    });
                  },
                )
              : Text(
                  widget.title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF1F5F9),
              child: IconButton(
                icon: Icon(
                  _isSearching ? Icons.close_rounded : Icons.search_rounded,
                  color: const Color(0xFF475569),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      _searchQuery = "";
                    }
                  });
                },
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeroBalanceCard(primaryColor),
            _buildFilterChipsRow(primaryColor),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshPipeline,
                color: primaryColor,
                backgroundColor: Colors.white,
                child: widget.type == FinancialType.bills
                    ? _buildBillsPipeline()
                    : _buildSubscriptionsPipeline(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBalanceCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Structural Subtle Light Background Accent Circles
            Positioned(
              right: -30,
              top: -30,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: primaryColor.withOpacity(0.04),
              ),
            ),
            Positioned(
              right: 40,
              bottom: -50,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor.withOpacity(0.02),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Decorative Functional Icon Container
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.type == FinancialType.bills 
                          ? Icons.account_balance_wallet_rounded 
                          : Icons.autorenew_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.totalLabel.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.totalAmount,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow(Color primaryColor) {
    final filterChips = ['All', 'Pending', 'Cleared', 'Overdue'];
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
        physics: const BouncingScrollPhysics(),
        itemCount: filterChips.length,
        itemBuilder: (context, index) {
          final chipLabel = filterChips[index];
          final isSelected = _activeFilterChip == chipLabel;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => setState(() => _activeFilterChip = chipLabel),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  chipLabel,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBillsPipeline() {
    return BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        if (state is BillLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }
        if (state is BillError) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(state.message, style: const TextStyle(color: Color(0xFF64748B))),
          ));
        }

        final rawBills = state is BillLoaded ? state.bills : <BillModel>[];
        final now = DateTime.now();

        final processedBills = rawBills.where((bill) {
          final matchesSearch = bill.title.toLowerCase().contains(_searchQuery);
          final isOverdue = bill.dueDate.isBefore(now) && bill.status != 'Paid';
          final isPaid = bill.status == 'Paid';

          if (!matchesSearch) return false;

          switch (_activeFilterChip) {
            case 'Pending': return !isPaid && !isOverdue;
            case 'Cleared': return isPaid;
            case 'Overdue': return isOverdue;
            default: return true;
          }
        }).toList();

        if (processedBills.isEmpty) return _buildEmptyState();

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: processedBills.length,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final bill = processedBills[index];
            final bool isPaid = bill.status == 'Paid';
            final bool isOverdue = bill.dueDate.isBefore(now) && !isPaid;

            return DashboardListItem(
              leadingWidget: CircleAvatar(
                backgroundColor: isPaid
                    ? const Color(0xFFDCFCE7)
                    : isOverdue
                        ? const Color(0xFFFEE2E2)
                        : const Color(0xFFEFF6FF),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 18,
                  color: isPaid
                      ? const Color(0xFF16A34A)
                      : isOverdue
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF2563EB),
                ),
              ),
              title: bill.title,
              subtitle: 'Due: ${bill.dueDate.day}/${bill.dueDate.month}/${bill.dueDate.year}',
              amount: 'ETB ${bill.amount.toStringAsFixed(2)}',
              amountColor: isOverdue ? const Color(0xFFDC2626) : const Color(0xFF0F172A),
              trailingWidget: isOverdue
                  ? const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 18)
                  : isPaid 
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18)
                      : const Icon(Icons.access_time_filled_rounded, color: Color(0xFF64748B), size: 18),
            );
          },
        );
      },
    );
  }

  Widget _buildSubscriptionsPipeline() {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }
        if (state is SubscriptionError) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(state.message, style: const TextStyle(color: Color(0xFF64748B))),
          ));
        }

        final rawSubs = state is SubscriptionLoaded ? state.subscriptions : <SubscriptionModel>[];

        final processedSubs = rawSubs.where((sub) {
          final matchesSearch = sub.name.toLowerCase().contains(_searchQuery);
          final isActive = sub.status.toLowerCase() == 'active';

          if (!matchesSearch) return false;

          switch (_activeFilterChip) {
            case 'Pending': return !isActive;
            case 'Cleared': return isActive;
            case 'Overdue': return false;
            default: return true;
          }
        }).toList();

        if (processedSubs.isEmpty) return _buildEmptyState();

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: processedSubs.length,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final sub = processedSubs[index];
            final bool isActive = sub.status.toLowerCase() == 'active';

            return DashboardListItem(
              leadingWidget: CircleAvatar(
                backgroundColor: isActive ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                child: Text(
                  sub.name.isNotEmpty ? sub.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: isActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: sub.name,
              subtitle: 'Status: ${sub.status}',
              amount: 'ETB ${sub.amount.toStringAsFixed(2)}',
              amountColor: isActive ? const Color(0xFF16A34A) : const Color(0xFF64748B),
              trailingWidget: Icon(
                isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 18,
                color: isActive ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.folder_open_rounded, size: 40, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 18),
            const Text(
              'No matching records',
              style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                _searchQuery.isNotEmpty 
                    ? 'We couldn\'t find anything matching your search term.' 
                    : 'Your selected view has no active items.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}