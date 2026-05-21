import 'package:flutter/material.dart';

class ExpenseMonthlyAnalysisPage extends StatelessWidget {
  const ExpenseMonthlyAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock analytical model representing month-over-month trajectory
    final List<Map<String, dynamic>> monthlyData = [
      {'month': 'Jan', 'amount': 2800.0, 'percentage': 0.65},
      {'month': 'Feb', 'amount': 3100.0, 'percentage': 0.72},
      {'month': 'Mar', 'amount': 4200.0, 'percentage': 0.95},
      {'month': 'Apr', 'amount': 2500.0, 'percentage': 0.58},
      {'month': 'May', 'amount': 3210.0, 'percentage': 0.74}, // Highlight Current
      {'month': 'Jun', 'amount': 1900.0, 'percentage': 0.42},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Expense Analytics',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Total Panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981), // Emerald Accent Color
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RUNNING MONTHLY AVERAGE',
                      style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'ETB 3,210.00',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Historical Trends',
                style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Custom Pure Flutter Analytical Bar Graph Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: monthlyData.map((data) {
                          bool isCurrentMonth = data['month'] == 'May';
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: isCurrentMonth ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  // Set dynamic proportional layout size
                                  margin: EdgeInsets.only(
                                    top: (160 * (1.0 - (data['percentage'] as double))).clamp(0, 160),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['month'],
                                style: TextStyle(
                                  color: isCurrentMonth ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                  fontWeight: isCurrentMonth ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Breakdown List
              ...monthlyData.reversed.map((data) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['month'], style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                    Text('ETB ${data['amount'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}