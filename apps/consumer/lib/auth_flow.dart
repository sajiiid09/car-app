import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthRole { customer, driver, workshop, partsShop }

extension AuthRoleX on AuthRole {
  bool get canContinueWithRole => this == AuthRole.customer;

  String get label {
    switch (this) {
      case AuthRole.customer:
        return 'Customer';
      case AuthRole.driver:
        return 'Driver';
      case AuthRole.workshop:
        return 'Workshops';
      case AuthRole.partsShop:
        return 'Parts Shop';
    }
  }

  String get comingSoonLabel {
    switch (this) {
      case AuthRole.customer:
        return '';
      case AuthRole.driver:
        return 'Driver onboarding is coming soon.';
      case AuthRole.workshop:
        return 'Workshop onboarding is coming soon.';
      case AuthRole.partsShop:
        return 'Parts shop onboarding is coming soon.';
    }
  }

  IconData get icon {
    switch (this) {
      case AuthRole.customer:
        return Icons.person_rounded;
      case AuthRole.driver:
        return Icons.local_shipping_rounded;
      case AuthRole.workshop:
        return Icons.garage_rounded;
      case AuthRole.partsShop:
        return Icons.storefront_rounded;
    }
  }

  Color get avatarColor {
    switch (this) {
      case AuthRole.customer:
        return const Color(0xFF1E67FF);
      case AuthRole.driver:
        return const Color(0xFFF3A93B);
      case AuthRole.workshop:
        return const Color(0xFFD98B1E);
      case AuthRole.partsShop:
        return const Color(0xFFCE7646);
    }
  }
}

enum EngineType { petrol, diesel, hybrid, ev }

extension EngineTypeX on EngineType {
  String get label {
    switch (this) {
      case EngineType.petrol:
        return 'Petrol';
      case EngineType.diesel:
        return 'Diesel';
      case EngineType.hybrid:
        return 'Hybrid';
      case EngineType.ev:
        return 'EV';
    }
  }
}

@immutable
class VehicleDraft {
  const VehicleDraft({
    this.brand,
    this.model,
    this.year,
    this.engineType,
    this.plate = '',
    this.vin = '',
  });

  final String? brand;
  final String? model;
  final int? year;
  final EngineType? engineType;
  final String plate;
  final String vin;

  bool get isComplete =>
      brand != null &&
      model != null &&
      year != null &&
      engineType != null &&
      plate.trim().isNotEmpty;

  VehicleDraft copyWith({
    String? brand,
    String? model,
    int? year,
    EngineType? engineType,
    String? plate,
    String? vin,
    bool clearModel = false,
  }) {
    return VehicleDraft(
      brand: brand ?? this.brand,
      model: clearModel ? null : model ?? this.model,
      year: year ?? this.year,
      engineType: engineType ?? this.engineType,
      plate: plate ?? this.plate,
      vin: vin ?? this.vin,
    );
  }
}

@immutable
class AuthFlowDraft {
  const AuthFlowDraft({
    this.role = AuthRole.customer,
    this.name = '',
    this.email = '',
    this.password = '',
    this.acceptedPrivacy = false,
    this.vehicle = const VehicleDraft(),
    this.skippedVehicle = false,
  });

  final AuthRole role;
  final String name;
  final String email;
  final String password;
  final bool acceptedPrivacy;
  final VehicleDraft vehicle;
  final bool skippedVehicle;

  bool get canContinueWithRole => role == AuthRole.customer;

  AuthFlowDraft copyWith({
    AuthRole? role,
    String? name,
    String? email,
    String? password,
    bool? acceptedPrivacy,
    VehicleDraft? vehicle,
    bool? skippedVehicle,
  }) {
    return AuthFlowDraft(
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
      vehicle: vehicle ?? this.vehicle,
      skippedVehicle: skippedVehicle ?? this.skippedVehicle,
    );
  }
}

class AuthFlowNotifier extends Notifier<AuthFlowDraft> {
  @override
  AuthFlowDraft build() => const AuthFlowDraft();

  void setRole(AuthRole role) {
    state = state.copyWith(role: role);
  }

  void setBasicInfo({
    String? name,
    required String email,
    required String password,
  }) {
    state = state.copyWith(
      name: name?.trim() ?? state.name,
      email: email.trim(),
      password: password,
    );
  }

  void setAcceptedPrivacy(bool value) {
    state = state.copyWith(acceptedPrivacy: value);
  }

  void setVehicle(VehicleDraft vehicle) {
    state = state.copyWith(
      vehicle: vehicle,
      skippedVehicle: false,
    );
  }

  void skipVehicle() {
    state = state.copyWith(skippedVehicle: true);
  }

  void reset() {
    state = const AuthFlowDraft();
  }
}

final authFlowProvider =
    NotifierProvider<AuthFlowNotifier, AuthFlowDraft>(AuthFlowNotifier.new);

final authPreviewSessionProvider = StateProvider<bool>((_) => false);
