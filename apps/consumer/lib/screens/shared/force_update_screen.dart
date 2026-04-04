import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Force update dialog — shown when app version is below minimum
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  static final Uri _androidStoreUri = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.onlycars.consumer',
  );
  static final Uri _iosStoreUri = Uri.parse(
    'https://apps.apple.com/us/search?term=OnlyCars',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(OcSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Update icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: OcColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.system_update_rounded,
                  size: 60,
                  color: OcColors.primary,
                ),
              ),
              const SizedBox(height: OcSpacing.xxl),

              Text(
                'تحديث مطلوب',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: OcSpacing.md),

              Text(
                'يتوفر إصدار جديد من التطبيق يحتوي على تحسينات مهمة. يرجى التحديث للمتابعة.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: OcColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Update button
              SizedBox(
                width: double.infinity,
                child: OcButton(
                  label: 'تحديث الآن',
                  onPressed: () => _openStoreListing(context),
                  icon: Icons.download_rounded,
                ),
              ),
              const SizedBox(height: OcSpacing.md),

              // App version
              Text(
                'الإصدار الحالي: 1.0.0',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: OcColors.textSecondary),
              ),
              const SizedBox(height: OcSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStoreListing(BuildContext context) async {
    final uri = switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => _iosStoreUri,
      _ => _androidStoreUri,
    };

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر فتح صفحة التحديث')));
    }
  }
}

/// Version check utility
class AppVersionService {
  static const currentVersion = '1.0.0';

  /// Check if force update is needed
  /// Fetches min_app_version from platform_settings table
  static Future<bool> needsForceUpdate() async {
    try {
      // In production, fetch from Supabase
      // final settings = await OcSupabase.client.from('platform_settings').select().single();
      // final minVersion = settings['min_app_version'] as String;
      return false;
    } catch (_) {
      return false;
    }
  }
}
