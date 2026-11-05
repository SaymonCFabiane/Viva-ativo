import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/notification_item.dart';

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationItem>>(
        NotificationsNotifier.new);

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});

class NotificationsNotifier extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() => _mockNotifications;

  void markAsRead(String id) {
    state = state.map((n) {
      if (n.id != id) return n;
      return n.copyWith(isRead: true);
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  static const _mockNotifications = [
    NotificationItem(
      id: 'n1',
      title: 'Lembrete: Bocha amanhã!',
      message: 'Você confirmou participação na Bocha. '
          'Não esqueça — amanhã às 8h no Centro Comunitário Vila Nova.',
      timeAgo: 'Agora',
      type: NotificationType.reminder,
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Dona Rosa enviou uma mensagem',
      message: 'Oi! Que bom falar com você! 😊',
      timeAgo: 'Há 2 horas',
      type: NotificationType.message,
      isRead: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Novo evento: Coral dos Idosos',
      message: 'Uma nova atividade cultural foi adicionada na sua região. '
          'Sábados às 16h na Casa da Cultura.',
      timeAgo: 'Há 5 horas',
      type: NotificationType.event,
      isRead: false,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Seu José está interessado em Baralho',
      message: 'Seu amigo Seu José marcou interesse na atividade Baralho '
          'na próxima Quarta-feira.',
      timeAgo: 'Ontem',
      type: NotificationType.message,
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      title: 'Lembrete: Dança de Salão hoje!',
      message: 'A Dança de Salão começa em 1 hora — '
          'às 14h no Salão de Festas Alegria.',
      timeAgo: 'Ontem',
      type: NotificationType.reminder,
      isRead: true,
    ),
    NotificationItem(
      id: 'n6',
      title: 'Novidade: Yoga para Idosos',
      message: 'Uma nova turma de Yoga foi aberta especialmente para '
          'maiores de 60 anos. Segundas e Quartas, 7h.',
      timeAgo: 'Há 2 dias',
      type: NotificationType.news,
      isRead: true,
    ),
    NotificationItem(
      id: 'n7',
      title: 'Dona Clara curtiu seu interesse',
      message: 'Dona Clara também confirmou presença na Pintura em Tela '
          'do próximo Sábado.',
      timeAgo: 'Há 3 dias',
      type: NotificationType.message,
      isRead: true,
    ),
  ];
}
