import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../core/phone_launcher.dart';
import '../../providers/contacts_provider.dart';
import '../widgets/emergency_button.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final family = ref.watch(familyContactsProvider);
    final mainFamily = family.isNotEmpty ? family.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergência'),
        backgroundColor: AppColors.red.withValues(alpha: 0.08),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Toque para ligar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const EmergencyButton(
                label: 'SAMU',
                number: '192',
                subtitle: 'Urgência Médica — 192',
                color: AppColors.red,
                icon: Icons.local_hospital_rounded,
              ),
              const EmergencyButton(
                label: 'Bombeiros',
                number: '193',
                subtitle: 'Incêndio / Resgate — 193',
                color: AppColors.orange,
                icon: Icons.local_fire_department_rounded,
              ),
              const EmergencyButton(
                label: 'Polícia',
                number: '190',
                subtitle: 'Segurança Pública — 190',
                color: AppColors.blue,
                icon: Icons.local_police_rounded,
              ),
              const EmergencyButton(
                label: 'Defesa Civil',
                number: '199',
                subtitle: 'Desastres e Calamidades — 199',
                color: Color(0xFF15803D),
                icon: Icons.shield_rounded,
              ),
              const EmergencyButton(
                label: 'UPA / Pronto-socorro',
                number: '(45) 3902-8000',
                subtitle: 'Urgência e Emergência',
                color: Color(0xFF1E40AF),
                icon: Icons.medical_services_rounded,
              ),
              if (mainFamily != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Familiar de Confiança',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 84,
                    child: ElevatedButton(
                      onPressed: () => launchPhone(mainFamily.phone),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 3,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                mainFamily.emoji,
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mainFamily.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${mainFamily.relationship} — ${mainFamily.phone}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.phone_rounded, size: 28, color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
