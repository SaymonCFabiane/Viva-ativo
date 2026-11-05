import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../domain/models/event.dart';

class InterestCalendarSheet extends StatefulWidget {
  const InterestCalendarSheet({
    super.key,
    required this.event,
    required this.onConfirm,
  });

  final Event event;
  final void Function(List<DateTime> selectedDays) onConfirm;

  @override
  State<InterestCalendarSheet> createState() => _InterestCalendarSheetState();
}

class _InterestCalendarSheetState extends State<InterestCalendarSheet> {
  late DateTime _focusedMonth;
  final Set<DateTime> _selected = {};
  late final Set<int> _enabledWeekdays;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _enabledWeekdays = _parseWeekdays(widget.event.schedule);
  }

  static Set<int> _parseWeekdays(String schedule) {
    if (schedule.toLowerCase().contains('diariamente')) {
      return {1, 2, 3, 4, 5, 6, 7};
    }
    final result = <int>{};
    if (schedule.contains('Seg')) result.add(DateTime.monday);
    if (schedule.contains('Terç')) result.add(DateTime.tuesday);
    if (schedule.contains('Quar')) result.add(DateTime.wednesday);
    if (schedule.contains('Quin')) result.add(DateTime.thursday);
    if (schedule.contains('Sex')) result.add(DateTime.friday);
    if (schedule.contains('Sáb')) result.add(DateTime.saturday);
    if (schedule.contains('Dom')) result.add(DateTime.sunday);
    return result.isEmpty ? {1, 2, 3, 4, 5, 6, 7} : result;
  }

  void _previousMonth() => setState(() {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      });

  bool _isEnabled(DateTime day) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    if (day.isBefore(todayNormalized)) return false;
    return _enabledWeekdays.contains(day.weekday);
  }

  bool _isSelected(DateTime day) => _selected.contains(day);

  void _toggleDay(DateTime day) {
    if (!_isEnabled(day)) return;
    setState(() {
      if (_selected.contains(day)) {
        _selected.remove(day);
      } else {
        _selected.add(day);
      }
    });
  }

  String _monthName(int month) {
    const names = [
      '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return names[month];
  }

  String _weekdayName(int wd) {
    const names = ['', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return names[wd];
  }

  List<DateTime?> _buildMonthGrid() {
    // First day of the focused month
    final first = _focusedMonth;
    // weekday 1=Mon..7=Sun; shift so Sunday is index 0 in the grid
    // We display: Dom Seg Ter Qua Qui Sex Sáb  (Sunday first)
    int startOffset = (first.weekday % 7); // Mon→1%7=1, Sun→7%7=0
    final daysInMonth = DateUtils.getDaysInMonth(first.year, first.month);
    final cells = <DateTime?>[
      ...List<DateTime?>.filled(startOffset, null),
      ...List.generate(daysInMonth, (i) => DateTime(first.year, first.month, i + 1)),
    ];
    // pad to full rows
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final grid = _buildMonthGrid();
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Quando você quer participar?',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              widget.event.schedule,
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.orange),
            ),
            const SizedBox(height: 16),
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: _previousMonth,
                ),
                Text(
                  '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            // Weekday headers (Dom-Sáb)
            Row(
              children: [7, 1, 2, 3, 4, 5, 6].map((wd) {
                final isActive = _enabledWeekdays.contains(wd);
                return Expanded(
                  child: Center(
                    child: Text(
                      _weekdayName(wd),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isActive ? AppColors.orange : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: grid.length,
              itemBuilder: (_, i) {
                final day = grid[i];
                if (day == null) return const SizedBox();
                final enabled = _isEnabled(day);
                final selected = _isSelected(day);
                return GestureDetector(
                  onTap: () => _toggleDay(day),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? AppColors.orange
                          : enabled
                              ? AppColors.orange.withValues(alpha: 0.1)
                              : Colors.transparent,
                      border: enabled && !selected
                          ? Border.all(color: AppColors.orange.withValues(alpha: 0.4))
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          color: selected
                              ? Colors.white
                              : enabled
                                  ? AppColors.orange
                                  : AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            if (_selected.isNotEmpty)
              Text(
                '${_selected.length} dia(s) selecionado(s)',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.green),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected.isEmpty
                    ? null
                    : () {
                        widget.onConfirm(_selected.toList()..sort());
                        Navigator.of(context).pop();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.divider,
                ),
                child: const Text('Confirmar Participação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
