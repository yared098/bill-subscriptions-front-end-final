import 'package:bill_subscription_notifier/core/network/socket/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';

import '../../data/repositories/notification_repository_impl.dart';
import '../../data/datasources/notification_remote_datasource.dart';

import '../../data/datasources/socket_datasource.dart';
import '../../data/repositories/socket_repository_impl.dart';

import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationPage extends StatelessWidget {
  final String token;
  final String userId;

  const NotificationPage({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // =========================
    // API LAYER
    // =========================
    final remote = NotificationRemoteDataSource();
    final repo = NotificationRepositoryImpl(remote);

    // =========================
    // SOCKET LAYER (NEW)
    // =========================
final socketService = SocketService();
final socketRepo = SocketRepositoryImpl(socketService);

    return BlocProvider(
      create: (_) => NotificationBloc(
        GetNotifications(repo),
        MarkNotificationAsRead(repo),
        socketRepo, // ✅ FIXED HERE
      )
        ..add(LoadNotifications())
        ..add(StartSocketEvent(userId)), // 🔥 AUTO START SOCKET

      child: Scaffold(
        appBar: AppBar(title: const Text("Notifications")),

        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(child: Text(state.message));
            }

            if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text("No Notifications"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final n = state.notifications[index];

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: n.isRead
                          ? Colors.grey.shade100
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            n.isRead ? Colors.green : Colors.orange,
                        child: Icon(
                          n.isRead
                              ? Icons.check
                              : Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        n.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(n.message),
                      trailing: n.isRead
                          ? const Text(
                              "Read",
                              style: TextStyle(color: Colors.green),
                            )
                          : IconButton(
                              icon: const Icon(Icons.mark_email_read),
                              onPressed: () {
                                context.read<NotificationBloc>().add(
                                      MarkAsRead(n.id),
                                    );
                              },
                            ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}