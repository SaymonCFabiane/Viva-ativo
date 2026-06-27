import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../core/phone_launcher.dart';
import '../../domain/models/contact.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
    this.avatarColor = AppColors.blue,
  });

  final Contact contact;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: avatarColor.withValues(alpha: 0.15),
              child: Text(contact.emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(contact.relationship,
                      style: theme.textTheme.bodySmall?.copyWith(color: avatarColor)),
                  const SizedBox(height: 2),
                  Text(contact.phone, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: Icons.phone_rounded,
                  color: AppColors.green,
                  tooltip: 'Ligar',
                  onTap: () => launchPhone(contact.phone),
                ),
                const SizedBox(height: 4),
                _ActionButton(
                  icon: Icons.message_rounded,
                  color: AppColors.blue,
                  tooltip: 'Mensagem',
                  onTap: () => context
                      .push('/chat/${Uri.encodeComponent(contact.name)}'),
                ),
                const SizedBox(height: 4),
                _ActionButton(
                  icon: Icons.chat_rounded,
                  color: const Color(0xFF25D366),
                  tooltip: 'WhatsApp',
                  onTap: () => launchWhatsApp(contact.phone),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
      ),
    );
  }
}
