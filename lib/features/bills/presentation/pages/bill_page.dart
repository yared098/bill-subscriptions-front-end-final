import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/app_bars.dart';
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
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Brand Identity Theme Palette
  final Color brandNavy = const Color.fromARGB(255, 182, 191, 202);
  final Color brandTeal = const Color(0xFF008080);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        appBar: AppBars.primary(
          title: "My Bills",
        ),
        body: Column(
          children: [
            // =====================================
            // WHITE FILTER & SEARCH HEADER BLOCK
            // =====================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Builder(
                builder: (blocContext) {
                  return Column(
                    children: [
                      // Modern Search Input Field
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search bills, organizations...",
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: brandTeal, size: 22),
                          suffixIcon: searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      searchQuery = "";
                                    });
                                  },
                                  child: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Horizontal filter chips slider
                      SingleChildScrollView(
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
                                    color: isSelected ? Colors.white : Colors.grey[700],
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: brandTeal,
                                backgroundColor: Colors.grey[100],
                                checkmarkColor: Colors.white,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                      ),
                    ],
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
                          return Center(child: CircularProgressIndicator(color: brandTeal));
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
                          // Filter list items locally based on search query matching title or organization name
                          final filteredBills = state.bills.where((bill) {
                            final matchTitle = bill.title.toLowerCase().contains(searchQuery);
                            final matchOrg = bill.organizationName.toLowerCase().contains(searchQuery);
                            return matchTitle || matchOrg;
                          }).toList();

                          if (filteredBills.isEmpty) {
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
                                        searchQuery.isNotEmpty 
                                            ? "No matches found for '$searchQuery'"
                                            : "No records found for '$selectedFilter'",
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
                            itemCount: filteredBills.length,
                            itemBuilder: (context, index) {
                              final bill = filteredBills[index];
                              final Color statusColor = _getStatusColor(bill.status);
                              final Color visualTone = _generateDynamicColor(bill.organizationName);

                              final String leadingLetter = bill.organizationName.isNotEmpty 
                                  ? bill.organizationName[0].toUpperCase() 
                                  : (bill.category.isNotEmpty ? bill.category[0].toUpperCase() : "?");

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  leading: Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: visualTone.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: visualTone.withOpacity(0.15), width: 1),
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
                                            color: Colors.blueGrey[800], // Increased contrast over brandNavy
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
                                          style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey[400]),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Due: ${bill.dueDate.toLocal().toString().split(' ')[0]}",
                                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
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
                                          color: Colors.blueGrey[800], // Increased contrast over brandNavy
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
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