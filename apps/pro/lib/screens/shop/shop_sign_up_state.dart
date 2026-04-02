import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum ShopInventoryCategory {
  engine(Icons.settings_rounded),
  brakes(Icons.album_rounded),
  suspension(Icons.car_repair_rounded),
  body(Icons.directions_car_filled_rounded),
  electrical(Icons.bolt_rounded);

  const ShopInventoryCategory(this.icon);

  final IconData icon;
}

@immutable
class ShopRegistrationDraft {
  const ShopRegistrationDraft({
    this.shopName = '',
    this.contactName = '',
    this.phone = '',
    this.location = '',
    this.selectedCategories = const <ShopInventoryCategory>{},
    this.businessLicenseImagePath,
    this.acceptedPrivacy = false,
  });

  final String shopName;
  final String contactName;
  final String phone;
  final String location;
  final Set<ShopInventoryCategory> selectedCategories;
  final String? businessLicenseImagePath;
  final bool acceptedPrivacy;

  bool get hasDraft =>
      shopName.trim().isNotEmpty ||
      contactName.trim().isNotEmpty ||
      phone.trim().isNotEmpty ||
      location.trim().isNotEmpty ||
      selectedCategories.isNotEmpty ||
      businessLicenseImagePath != null;

  ShopRegistrationDraft copyWith({
    String? shopName,
    String? contactName,
    String? phone,
    String? location,
    Set<ShopInventoryCategory>? selectedCategories,
    String? businessLicenseImagePath,
    bool clearBusinessLicenseImage = false,
    bool? acceptedPrivacy,
  }) {
    return ShopRegistrationDraft(
      shopName: shopName ?? this.shopName,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      selectedCategories: Set.unmodifiable(
        selectedCategories ?? this.selectedCategories,
      ),
      businessLicenseImagePath: clearBusinessLicenseImage
          ? null
          : businessLicenseImagePath ?? this.businessLicenseImagePath,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }
}

class ShopRegistrationDraftNotifier extends Notifier<ShopRegistrationDraft> {
  @override
  ShopRegistrationDraft build() => const ShopRegistrationDraft();

  void saveDraft(ShopRegistrationDraft draft) {
    state = draft;
  }

  void clear() {
    state = const ShopRegistrationDraft();
  }
}

final shopRegistrationDraftProvider =
    NotifierProvider<ShopRegistrationDraftNotifier, ShopRegistrationDraft>(
      ShopRegistrationDraftNotifier.new,
    );

abstract class ShopBusinessLicensePicker {
  Future<String?> pickImage({required ImageSource source});
}

class DeviceShopBusinessLicensePicker implements ShopBusinessLicensePicker {
  DeviceShopBusinessLicensePicker({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<String?> pickImage({required ImageSource source}) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 88,
    );
    return image?.path;
  }
}

final shopBusinessLicensePickerProvider = Provider<ShopBusinessLicensePicker>(
  (_) => DeviceShopBusinessLicensePicker(),
);
