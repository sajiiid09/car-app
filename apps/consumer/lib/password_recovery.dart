import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class PasswordRecoveryDraft {
  const PasswordRecoveryDraft({
    this.email = '',
    this.code = '',
    this.password = '',
    this.resetSucceeded = false,
  });

  final String email;
  final String code;
  final String password;
  final bool resetSucceeded;

  PasswordRecoveryDraft copyWith({
    String? email,
    String? code,
    String? password,
    bool? resetSucceeded,
  }) {
    return PasswordRecoveryDraft(
      email: email ?? this.email,
      code: code ?? this.code,
      password: password ?? this.password,
      resetSucceeded: resetSucceeded ?? this.resetSucceeded,
    );
  }
}

class PasswordRecoveryNotifier extends Notifier<PasswordRecoveryDraft> {
  @override
  PasswordRecoveryDraft build() => const PasswordRecoveryDraft();

  void setEmail(String email) {
    state = state.copyWith(
      email: email.trim(),
      resetSucceeded: false,
    );
  }

  void setCode(String code) {
    state = state.copyWith(code: code);
  }

  void resetCode() {
    state = state.copyWith(code: '');
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void markResetSucceeded() {
    state = const PasswordRecoveryDraft(resetSucceeded: true);
  }

  void consumeResetSuccess() {
    if (!state.resetSucceeded) {
      return;
    }

    state = const PasswordRecoveryDraft();
  }

  void clear() {
    state = const PasswordRecoveryDraft();
  }
}

final passwordRecoveryProvider =
    NotifierProvider<PasswordRecoveryNotifier, PasswordRecoveryDraft>(
      PasswordRecoveryNotifier.new,
    );
