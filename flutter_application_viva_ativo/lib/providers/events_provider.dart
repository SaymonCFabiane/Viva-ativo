import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/event.dart';

final selectedCategoryProvider = StateProvider<EventCategory>((ref) => EventCategory.todos);

final eventsProvider = AsyncNotifierProvider<EventsNotifier, List<Event>>(EventsNotifier.new);

class EventsNotifier extends AsyncNotifier<List<Event>> {
  @override
  Future<List<Event>> build() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockEvents;
  }

  void toggleInterested(String eventId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.map((e) {
        if (e.id != eventId) return e;
        return e.copyWith(isInterested: !e.isInterested);
      }).toList(),
    );
  }

  void addInterested(String eventId, {String userName = 'Você'}) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.map((e) {
        if (e.id != eventId) return e;
        final friends = [...e.interestedFriends];
        if (!friends.contains(userName)) friends.add(userName);
        return e.copyWith(isInterested: true, interestedFriends: friends);
      }).toList(),
    );
  }

  void removeInterest(String eventId, {String userName = 'Você'}) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.map((e) {
        if (e.id != eventId) return e;
        final updatedFriends =
            e.interestedFriends.where((f) => f != userName).toList();
        return e.copyWith(isInterested: false, interestedFriends: updatedFriends);
      }).toList(),
    );
  }

  void removeEvent(String eventId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.where((e) => e.id != eventId).toList());
  }

  static const _mockEvents = [
    Event(
      id: '1',
      title: 'Bocha',
      location: 'Centro Comunitário Vila Nova',
      address: 'Rua das Flores, 123 — Vila Nova',
      schedule: 'Terças e Quintas, 8h às 10h',
      category: EventCategory.esportes,
      interestedFriends: ['Dona Rosa', 'Seu José'],
    ),
    Event(
      id: '2',
      title: 'Dança de Salão',
      location: 'Salão de Festas Alegria',
      address: 'Av. Principal, 456 — Centro',
      schedule: 'Sextas, 14h às 16h',
      category: EventCategory.lazer,
      interestedFriends: ['Dona Clara'],
    ),
    Event(
      id: '3',
      title: 'Baralho',
      location: 'Clube dos Idosos',
      address: 'Rua do Parque, 789 — Jardim',
      schedule: 'Diariamente, 15h às 17h',
      category: EventCategory.lazer,
      interestedFriends: ['Dona Rosa', 'Dona Clara', 'Seu José'],
    ),
    Event(
      id: '4',
      title: 'Dominó',
      location: 'Clube dos Aposentados',
      address: 'Av. dos Ipês, 210 — Centro',
      schedule: 'Segundas e Quartas, 14h às 16h',
      category: EventCategory.lazer,
      interestedFriends: ['Seu José', 'Dona Rosa'],
    ),
    Event(
      id: '5',
      title: 'Bingo',
      location: 'Salão Paroquial São Pedro',
      address: 'Rua da Igreja, 55 — Centro',
      schedule: 'Sextas, 19h às 21h',
      category: EventCategory.lazer,
      interestedFriends: ['Dona Clara'],
    ),
    Event(
      id: '6',
      title: 'Xadrez',
      location: 'Biblioteca Municipal',
      address: 'Rua das Letras, 320 — Centro',
      schedule: 'Terças e Quintas, 10h às 12h',
      category: EventCategory.cultura,
      interestedFriends: ['Seu José'],
    ),
    Event(
      id: '7',
      title: 'Damas',
      location: 'Associação dos Aposentados',
      address: 'Rua Sete de Setembro, 88 — Bairro Novo',
      schedule: 'Segundas, Quartas e Sextas, 9h às 11h',
      category: EventCategory.lazer,
      interestedFriends: ['Dona Rosa', 'Dona Clara'],
    ),
    Event(
      id: '8',
      title: 'Caminhada',
      location: 'Parque Municipal Verde Vida',
      address: 'Av. das Araucárias, s/n — Parque',
      schedule: 'Diariamente, 6h às 7h30',
      category: EventCategory.esportes,
      interestedFriends: ['Dona Rosa'],
    ),
    Event(
      id: '9',
      title: 'Natação',
      location: 'SESC Centro',
      address: 'Rua Coronel Olivério, 140 — Centro',
      schedule: 'Terças, Quintas e Sábados, 7h às 8h',
      category: EventCategory.esportes,
      interestedFriends: ['Dona Clara', 'Seu José'],
    ),
    Event(
      id: '10',
      title: 'Hidroginástica',
      location: 'Centro Aquático Municipal',
      address: 'Rua do Lago, 500 — Vila Esperança',
      schedule: 'Segundas e Quartas, 9h às 10h',
      category: EventCategory.esportes,
      interestedFriends: ['Dona Rosa'],
    ),
    Event(
      id: '11',
      title: 'Pintura em Tela',
      location: 'Casa da Cultura',
      address: 'Praça Central, 1 — Centro Histórico',
      schedule: 'Sábados, 14h às 17h',
      category: EventCategory.cultura,
      interestedFriends: ['Dona Clara', 'Dona Rosa'],
    ),
    Event(
      id: '12',
      title: 'Tricô e Crochê',
      location: 'Associação das Mulheres',
      address: 'Rua das Oliveiras, 33 — Jardim',
      schedule: 'Quartas, 13h às 15h',
      category: EventCategory.cultura,
      interestedFriends: ['Dona Clara'],
    ),
    Event(
      id: '13',
      title: 'Jardinagem',
      location: 'Horta Comunitária do Bairro',
      address: 'Rua das Hortências, 200 — Vila Nova',
      schedule: 'Sábados e Domingos, 8h às 10h',
      category: EventCategory.lazer,
      interestedFriends: ['Dona Rosa', 'Seu José'],
    ),
  ];
}
