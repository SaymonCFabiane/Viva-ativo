import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/contact.dart';

final familyContactsProvider =
    NotifierProvider<FamilyContactsNotifier, List<Contact>>(FamilyContactsNotifier.new);

final friendContactsProvider =
    NotifierProvider<FriendContactsNotifier, List<Contact>>(FriendContactsNotifier.new);

class FamilyContactsNotifier extends Notifier<List<Contact>> {
  @override
  List<Contact> build() => _family;

  static const _family = [
    Contact(id: 'f1', name: 'Maria', phone: '(11) 99999-1111', relationship: 'Filha', emoji: '👩'),
    Contact(id: 'f2', name: 'João', phone: '(11) 99999-2222', relationship: 'Filho', emoji: '👨'),
    Contact(id: 'f3', name: 'Ana', phone: '(11) 99999-3333', relationship: 'Neta', emoji: '👧'),
  ];
}

class FriendContactsNotifier extends Notifier<List<Contact>> {
  @override
  List<Contact> build() => _friends;

  static const _friends = [
    Contact(id: 'a1', name: 'Dona Rosa', phone: '(11) 98888-1111', relationship: 'Amiga', emoji: '🌹'),
    Contact(id: 'a2', name: 'Seu José', phone: '(11) 98888-2222', relationship: 'Amigo', emoji: '👴'),
    Contact(id: 'a3', name: 'Dona Clara', phone: '(11) 98888-3333', relationship: 'Amiga', emoji: '🌸'),
  ];
}
