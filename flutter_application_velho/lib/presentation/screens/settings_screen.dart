import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          _SectionHeader('Acessibilidade'),
          ListTile(
            leading: const Icon(Icons.text_fields_rounded, size: 28),
            title: const Text('Tamanho do Texto'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(settings.textScale * 100).round()}%',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.orange),
                ),
                Slider(
                  value: settings.textScale,
                  min: 0.8,
                  max: 1.6,
                  divisions: 8,
                  label: '${(settings.textScale * 100).round()}%',
                  onChanged: notifier.updateTextScale,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up_rounded, size: 28),
            title: const Text('Volume'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(settings.volume * 100).round()}%',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.orange),
                ),
                Slider(
                  value: settings.volume,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: '${(settings.volume * 100).round()}%',
                  onChanged: notifier.updateVolume,
                ),
              ],
            ),
          ),
          const Divider(),
          _SectionHeader('Notificações'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_rounded, size: 28),
            title: const Text('Receber Notificações'),
            subtitle: const Text('Avisos sobre novos eventos'),
            value: settings.notifications,
            onChanged: (_) => notifier.toggleNotifications(),
          ),
          const Divider(),
          _SectionHeader('Aparência'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_rounded, size: 28),
            title: const Text('Modo Noturno'),
            subtitle: const Text('Reduz o brilho da tela'),
            value: settings.darkMode,
            onChanged: (_) => notifier.toggleDarkMode(),
          ),
          const Divider(),
          _SectionHeader('Idioma'),
          RadioGroup<String>(
            groupValue: settings.language,
            onChanged: (v) { if (v != null) notifier.updateLanguage(v); },
            child: Column(
              children: [
                ListTile(
                  leading: const Radio<String>(value: 'pt'),
                  title: const Text('Português (Brasil)'),
                  trailing: const Text('🇧🇷', style: TextStyle(fontSize: 24)),
                  onTap: () => notifier.updateLanguage('pt'),
                ),
                ListTile(
                  leading: const Radio<String>(value: 'es'),
                  title: const Text('Español'),
                  trailing: const Text('🇪🇸', style: TextStyle(fontSize: 24)),
                  onTap: () => notifier.updateLanguage('es'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.orange,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
