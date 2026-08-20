import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class ChangePasswordDialog extends StatefulWidget {
  final Future<bool> Function(String currentPass, String newPass) onChangePassword;

  const ChangePasswordDialog({super.key, required this.onChangePassword});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newController.text != _confirmController.text) {
      setState(() => _errorMsg = 'New passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final success = await widget.onChangePassword(
      _currentController.text,
      _newController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _errorMsg = 'Failed to change password. Check your current password.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w800)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.urgentBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMsg!,
                    style: const TextStyle(color: AppColors.urgentText, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              CustomTextField(
                label: 'Current Password',
                controller: _currentController,
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'New Password',
                controller: _newController,
                obscureText: true,
                validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Confirm New Password',
                controller: _confirmController,
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: 'Update',
          width: 110,
          isLoading: _isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
