import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final fullName = TextEditingController();
  final username = TextEditingController();
  final phone = TextEditingController();

  final currentPass = TextEditingController();
  final newPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.user != null) {
            fullName.text = state.user!.fullName ?? "";
            username.text = state.user!.username ?? "";
            phone.text = state.user!.phone ?? "";
          }

          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Success ✅")),
            );
          }
        },
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // =========================
                // PROFILE CARD
                // =========================
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                    state.user?.profileImage ??
                        "https://ui-avatars.com/api/?name=${state.user?.fullName ?? 'User'}",
                  ),
                ),

                const SizedBox(height: 20),

                _field(fullName, "Full Name"),
                const SizedBox(height: 10),
                _field(username, "Username"),
                const SizedBox(height: 10),
                _field(phone, "Phone"),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(
                          UpdateUserProfile(
                            fullName: fullName.text,
                            username: username.text,
                            phone: phone.text,
                          ),
                        );
                  },
                  child: const Text("Update Profile"),
                ),

                const Divider(height: 40),

                // =========================
                // CHANGE PASSWORD
                // =========================
                TextField(
                  controller: currentPass,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: newPass,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(
                          ChangeUserPassword(
                            currentPassword: currentPass.text,
                            newPassword: newPass.text,
                          ),
                        );
                  },
                  child: const Text("Change Password"),
                ),

                const SizedBox(height: 20),

                // =========================
                // DELETE ACCOUNT
                // =========================
                TextButton(
                  onPressed: () {
                    context.read<UserBloc>().add(DeleteUserAccount());
                  },
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}