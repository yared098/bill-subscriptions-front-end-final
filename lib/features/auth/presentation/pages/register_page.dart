import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController controller = AuthController();

  final _formKey = GlobalKey<FormState>();

  // =========================
  // CONTROLLERS
  // =========================

  final fullNameController = TextEditingController();

  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final faydaIdController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLoading = false;

  bool obscurePassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    faydaIdController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // =========================
  // REGISTER
  // =========================

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final success = await controller.register(
      fullName: fullNameController.text.trim(),

      username: usernameController.text.trim(),

      email: emailController.text.trim(),

      phone: phoneController.text.trim(),

      faydaId: faydaIdController.text.trim(),

      password: passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully 🎉"),
          backgroundColor: Colors.green,
        ),
      );

      context.go("/login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                // =========================
                // HEADER
                // =========================
                Center(
                  child: Column(
                    children: [
                      Container(
  height: 100,
  width: double.infinity,
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Image.asset(
    "assets/logo.png",
    fit: BoxFit.contain,
  ),
),

                      const SizedBox(height: 24),

                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Manage Ethiopian bills & subscriptions easily",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // =========================
                // FULL NAME
                // =========================
                _buildTextField(
                  controller: fullNameController,
                  label: "Full Name",
                  hint: "Enter full name",
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Full name required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // =========================
                // USERNAME
                // =========================
                _buildTextField(
                  controller: usernameController,
                  label: "Username",
                  hint: "Enter username",
                  icon: Icons.alternate_email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Username required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // =========================
                // EMAIL
                // =========================
                _buildTextField(
                  controller: emailController,
                  label: "Email Address",
                  hint: "example@gmail.com",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email required";
                    }

                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return "Invalid email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // =========================
                // PHONE
                // =========================
                _buildTextField(
                  controller: phoneController,
                  label: "Phone Number",
                  hint: "09XXXXXXXX",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // =========================
                // FAYDA ID
                // =========================
                _buildTextField(
                  controller: faydaIdController,
                  label: "Fayda ID",
                  hint: "Optional Fayda ID",
                  icon: Icons.badge_outlined,
                ),

                const SizedBox(height: 18),

                // =========================
                // PASSWORD
                // =========================
                TextFormField(
                  controller: passwordController,

                  obscureText: obscurePassword,

                  decoration: InputDecoration(
                    labelText: "Password",

                    hintText: "Enter password",

                    prefixIcon: const Icon(Icons.lock_outline),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),

                    filled: true,

                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),

                      borderSide: BorderSide.none,
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // =========================
                // REGISTER BUTTON
                // =========================
                SizedBox(
                  width: double.infinity,

                  height: 58,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // LOGIN
                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[600]),
                    ),

                    TextButton(
                      onPressed: () {
                        context.go("/login");
                      },

                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // REUSABLE FIELD
  // =========================

  Widget _buildTextField({
    required TextEditingController controller,

    required String label,

    required String hint,

    required IconData icon,

    TextInputType keyboardType = TextInputType.text,

    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboardType,

      decoration: InputDecoration(
        labelText: label,

        hintText: hint,

        prefixIcon: Icon(icon),

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
        ),
      ),

      validator: validator,
    );
  }
}
