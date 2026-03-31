import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const supportedFirstRunLocales = <Locale>[Locale('en'), Locale('ar')];

const _hasCompletedOnboardingKey = 'hasCompletedOnboarding';
const _preferredLocaleCodeKey = 'preferredLocaleCode';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  ),
);

abstract interface class FirstRunPersistence {
  bool get hasCompletedOnboarding;
  String? get preferredLocaleCode;
  Future<void> completeOnboarding();
  Future<void> setPreferredLocaleCode(String code);
}

class SharedPreferencesFirstRunPersistence implements FirstRunPersistence {
  SharedPreferencesFirstRunPersistence(this._prefs);

  final SharedPreferences _prefs;

  @override
  bool get hasCompletedOnboarding =>
      _prefs.getBool(_hasCompletedOnboardingKey) ?? false;

  @override
  String? get preferredLocaleCode {
    final normalized = normalizeLocaleCode(
      _prefs.getString(_preferredLocaleCodeKey),
    );
    return normalized;
  }

  @override
  Future<void> completeOnboarding() =>
      _prefs.setBool(_hasCompletedOnboardingKey, true);

  @override
  Future<void> setPreferredLocaleCode(String code) async {
    final normalized = normalizeLocaleCode(code);
    if (normalized == null) {
      return;
    }
    await _prefs.setString(_preferredLocaleCodeKey, normalized);
  }
}

final firstRunPersistenceProvider = Provider<FirstRunPersistence>(
  (ref) => SharedPreferencesFirstRunPersistence(
    ref.watch(sharedPreferencesProvider),
  ),
);

String? normalizeLocaleCode(String? code) {
  switch (code?.toLowerCase()) {
    case 'en':
      return 'en';
    case 'ar':
      return 'ar';
    default:
      return null;
  }
}

Locale resolveOnlyCarsLocale({
  String? storedLocaleCode,
  List<Locale>? deviceLocales,
}) {
  final storedCode = normalizeLocaleCode(storedLocaleCode);
  if (storedCode != null) {
    return Locale(storedCode);
  }

  for (final locale
      in deviceLocales ?? WidgetsBinding.instance.platformDispatcher.locales) {
    final normalizedCode = normalizeLocaleCode(locale.languageCode);
    if (normalizedCode != null) {
      return Locale(normalizedCode);
    }
  }

  return const Locale('en');
}

@immutable
class FirstRunState {
  const FirstRunState({
    required this.hasCompletedOnboarding,
    required this.locale,
  });

  final bool hasCompletedOnboarding;
  final Locale locale;

  FirstRunState copyWith({bool? hasCompletedOnboarding, Locale? locale}) {
    return FirstRunState(
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      locale: locale ?? this.locale,
    );
  }
}

class FirstRunController extends Notifier<FirstRunState> {
  @override
  FirstRunState build() {
    final storage = ref.watch(firstRunPersistenceProvider);
    return FirstRunState(
      hasCompletedOnboarding: storage.hasCompletedOnboarding,
      locale: resolveOnlyCarsLocale(
        storedLocaleCode: storage.preferredLocaleCode,
      ),
    );
  }

  Future<void> completeOnboarding() async {
    await ref.read(firstRunPersistenceProvider).completeOnboarding();
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  Future<void> setPreferredLocaleCode(String code) async {
    final normalized = normalizeLocaleCode(code);
    if (normalized == null) {
      return;
    }

    await ref
        .read(firstRunPersistenceProvider)
        .setPreferredLocaleCode(normalized);
    state = state.copyWith(locale: Locale(normalized));
  }
}

final firstRunControllerProvider =
    NotifierProvider<FirstRunController, FirstRunState>(FirstRunController.new);

final appLocaleProvider = Provider<Locale>(
  (ref) => ref.watch(firstRunControllerProvider).locale,
);
