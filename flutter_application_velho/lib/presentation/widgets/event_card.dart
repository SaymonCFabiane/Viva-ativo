import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../domain/models/event.dart';
import '../../providers/events_provider.dart';
import 'directions_sheet.dart';
import 'interest_calendar_sheet.dart';

class EventCard extends ConsumerWidget {
  const EventCard({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(event.title, style: theme.textTheme.titleMedium),
                ),
                _CategoryBadge(category: event.category),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(icon: Icons.location_on_rounded, text: event.location),
            const SizedBox(height: 4),
            _InfoRow(icon: Icons.home_rounded, text: event.address),
            const SizedBox(height: 4),
            _InfoRow(icon: Icons.schedule_rounded, text: event.schedule),
            if (event.interestedFriends.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.people_rounded,
                        size: 16, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: event.interestedFriends.map((name) {
                        return GestureDetector(
                          onTap: () => context
                              .push('/chat/${Uri.encodeComponent(name)}'),
                          child: Text(
                            name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.blue,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (event.isInterested) {
                        ref.read(eventsProvider.notifier).removeInterest(event.id);
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => InterestCalendarSheet(
                            event: event,
                            onConfirm: (_) => ref
                                .read(eventsProvider.notifier)
                                .addInterested(event.id),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      event.isInterested
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20,
                    ),
                    label: Text(
                      event.isInterested ? 'Interessado ✓' : 'Tenho Interesse',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          event.isInterested ? AppColors.green : AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => DirectionsSheet(event: event),
                  ),
                  icon: const Icon(Icons.directions_rounded, size: 20),
                  label: const Text('Como Chegar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blue,
                    side: const BorderSide(color: AppColors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
            if (!event.isInterested) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    ref.read(eventsProvider.notifier).removeEvent(event.id);
                  },
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('Não Tenho Interesse'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final EventCategory category;

  Color get _color => switch (category) {
        EventCategory.todos => AppColors.blue,
        EventCategory.esportes => AppColors.green,
        EventCategory.lazer => AppColors.purple,
        EventCategory.cultura => AppColors.orange,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.label,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _color),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
