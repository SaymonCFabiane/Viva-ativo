import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../domain/models/event.dart';
import '../../providers/events_provider.dart';
import '../../providers/notifications_provider.dart';
import '../widgets/event_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos para Você'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Badge(
              isLabelVisible: ref.watch(unreadCountProvider) > 0,
              label: Text('${ref.watch(unreadCountProvider)}'),
              backgroundColor: AppColors.red,
              child: IconButton(
                icon: const Icon(Icons.notifications_rounded,
                    color: AppColors.orange, size: 28),
                tooltip: 'Notificações',
                onPressed: () => context.push('/notifications'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _CategoryFilter(
            selected: selectedCategory,
            onSelect: (cat) =>
                ref.read(selectedCategoryProvider.notifier).state = cat,
          ),
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro ao carregar eventos: $e')),
              data: (events) {
                final filtered = selectedCategory == EventCategory.todos
                    ? events
                    : events.where((e) => e.category == selectedCategory).toList();
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum evento nessa categoria.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => EventCard(event: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onSelect});
  final EventCategory selected;
  final void Function(EventCategory) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: EventCategory.values.map((cat) {
            final isSelected = cat == selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat.label),
                selected: isSelected,
                onSelected: (_) => onSelect(cat),
                selectedColor: AppColors.orange,
                backgroundColor: AppColors.divider,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                checkmarkColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
