import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../providers/contacts_provider.dart';
import '../widgets/contact_card.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final family = ref.watch(familyContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Minha Família')),
      body: family.isEmpty
          ? const Center(child: Text('Nenhum familiar cadastrado.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: family.length,
              itemBuilder: (_, i) => ContactCard(
                contact: family[i],
                avatarColor: AppColors.blue,
              ),
            ),
    );
  }
}
