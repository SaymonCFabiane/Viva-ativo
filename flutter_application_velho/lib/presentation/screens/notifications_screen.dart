import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../domain/models/notification_item.dart';
import '../../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    final hasUnread = notifications.any((n) => !n.isRead);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Notificações'),
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: notifier.markAllAsRead,
              child: const Text(
                'Marcar todas',
                style: TextStyle(color: AppColors.orange, fontSize: 15),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (_, i) => _NotificationTile(
                item: notifications[i],
                onTap: () => notifier.markAsRead(notifications[i].id),
              ),
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});
  final NotificationItem item;
  final VoidCallback onTap;

  static IconData _iconFor(NotificationType type) => switch (type) {
        NotificationType.reminder => Icons.alarm_rounded,
        NotificationType.message => Icons.message_rounded,
        NotificationType.event => Icons.event_rounded,
        NotificationType.news => Icons.campaign_rounded,
      };

  static Color _colorFor(NotificationType type) => switch (type) {
        NotificationType.reminder => AppColors.orange,
        NotificationType.message => AppColors.blue,
        NotificationType.event => AppColors.green,
        NotificationType.news => AppColors.purple,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorFor(item.type);
    final icon = _iconFor(item.type);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: item.isRead
            ? Colors.transparent
            : AppColors.blue.withValues(alpha: 0.04),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone colorido
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: item.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Ponto indicador de não lido
                      if (!item.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: item.isRead
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: item.isRead
                          ? AppColors.textSecondary
                          : AppColors.blue,
                      fontWeight: item.isRead
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 72,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
