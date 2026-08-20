import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../shell/main_navigation_shell.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Build a better workflow, one task at a time.',
                    style: TextStyle(
                      color: AppColors.textMutedLight,
                      fontSize: 13.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  if (authState.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.urgentBg,
                        border: Border.all(color: AppColors.urgentText.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.urgentText, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: const TextStyle(color: AppColors.urgentText, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Full Name
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Petros Sisay',
                    controller: _nameController,
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Full name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  CustomTextField(
                    label: 'Email',
                    hint: 'you@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Email is required';
                      if (!val.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    label: 'Password',
                    hint: 'At least 6 characters',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Password is required';
                      if (val.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  CustomButton(
                    text: 'Create Account',
                    isLoading: authState.status == AuthStatus.loading,
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 20),

                  // Switch to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppColors.textMutedLight, fontSize: 13.5),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
