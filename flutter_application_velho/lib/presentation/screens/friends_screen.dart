import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../providers/contacts_provider.dart';
import '../widgets/contact_card.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friends = ref.watch(friendContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Amigos')),
      body: friends.isEmpty
          ? const Center(child: Text('Nenhum amigo cadastrado.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: friends.length,
              itemBuilder: (_, i) => ContactCard(
                contact: friends[i],
                avatarColor: AppColors.green,
              ),
            ),
    );
  }
}
