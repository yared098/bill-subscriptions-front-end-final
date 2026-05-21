import 'package:bill_subscription_notifier/features/notifications/domain/entities/notification_entity.dart';
import 'package:bill_subscription_notifier/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:bill_subscription_notifier/features/notifications/presentation/bloc/notification_event.dart';
import 'package:bill_subscription_notifier/features/notifications/presentation/bloc/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPanel extends StatefulWidget {
  final VoidCallback onClose;

  const NotificationsPanel({
    super.key,
    required this.onClose,
  });

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  String _activeFilter = 'All';

  // Cohesive Color Palette
  static const Color brandNavy = Color(0xFF1A365D);
  static const Color brandTeal = Color(0xFF008080);
  static const Color bgSlate = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationBloc>().add(LoadNotifications());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (blocContext, state) {
          if (state is NotificationLoading) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 380,
                height: double.infinity,
                color: bgSlate,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: brandTeal,
                    strokeWidth: 3,
                  ),
                ),
              ),
            );
          }

          if (state is NotificationError) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 380,
                height: double.infinity,
                color: bgSlate,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red[400], size: 44),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: textMuted, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NotificationLoaded) {
            final notifications = List<NotificationEntity>.from(state.notifications);

            // Sort newest first
            notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final filtered = _filterNotifications(notifications);
            final unreadCount = notifications.where((e) => !e.isRead).length;

            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 380,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: bgSlate,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 24,
                      offset: Offset(-4, 0),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(unreadCount),
                      _buildFilterChips(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filtered.isEmpty
                            ? _buildEmptyState()
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (itemContext, index) {
                                  return _buildNotificationCard(blocContext, filtered[index]);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  List<NotificationEntity> _filterNotifications(List<NotificationEntity> list) {
    if (_activeFilter == 'Read') return list.where((e) => e.isRead).toList();
    if (_activeFilter == 'Unread') return list.where((e) => !e.isRead).toList();
    return list;
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      child: Row(
        children: [
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: brandNavy,
              letterSpacing: -0.3,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Text(
                "$count unread",
                style: TextStyle(
                  color: Colors.red[700], 
                  fontSize: 11, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: textMuted, size: 22),
            visualDensity: VisualDensity.compact,
            onPressed: widget.onClose,
          )
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = ['All', 'Unread', 'Read'];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final chip = chips[index];
          final selected = _activeFilter == chip;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: ChoiceChip(
                label: Text(chip),
                selected: selected,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : textMuted,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
                selectedColor: brandNavy,
                backgroundColor: Colors.white,
                disabledColor: Colors.transparent,
                side: BorderSide(
                  color: selected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onSelected: (_) {
                  setState(() => _activeFilter = chip);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext blocContext, NotificationEntity item) {
    // Determine dynamic visuals based on title contents / contexts
    final bool isBill = item.title.toLowerCase().contains('bill') || item.message.toLowerCase().contains('pay');
    final IconData dynamicIcon = isBill ? Icons.receipt_long_rounded : Icons.notifications_none_rounded;
    final Color iconColor = !item.isRead ? brandTeal : textMuted;
    final Color iconBg = !item.isRead ? brandTeal.withOpacity(0.08) : Colors.grey.withOpacity(0.08);

    return InkWell(
      onTap: () {
        if (!item.isRead) {
          // Trigger BLoC event to cleanly flip persistent data arrays
          // blocContext.read<NotificationBloc>().add(MarkAsRead(id: item.id));
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: !item.isRead ? brandTeal.withOpacity(0.15) : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Clean left bar visual indicator showing read status status
                Container(
                  width: 4,
                  color: !item.isRead ? brandTeal : Colors.transparent,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(dynamicIcon, color: iconColor, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: !item.isRead ? FontWeight.bold : FontWeight.w600,
                                        color: textDark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatTimestamp(item.createdAt),
                                    style: const TextStyle(color: textMuted, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.message,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: !item.isRead ? textDark.withOpacity(0.85) : textMuted,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                )
              ]
            ),
            child: Icon(Icons.notifications_off_outlined, size: 40, color: Colors.grey[350]),
          ),
          const SizedBox(height: 14),
          const Text(
            "All caught up!",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark),
          ),
          const SizedBox(height: 4),
          Text(
            "No $_activeFilter notifications here.",
            style: const TextStyle(fontSize: 13, color: textMuted),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays >= 1) return "${diff.inDays}d ago";
    if (diff.inHours >= 1) return "${diff.inHours}h ago";
    if (diff.inMinutes >= 1) return "${diff.inMinutes}m ago";
    return "Just now";
  }
}