import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/habits_provider.dart';

/// Bottom sheet for adding a new habit/routine.
class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _titleController = TextEditingController();
  final _timeController = TextEditingController(text: '8:00 AM');
  String _selectedRecurrence = 'Daily';

  static const _recurrenceOptions = [
    'Daily',
    'Weekdays',
    'Mon, Wed, Fri',
    'Tue, Thu, Sat',
    'Weekends',
    'One-off',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle.
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Add New Routine',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 20),

          // Title input.
          TextField(
            controller: _titleController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Routine Name',
              labelStyle: TextStyle(color: AppColors.onSurfaceVariant),
              filled: true,
              fillColor: AppColors.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time input.
          TextField(
            controller: _timeController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Scheduled Time',
              labelStyle: TextStyle(color: AppColors.onSurfaceVariant),
              prefixIcon: const Icon(
                Icons.schedule,
                color: AppColors.onSurfaceVariant,
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recurrence selector.
          Text(
            'RECURRENCE',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recurrenceOptions.map((option) {
              final isSelected = _selectedRecurrence == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => _selectedRecurrence = option),
                selectedColor: AppColors.primaryContainer,
                backgroundColor: AppColors.surfaceContainerHigh,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.glassBorder,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Submit button.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: const Text('Add Routine'),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    context.read<HabitsProvider>().addHabit(
          title: title,
          scheduledTime: _timeController.text.trim(),
          recurrence: _selectedRecurrence,
        );

    Navigator.pop(context);
  }
}
