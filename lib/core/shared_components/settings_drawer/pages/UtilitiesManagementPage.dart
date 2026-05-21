import 'package:flutter/material.dart';

class UtilitiesManagementPage extends StatefulWidget {
  const UtilitiesManagementPage({super.key});

  @override
  State<UtilitiesManagementPage> createState() => _UtilitiesManagementPageState();
}

class _UtilitiesManagementPageState extends State<UtilitiesManagementPage> {
  // Local state manager array holding user utility subscriptions
  final List<Map<String, dynamic>> _utilities = [
    {'id': '1', 'name': 'Fibre Internet', 'provider': 'Ethio Telecom', 'amount': 1800.0, 'isSubscribed': true},
    {'id': '2', 'name': 'Water Utility', 'provider': 'AAWSA', 'amount': 350.0, 'isSubscribed': true},
    {'id': '3', 'name': 'Electricity Pay-Go', 'provider': 'EEU', 'amount': 1060.0, 'isSubscribed': true},
    {'id': '4', 'name': 'Premium Cloud Storage', 'provider': 'Server Ops', 'amount': 540.0, 'isSubscribed': false},
  ];

  void _toggleSubscription(int index) {
    setState(() {
      _utilities[index]['isSubscribed'] = !_utilities[index]['isSubscribed'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _utilities[index]['isSubscribed'] 
            ? 'Successfully Subscribed to ${_utilities[index]['name']}'
            : 'Unsubscribed from ${_utilities[index]['name']}'
        ),
        backgroundColor: _utilities[index]['isSubscribed'] ? const Color(0xFF2563EB) : const Color(0xFF475569),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalActiveCommitment = _utilities
        .where((u) => u['isSubscribed'] == true)
        .fold(0.0, (sum, item) => sum + item['amount']);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Utility Services', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Aggregate Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOTAL UTILITY FLOW', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Active Pipeline', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Text(
                    'ETB ${totalActiveCommitment.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // Subscriptions Ledger
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _utilities.length,
                itemBuilder: (context, index) {
                  final item = _utilities[index];
                  bool isSubbed = item['isSubscribed'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: isSubbed ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                        child: Icon(
                          isSubbed ? Icons.bolt_rounded : Icons.power_off_rounded,
                          color: isSubbed ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                        ),
                      ),
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      subtitle: Text('${item['provider']} • ETB ${item['amount']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      trailing: OutlinedButton(
                        onPressed: () => _toggleSubscription(index),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSubbed ? Colors.white : const Color(0xFF2563EB),
                          side: BorderSide(color: isSubbed ? const Color(0xFFEF4444) : Colors.transparent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          isSubbed ? 'Unsubscribe' : 'Subscribe',
                          style: TextStyle(
                            color: isSubbed ? const Color(0xFFEF4444) : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}