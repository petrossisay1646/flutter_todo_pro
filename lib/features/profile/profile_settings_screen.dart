import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/storage_provider.dart';
import '../../providers/theme_provider.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../auth/login_screen.dart';
import 'widgets/change_password_dialog.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _nameController = TextEditingController();
  final _dailyGoalController = TextEditingController();
  final _pomodoroDurationController = TextEditingController();
  final _apiUrlController = TextEditingController();

  String _selectedAvatarColor = '#564CFF';
  bool _isSaving = false;

  final List<String> _avatarColors = [
    '#564CFF',
    '#10B981',
    '#F59E0B',
    '#EF4444',
    '#8B5CF6',
    '#06B6D4',
    '#EC4899',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    final storage = ref.read(storageServiceProvider);

    _nameController.text = user?.name ?? '';
    _dailyGoalController.text = '${user?.dailyGoal ?? 5}';
    _pomodoroDurationController.text = '${user?.pomodoroLength ?? 25}';
    _selectedAvatarColor = user?.avatarColor ?? '#564CFF';
    _apiUrlController.text = storage.getCustomApiUrl() ?? ApiConstants.defaultBaseUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dailyGoalController.dispose();
    _pomodoroDurationController.dispose();
    _apiUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    final success = await ref.read(authProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          dailyGoal: int.tryParse(_dailyGoalController.text) ?? 5,
          pomodoroLength: int.tryParse(_pomodoroDurationController.text) ?? 25,
          avatarColor: _selectedAvatarColor,
        );

    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Profile updated successfully!' : 'Failed to update profile'),
          backgroundColor: success ? AppColors.success : AppColors.danger,
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out of your workspace?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final themeMode = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Preview & Color Customizer
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: _parseHexColor(_selectedAvatarColor),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _parseHexColor(_selectedAvatarColor).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textMutedLight),
                    ),
                    const SizedBox(height: 14),

                    // Color palette
                    Wrap(
                      spacing: 8,
                      children: _avatarColors.map((hex) {
                        final isSelected = _selectedAvatarColor == hex;
                        final color = _parseHexColor(hex);
                        return GestureDetector(
                          onTap: () => setState(() => _selectedAvatarColor = hex),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: isDark ? Colors.white : Colors.black87, width: 2.5)
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Profile Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile Preferences',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Full Name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Daily Task Goal',
                            hint: '5',
                            controller: _dailyGoalController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Pomodoro (min)',
                            hint: '25',
                            controller: _pomodoroDurationController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Save Preferences',
                      isLoading: _isSaving,
                      onPressed: _saveProfile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Theme Selector Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appearance Mode',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ThemeOptionCard(
                            title: 'Light',
                            icon: Icons.light_mode_rounded,
                            isSelected: themeMode == ThemeMode.light,
                            onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ThemeOptionCard(
                            title: 'Dark',
                            icon: Icons.dark_mode_rounded,
                            isSelected: themeMode == ThemeMode.dark,
                            onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ThemeOptionCard(
                            title: 'System',
                            icon: Icons.settings_brightness_rounded,
                            isSelected: themeMode == ThemeMode.system,
                            onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.system),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Security & Actions Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                      title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => ChangePasswordDialog(
                            onChangePassword: (curr, next) =>
                                ref.read(authProvider.notifier).changePassword(curr, next),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.link_rounded, color: AppColors.info),
                      title: const Text('Backend API Endpoint', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      subtitle: Text(
                        _apiUrlController.text,
                        style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.edit_outlined, size: 18),
                      onTap: () => _showApiUrlDialog(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Logout Button
              CustomButton(
                text: 'Sign Out',
                icon: Icons.logout_rounded,
                isOutlined: true,
                textColor: AppColors.danger,
                backgroundColor: AppColors.danger,
                onPressed: _handleLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApiUrlDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom API URL', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Switch between live Render cloud API and local Android Emulator / iOS Simulator API:',
              style: TextStyle(fontSize: 12.5, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _apiUrlController,
              decoration: const InputDecoration(
                hintText: 'https://mern-todo-pro.onrender.com/api',
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: [
                ActionChip(
                  label: const Text('Render Cloud', style: TextStyle(fontSize: 11)),
                  onPressed: () => setState(() => _apiUrlController.text = ApiConstants.defaultBaseUrl),
                ),
                ActionChip(
                  label: const Text('Android (10.0.2.2)', style: TextStyle(fontSize: 11)),
                  onPressed: () => setState(() => _apiUrlController.text = ApiConstants.localAndroidEmulatorUrl),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newUrl = _apiUrlController.text.trim();
              await ref.read(storageServiceProvider).setCustomApiUrl(newUrl);
              ref.read(apiClientProvider).updateBaseUrl(newUrl);
              if (mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API URL updated!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkElevated : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : (isDark ? AppColors.textMainDark : AppColors.textMainLight)),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : (isDark ? AppColors.textMainDark : AppColors.textMainLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
