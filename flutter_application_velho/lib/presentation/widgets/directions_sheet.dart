import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../../domain/models/event.dart';

class DirectionsSheet extends StatelessWidget {
  const DirectionsSheet({super.key, required this.event});
  final Event event;

  Future<void> _openMaps() async {
    final encoded = Uri.encodeComponent(event.address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Como Chegar', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(event.location,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.orange)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(event.address, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Mapa simulado
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0E8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Stack(
                children: [
                  // Ruas fictícias
                  CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _MockMapPainter(),
                  ),
                  // Pin central
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(Icons.location_pin, color: AppColors.red, size: 40),
                      ],
                    ),
                  ),
                  // Legenda de escala
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Mapa ilustrativo',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openMaps,
                icon: const Icon(Icons.navigation_rounded, size: 22),
                label: const Text('Iniciar Navegação'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final borderPaint = Paint()
      ..color = const Color(0xFFCED8CE)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Ruas horizontais
    for (final roadPaintCurrent in [borderPaint, roadPaint]) {
      canvas.drawLine(Offset(0, h * 0.3), Offset(w, h * 0.3), roadPaintCurrent);
      canvas.drawLine(Offset(0, h * 0.65), Offset(w, h * 0.65), roadPaintCurrent);
    }
    // Ruas verticais
    for (final roadPaintCurrent in [borderPaint, roadPaint]) {
      canvas.drawLine(Offset(w * 0.25, 0), Offset(w * 0.25, h), roadPaintCurrent);
      canvas.drawLine(Offset(w * 0.7, 0), Offset(w * 0.7, h), roadPaintCurrent);
    }

    // Quarteirões (blocos verdes simulando vegetação/construções)
    final blockPaint = Paint()..color = const Color(0xFFD4E6D4);
    final blocks = [
      Rect.fromLTWH(w * 0.03, h * 0.05, w * 0.18, h * 0.2),
      Rect.fromLTWH(w * 0.3, h * 0.05, w * 0.35, h * 0.2),
      Rect.fromLTWH(w * 0.75, h * 0.05, w * 0.22, h * 0.2),
      Rect.fromLTWH(w * 0.03, h * 0.38, w * 0.18, h * 0.22),
      Rect.fromLTWH(w * 0.3, h * 0.38, w * 0.35, h * 0.22),
      Rect.fromLTWH(w * 0.75, h * 0.38, w * 0.22, h * 0.22),
      Rect.fromLTWH(w * 0.03, h * 0.72, w * 0.18, h * 0.25),
      Rect.fromLTWH(w * 0.3, h * 0.72, w * 0.35, h * 0.25),
      Rect.fromLTWH(w * 0.75, h * 0.72, w * 0.22, h * 0.25),
    ];
    for (final rect in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
