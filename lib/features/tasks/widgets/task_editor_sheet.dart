import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/subtask_model.dart';
import '../../../data/models/todo_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class TaskEditorSheet extends StatefulWidget {
  final TodoModel? task;
  final String? defaultStatus;
  final ValueChanged<TodoModel> onSave;

  const TaskEditorSheet({
    super.key,
    this.task,
    this.defaultStatus,
    required this.onSave,
  });

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late TextEditingController _tagInputController;
  late TextEditingController _subtaskInputController;
  late TextEditingController _estMinutesController;

  late String _priority;
  late String _status;
  late bool _pinned;
  late bool _completed;
  DateTime? _dueDate;
  late List<String> _tags;
  late List<SubtaskModel> _subtasks;

  final List<String> _popularTags = ['urgent', 'bug', 'feature', 'meeting', 'review', 'design'];

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _categoryController = TextEditingController(text: t?.category ?? 'General');
    _tagInputController = TextEditingController();
    _subtaskInputController = TextEditingController();
    _estMinutesController = TextEditingController(text: '${t?.estimatedMinutes ?? 30}');

    _priority = t?.priority ?? 'medium';
    _status = t?.status ?? (widget.defaultStatus ?? 'todo');
    _pinned = t?.pinned ?? false;
    _completed = t?.completed ?? false;
    _dueDate = t?.dueDate;
    _tags = t != null ? List<String>.from(t.tags) : [];
    _subtasks = t != null ? List<SubtaskModel>.from(t.subtasks) : [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _tagInputController.dispose();
    _subtaskInputController.dispose();
    _estMinutesController.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _subtaskInputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _subtasks.add(SubtaskModel(title: text, completed: false));
      _subtaskInputController.clear();
    });
  }

  void _addTag(String tag) {
    final clean = tag.trim().replaceAll(RegExp(r'^#'), '').toLowerCase();
    if (clean.isNotEmpty && !_tags.contains(clean)) {
      setState(() {
        _tags.add(clean);
        _tagInputController.clear();
      });
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final updated = TodoModel(
      id: widget.task?.id ?? '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      status: _status,
      category: _categoryController.text.trim().isEmpty ? 'General' : _categoryController.text.trim(),
      tags: _tags,
      pinned: _pinned,
      completed: _status == 'completed' || _completed,
      estimatedMinutes: int.tryParse(_estMinutesController.text) ?? 0,
      subtasks: _subtasks,
      dueDate: _dueDate,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.task != null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Task' : 'Create New Task',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Task Title
              CustomTextField(
                label: 'Task Title *',
                hint: 'e.g. Finish quarterly project proposal',
                controller: _titleController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Title is required';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Description
              CustomTextField(
                label: 'Description & Notes',
                hint: 'Add acceptance criteria, links, or notes...',
                controller: _descController,
                maxLines: 3,
              ),
              const SizedBox(height: 18),

              // Subtasks Section
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkElevated : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_box_outlined, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        const Text(
                          'Subtasks Checklist',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        const Spacer(),
                        if (_subtasks.isNotEmpty)
                          Text(
                            '${_subtasks.where((s) => s.completed).length}/${_subtasks.length}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                      ],
                    ),
                    if (_subtasks.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      ..._subtasks.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final st = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: st.completed,
                                  onChanged: (val) {
                                    setState(() {
                                      _subtasks[idx] = st.copyWith(completed: val ?? false);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  st.title,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    decoration: st.completed ? TextDecoration.lineThrough : null,
                                    color: st.completed ? AppColors.textMutedLight : null,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.danger),
                                onPressed: () {
                                  setState(() => _subtasks.removeAt(idx));
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _subtaskInputController,
                            decoration: const InputDecoration(
                              hintText: 'Add a subtask step...',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onSubmitted: (_) => _addSubtask(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _addSubtask,
                          icon: const Icon(Icons.add, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tags Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tags', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ..._tags.map(
                        (t) => Chip(
                          label: Text('#$t', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                          onDeleted: () => setState(() => _tags.remove(t)),
                          deleteIconColor: AppColors.primary,
                          backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                          labelStyle: TextStyle(color: isDark ? const Color(0xFFA59EFF) : AppColors.primary),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagInputController,
                          decoration: const InputDecoration(
                            hintText: 'Type tag and press Add...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onSubmitted: (val) => _addTag(val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _addTag(_tagInputController.text),
                        child: const Text('Add Tag'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: _popularTags.where((pt) => !_tags.contains(pt)).map((pt) {
                      return ActionChip(
                        label: Text('+$pt', style: const TextStyle(fontSize: 10.5)),
                        onPressed: () => _addTag(pt),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Priority & Status Grid
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Priority', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _priority,
                          items: const [
                            DropdownMenuItem(value: 'urgent', child: Text('🔴 Urgent')),
                            DropdownMenuItem(value: 'high', child: Text('🟠 High')),
                            DropdownMenuItem(value: 'medium', child: Text('🟡 Medium')),
                            DropdownMenuItem(value: 'low', child: Text('🟢 Low')),
                          ],
                          onChanged: (val) => setState(() => _priority = val ?? 'medium'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Stage / Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          items: const [
                            DropdownMenuItem(value: 'todo', child: Text('📋 To Do')),
                            DropdownMenuItem(value: 'in-progress', child: Text('⚡ In Progress')),
                            DropdownMenuItem(value: 'completed', child: Text('✅ Completed')),
                          ],
                          onChanged: (val) => setState(() => _status = val ?? 'todo'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category & Due Date
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Category',
                      hint: 'Work',
                      controller: _categoryController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Due Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _pickDueDate,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0D1423) : const Color(0xFFF9FBFD),
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  _dueDate != null ? DateFormatter.formatShort(_dueDate) : 'Pick Date',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Pin to top & Estimated Minutes
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Est. Duration (min)',
                      hint: '30',
                      controller: _estMinutesController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pin Task', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Checkbox(
                              value: _pinned,
                              onChanged: (val) => setState(() => _pinned = val ?? false),
                            ),
                            const Text('Pin to top', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save Button
              CustomButton(
                text: isEditing ? 'Save Changes' : 'Create Task',
                icon: Icons.check,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
