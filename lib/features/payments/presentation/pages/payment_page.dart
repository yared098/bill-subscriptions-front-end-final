import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_payment.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/datasources/payment_remote_datasource.dart';

import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentPage extends StatelessWidget {
  final String token;

  const PaymentPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(
        CreatePayment(
          PaymentRepositoryImpl(
            PaymentRemoteDataSource(),
          ),
        ),
      ),
      child: _PaymentView(token: token),
    );
  }
}

class _PaymentView extends StatefulWidget {
  final String token;
  const _PaymentView({required this.token});

  @override
  State<_PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<_PaymentView> {
  final TextEditingController _amountController = TextEditingController(text: "100");
  String _selectedProvider = "chapa"; // Default selection
  String _selectedPurpose = "bill";

  final List<Map<String, dynamic>> _providers = [
    {"id": "chapa", "title": "Chapa", "icon": Icons.account_balance_wallet, "color": Color(0xFF2563EB)},
    {"id": "telebirr", "title": "Telebirr", "icon": Icons.phone_android, "color": Color(0xFF10B981)},
    {"id": "bank", "title": "Bank Transfer", "icon": Icons.account_balance, "color": Color(0xFF7C3AED)},
  ];

  final List<int> _quickAmounts = [50, 100, 250, 500];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _currentAmount => double.tryParse(_amountController.text) ?? 0.0;

  void _submitPayment(BuildContext context) {
    if (_currentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid amount"),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    context.read<PaymentBloc>().add(
      CreatePaymentEvent(
        amount: _currentAmount,
        provider: _selectedProvider,
        purpose: _selectedPurpose,
        token: widget.token, // Correctly passing the token here now
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBars.primary(
  title: "Payment Hub",
  actions: [
    IconButton(
      icon: const Icon(Icons.history_rounded, color: Color(0xFF0F172A)),
      onPressed: () {},
    )
  ],
),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Text("Payment of \$$_currentAmount initiated via $_selectedProvider"),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );

            if (state.payment.checkoutUrl != null) {
              debugPrint("Checkout URL: ${state.payment.checkoutUrl}");
              // Optional: Open the URL using a library like url_launcher
            }
          } else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment processing failed. Please try again."),
                backgroundColor: Color(0xFFEF4444),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PaymentLoading;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ================= HERO GRADIENT CARD =================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF2563EB), Color(0xFF4F46E5), Color(0xFF7C3AED)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withOpacity(0.25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Secure Transactions",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Pay your bills, settle subscriptions, or execute direct bank transfers instantly.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ================= AMOUNT INPUT SECTION =================
                          const Text(
                            "Enter Amount",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                            ),
                            child: TextField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                              decoration: const InputDecoration(
                                prefixText: "\$ ",
                                prefixStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
                                border: InputBorder.none,
                                hintText: "0.00",
                                hintStyle: TextStyle(color: Color(0xFFCBD5E1)),
                              ),
                              onChanged: (val) => setState(() {}),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ================= QUICK AMOUNT CHIPS =================
                          SizedBox(
                            height: 38,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _quickAmounts.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final amount = _quickAmounts[index];
                                final isSelected = _currentAmount == amount;
                                return ChoiceChip(
                                  label: Text("\$$amount"),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _amountController.text = amount.toString();
                                      });
                                    }
                                  },
                                  selectedColor: const Color(0xFF2563EB).withOpacity(0.1),
                                  checkmarkColor: const Color(0xFF2563EB),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                                  ),
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ================= SELECT PROVIDER SECTION =================
                          const Text(
                            "Select Payment Provider",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: _providers.map((prov) {
                              final isSelected = _selectedProvider == prov["id"];
                              final Color itemColor = prov["color"];

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: isSelected ? itemColor.withOpacity(0.04) : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected ? itemColor : const Color(0xFFE2E8F0),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedProvider = prov["id"];
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: itemColor.withOpacity(0.1),
                                                  child: Icon(prov["icon"], color: itemColor, size: 24),
                                                ),
                                                if (isSelected)
                                                  Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor: itemColor,
                                                      child: const Icon(Icons.check, size: 10, color: Colors.white),
                                                    ),
                                                  )
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              prov["title"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                fontSize: 13,
                                                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 28),

                          // ================= PURPOSE / ACTION TYPE =================
                          const Text(
                            "Payment Purpose",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPurposeOption(
                            title: "Standard Bill Payment",
                            subtitle: "Utilities, logistics, or custom orders",
                            icon: Icons.receipt_long,
                            id: "bill",
                          ),
                          const SizedBox(height: 10),
                          _buildPurposeOption(
                            title: "Renew Subscriptions",
                            subtitle: "Auto-renew monthly recurring platform charges",
                            icon: Icons.autorenew,
                            id: "subscriptions",
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ================= BOTTOM PROCEED BAR =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _submitPayment(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A), // Dark elegant primary action button
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                "Proceed with Pay \$$_currentAmount",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPurposeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String id,
  }) {
    final isSelected = _selectedPurpose == id;
    return InkWell(
      onTap: () => setState(() => _selectedPurpose = id),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedPurpose,
              activeColor: const Color(0xFF2563EB),
              onChanged: (val) {
                if (val != null) setState(() => _selectedPurpose = val);
              },
            )
          ],
        ),
      ),
    );
  }
}