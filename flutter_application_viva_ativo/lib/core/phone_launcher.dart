import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhone(String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
  final uri = Uri.parse('tel:$cleaned');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> launchWhatsApp(String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
  final uri = Uri.parse('https://wa.me/55$cleaned');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
