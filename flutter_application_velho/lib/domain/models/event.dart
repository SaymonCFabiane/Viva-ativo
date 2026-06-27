enum EventCategory { todos, esportes, lazer, cultura }

extension EventCategoryLabel on EventCategory {
  String get label => switch (this) {
        EventCategory.todos => 'Todos',
        EventCategory.esportes => 'Esportes',
        EventCategory.lazer => 'Lazer',
        EventCategory.cultura => 'Cultura',
      };
}

class Event {
  final String id;
  final String title;
  final String location;
  final String address;
  final String schedule;
  final EventCategory category;
  final List<String> interestedFriends;
  final bool isInterested;

  const Event({
    required this.id,
    required this.title,
    required this.location,
    required this.address,
    required this.schedule,
    required this.category,
    this.interestedFriends = const [],
    this.isInterested = false,
  });

  Event copyWith({
    String? id,
    String? title,
    String? location,
    String? address,
    String? schedule,
    EventCategory? category,
    List<String>? interestedFriends,
    bool? isInterested,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      address: address ?? this.address,
      schedule: schedule ?? this.schedule,
      category: category ?? this.category,
      interestedFriends: interestedFriends ?? this.interestedFriends,
      isInterested: isInterested ?? this.isInterested,
    );
  }
}
