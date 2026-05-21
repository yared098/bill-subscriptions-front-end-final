import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_bills.dart';
import '../../data/repositories/bill_repository_impl.dart';
import '../../data/datasources/bill_remote_datasource.dart';

import '../bloc/bill_bloc.dart';
import '../bloc/bill_event.dart';
import '../bloc/bill_state.dart';

class BillPage extends StatefulWidget {
  final String token;

  const BillPage({super.key, required this.token});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  String selectedFilter = "all";

  // Brand Identity Theme Palette
  final Color brandNavy = const Color(0xFF1A365D);
  final Color brandTeal = const Color(0xFF008080);

  // Status Chip Color Mapping
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.redAccent;
      case 'upcoming':
        return Colors.amber.shade700;
      default:
        return Colors.grey;
    }
  }

  // Generates a deterministically unique background color based on the organization or category text
  Color _generateDynamicColor(String input) {
    if (input.isEmpty) return brandTeal;
    final int hash = input.hashCode;
    
    // A clean selection of soft, modern material tones
    final List<Color> vibrantColors = [
      const Color(0xFF4F46E5), // Indigo
      const Color(0xFF0EA5E9), // Sky Blue
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEC4899), // Pink
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF008080), // Teal
    ];
    
    return vibrantColors[hash.abs() % vibrantColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BillBloc(GetBills(BillRepositoryImpl(BillRemoteDataSource())))
            ..add(LoadBills()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: brandNavy,
          elevation: 0,
          title: const Text(
            "My Bills",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // =====================================
            // HORIZONTAL FILTER CHIP SLIDER BANNER
            // =====================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: brandNavy,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Builder(
                builder: (blocContext) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: ["all", "paid", "unpaid", "upcoming"].map((filterKey) {
                        final bool isSelected = selectedFilter == filterKey;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              filterKey.SouthernCapitalize(), 
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? brandNavy : const Color(0xFFE2E8F0),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            checkmarkColor: brandNavy,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onSelected: (bool selected) {
                              if (selected) {
                                setState(() => selectedFilter = filterKey);
                                blocContext.read<BillBloc>().add(FilterBills(type: filterKey));
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              ),
            ),

            // =====================================
            // BLOC LOGIC & REFRESH STREAM CONTAINER
            // =====================================
            Expanded(
              child: Builder(
                builder: (blocContext) {
                  return RefreshIndicator(
                    color: brandTeal,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      blocContext.read<BillBloc>().add(RefreshBills());
                    },
                    child: BlocBuilder<BillBloc, BillState>(
                      builder: (context, state) {
                        if (state is BillLoading) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFF008080)));
                        }

                        if (state is BillError) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                              Center(child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
                              )),
                            ],
                          );
                        }

                        if (state is BillLoaded) {
                          if (state.bills.isEmpty) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey[300]),
                                      const SizedBox(height: 16),
                                      Text(
                                        "No records found for '$selectedFilter'",
                                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.bills.length,
                            itemBuilder: (context, index) {
                              final bill = state.bills[index];
                              final Color statusColor = _getStatusColor(bill.status);
                              final Color visualTone = _generateDynamicColor(bill.organizationName);

                              // Extract safe fallback letter token
                              final String leadingLetter = bill.organizationName.isNotEmpty 
                                  ? bill.organizationName[0].toUpperCase() 
                                  : (bill.category.isNotEmpty ? bill.category[0].toUpperCase() : "?");

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  
                                  // Highly beautiful dynamic dynamic color circle avatars
                                  leading: Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: visualTone.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: visualTone.withOpacity(0.2), width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        leadingLetter,
                                        style: TextStyle(
                                          color: visualTone,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          bill.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: brandNavy,
                                          ),
                                        ),
                                      ),
                                      if (bill.recurring)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6.0),
                                          child: Icon(Icons.autorenew, size: 14, color: brandTeal.withOpacity(0.7)),
                                        ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${bill.organizationName} • ${bill.category}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey[500]),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Due: ${bill.dueDate.toLocal().toString().split(' ')[0]}",
                                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${bill.amount.toStringAsFixed(2)} ETB",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: brandNavy,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          bill.status.toUpperCase(),
                                          style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCapitalize on String {
  String SouthernCapitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}