import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/chat_message.dart';

final chatProvider =
    NotifierProvider<ChatNotifier, Map<String, List<ChatMessage>>>(
        ChatNotifier.new);

class ChatNotifier extends Notifier<Map<String, List<ChatMessage>>> {
  @override
  Map<String, List<ChatMessage>> build() => {};

  void sendMessage(String contactName, String text) {
    _addMessage(contactName, text, isMe: true);
    Future.delayed(const Duration(milliseconds: 900), () {
      _addMessage(contactName, _autoReply(), isMe: false);
    });
  }

  void _addMessage(String contactName, String text, {required bool isMe}) {
    final current = {
      ...state.map((k, v) => MapEntry(k, List<ChatMessage>.from(v))),
    };
    current[contactName] = [
      ...(current[contactName] ?? []),
      ChatMessage(text: text, isMe: isMe, timestamp: DateTime.now()),
    ];
    state = current;
  }

  String _autoReply() {
    const replies = [
      'Oi! Que bom falar com você! 😊',
      'Olá! Como você está?',
      'Que saudade! Quando nos encontramos?',
      'Tudo bem sim, obrigado! E você? 💙',
      'Vejo você na atividade esta semana!',
    ];
    return replies[DateTime.now().millisecondsSinceEpoch % replies.length];
  }
}
