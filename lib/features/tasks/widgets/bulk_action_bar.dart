import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BulkActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClear;
  final ValueChanged<bool> onBulkComplete;
  final VoidCallback onBulkDelete;
  final ValueChanged<String> onBulkPriority;

  const BulkActionBar({
    super.key,
    required this.selectedCount,
    required this.onClear,
    required this.onBulkComplete,
    required this.onBulkDelete,
    required this.onBulkPriority,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$selectedCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$selectedCount selected',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          // Complete
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 22),
            onPressed: () => onBulkComplete(true),
            tooltip: 'Mark Completed',
          ),
          // Change Priority
          PopupMenuButton<String>(
            icon: const Icon(Icons.flag_outlined, color: AppColors.warning, size: 22),
            tooltip: 'Set Priority',
            onSelected: onBulkPriority,
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'urgent', child: Text('🔴 Urgent')),
              const PopupMenuItem(value: 'high', child: Text('🟠 High')),
              const PopupMenuItem(value: 'medium', child: Text('🟡 Medium')),
              const PopupMenuItem(value: 'low', child: Text('🟢 Low')),
            ],
          ),
          // Delete
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 22),
            onPressed: onBulkDelete,
            tooltip: 'Delete Selected',
          ),
          // Clear
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70, size: 20),
            onPressed: onClear,
            tooltip: 'Clear Selection',
          ),
        ],
      ),
    );
  }
}
