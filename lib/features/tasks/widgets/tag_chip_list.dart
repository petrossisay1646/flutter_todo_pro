import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TagChipList extends StatelessWidget {
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  const TagChipList({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tags.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isAllSelected = selectedTag == 'all';
            return _MiniTagChip(
              label: 'All Tags',
              isSelected: isAllSelected,
              onTap: () => onTagSelected('all'),
            );
          }

          final tag = tags[index - 1];
          final isSelected = selectedTag == tag;
          return _MiniTagChip(
            label: '#$tag',
            isSelected: isSelected,
            onTap: () => onTagSelected(isSelected ? 'all' : tag),
          );
        },
      ),
    );
  }
}

class _MiniTagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MiniTagChip({
    required this.label,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.primaryDark : AppColors.primaryLight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFFA59EFF) : AppColors.primary),
          ),
        ),
      ),
    );
  }
}
