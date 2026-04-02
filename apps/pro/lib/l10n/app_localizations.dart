import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'OnlyCars Pro'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @sendOtp.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرمز'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الرمز'**
  String get verifyOtp;

  /// No description provided for @selectRole.
  ///
  /// In ar, this message translates to:
  /// **'اختر الوضع'**
  String get selectRole;

  /// No description provided for @workshopMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع الورشة'**
  String get workshopMode;

  /// No description provided for @driverMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع السائق'**
  String get driverMode;

  /// No description provided for @shopMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع المتجر'**
  String get shopMode;

  /// No description provided for @dashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboard;

  /// No description provided for @activeJobs.
  ///
  /// In ar, this message translates to:
  /// **'المهام النشطة'**
  String get activeJobs;

  /// No description provided for @earnings.
  ///
  /// In ar, this message translates to:
  /// **'الأرباح'**
  String get earnings;

  /// No description provided for @findCustomer.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن المستخدم'**
  String get findCustomer;

  /// No description provided for @createReport.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء تقرير'**
  String get createReport;

  /// No description provided for @submitBill.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الفاتورة'**
  String get submitBill;

  /// No description provided for @deliveryQueue.
  ///
  /// In ar, this message translates to:
  /// **'طلبات التوصيل'**
  String get deliveryQueue;

  /// No description provided for @confirmPickup.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الاستلام'**
  String get confirmPickup;

  /// No description provided for @confirmDelivery.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التوصيل'**
  String get confirmDelivery;

  /// No description provided for @inventory.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get inventory;

  /// No description provided for @addPart.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قطعة'**
  String get addPart;

  /// No description provided for @incomingOrders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات الواردة'**
  String get incomingOrders;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @selectRolePrompt.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع حسابك'**
  String get selectRolePrompt;

  /// No description provided for @workshopRoleTitle.
  ///
  /// In ar, this message translates to:
  /// **'ورشة'**
  String get workshopRoleTitle;

  /// No description provided for @workshopRoleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'فحص السيارات وإدارة مهام الصيانة'**
  String get workshopRoleSubtitle;

  /// No description provided for @driverRoleTitle.
  ///
  /// In ar, this message translates to:
  /// **'سائق'**
  String get driverRoleTitle;

  /// No description provided for @driverRoleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'توصيل قطع الغيار بين المتاجر والورش'**
  String get driverRoleSubtitle;

  /// No description provided for @driverRegistrationTitle.
  ///
  /// In ar, this message translates to:
  /// **'جهّز حساب السائق'**
  String get driverRegistrationTitle;

  /// No description provided for @driverRegistrationEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل السائق'**
  String get driverRegistrationEyebrow;

  /// No description provided for @driverRegistrationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'املأ النموذج السريع أدناه لبدء التوصيل مع OnlyCars.'**
  String get driverRegistrationSubtitle;

  /// No description provided for @driverFullNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get driverFullNameLabel;

  /// No description provided for @driverFullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'جون دو'**
  String get driverFullNameHint;

  /// No description provided for @driverFullNameValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الاسم الكامل'**
  String get driverFullNameValidation;

  /// No description provided for @driverPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get driverPhoneLabel;

  /// No description provided for @driverPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'+974 5000 0000'**
  String get driverPhoneHint;

  /// No description provided for @driverPhoneValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتف صحيح'**
  String get driverPhoneValidation;

  /// No description provided for @driverVehicleTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نوع المركبة'**
  String get driverVehicleTypeLabel;

  /// No description provided for @driverVehicleTypeCar.
  ///
  /// In ar, this message translates to:
  /// **'سيارة'**
  String get driverVehicleTypeCar;

  /// No description provided for @driverVehicleTypeMotorcycle.
  ///
  /// In ar, this message translates to:
  /// **'دراجة نارية'**
  String get driverVehicleTypeMotorcycle;

  /// No description provided for @driverVehicleTypeVan.
  ///
  /// In ar, this message translates to:
  /// **'فان'**
  String get driverVehicleTypeVan;

  /// No description provided for @driverVehicleTypeValidation.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع المركبة'**
  String get driverVehicleTypeValidation;

  /// No description provided for @driverServiceAreaLabel.
  ///
  /// In ar, this message translates to:
  /// **'منطقة الخدمة'**
  String get driverServiceAreaLabel;

  /// No description provided for @driverServiceAreaHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر منطقة الخدمة'**
  String get driverServiceAreaHint;

  /// No description provided for @driverServiceAreaValidation.
  ///
  /// In ar, this message translates to:
  /// **'اختر منطقة الخدمة'**
  String get driverServiceAreaValidation;

  /// No description provided for @driverServiceAreaDowntownDistrict.
  ///
  /// In ar, this message translates to:
  /// **'وسط المدينة'**
  String get driverServiceAreaDowntownDistrict;

  /// No description provided for @driverServiceAreaIndustrialArea.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الصناعية'**
  String get driverServiceAreaIndustrialArea;

  /// No description provided for @driverServiceAreaWestBay.
  ///
  /// In ar, this message translates to:
  /// **'الخليج الغربي'**
  String get driverServiceAreaWestBay;

  /// No description provided for @driverServiceAreaAlSadd.
  ///
  /// In ar, this message translates to:
  /// **'السد'**
  String get driverServiceAreaAlSadd;

  /// No description provided for @driverServiceAreaAirportZone.
  ///
  /// In ar, this message translates to:
  /// **'منطقة المطار'**
  String get driverServiceAreaAirportZone;

  /// No description provided for @driverLicenseTitle.
  ///
  /// In ar, this message translates to:
  /// **'رخصة القيادة'**
  String get driverLicenseTitle;

  /// No description provided for @driverLicenseUploadTitle.
  ///
  /// In ar, this message translates to:
  /// **'رفع صورة الرخصة'**
  String get driverLicenseUploadTitle;

  /// No description provided for @driverLicenseUploadHint.
  ///
  /// In ar, this message translates to:
  /// **'JPEG أو PNG، صور فقط'**
  String get driverLicenseUploadHint;

  /// No description provided for @driverLicenseValidation.
  ///
  /// In ar, this message translates to:
  /// **'أضف صورة رخصة القيادة'**
  String get driverLicenseValidation;

  /// No description provided for @driverChooseImageSource.
  ///
  /// In ar, this message translates to:
  /// **'اختر مصدر الصورة'**
  String get driverChooseImageSource;

  /// No description provided for @driverCamera.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا'**
  String get driverCamera;

  /// No description provided for @driverGallery.
  ///
  /// In ar, this message translates to:
  /// **'المعرض'**
  String get driverGallery;

  /// No description provided for @driverSubmitApplication.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get driverSubmitApplication;

  /// No description provided for @driverSaveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كمسودة'**
  String get driverSaveDraft;

  /// No description provided for @driverLegalLead.
  ///
  /// In ar, this message translates to:
  /// **'بإرسال الطلب، فأنت توافق على '**
  String get driverLegalLead;

  /// No description provided for @driverLegalTerms.
  ///
  /// In ar, this message translates to:
  /// **'الشروط'**
  String get driverLegalTerms;

  /// No description provided for @driverLegalBridge.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get driverLegalBridge;

  /// No description provided for @driverLegalPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get driverLegalPrivacy;

  /// No description provided for @driverLegalTail.
  ///
  /// In ar, this message translates to:
  /// **'.'**
  String get driverLegalTail;

  /// No description provided for @driverPrivacyTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية وحماية البيانات'**
  String get driverPrivacyTitle;

  /// No description provided for @driverPrivacySummaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص سريع:'**
  String get driverPrivacySummaryTitle;

  /// No description provided for @driverPrivacyBulletEncryption.
  ///
  /// In ar, this message translates to:
  /// **'مستنداتك الشخصية مشفرة.'**
  String get driverPrivacyBulletEncryption;

  /// No description provided for @driverPrivacyBulletAccess.
  ///
  /// In ar, this message translates to:
  /// **'فقط فريق OnlyCars المصرح له يمكنه مراجعة بيانات السائق.'**
  String get driverPrivacyBulletAccess;

  /// No description provided for @driverPrivacyBulletControl.
  ///
  /// In ar, this message translates to:
  /// **'أنت تتحكم في تفاصيل التوصيل التي تتم مشاركتها أثناء المهام النشطة.'**
  String get driverPrivacyBulletControl;

  /// No description provided for @driverPrivacyAgreementLead.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على '**
  String get driverPrivacyAgreementLead;

  /// No description provided for @driverPrivacyAgreementTerms.
  ///
  /// In ar, this message translates to:
  /// **'الشروط'**
  String get driverPrivacyAgreementTerms;

  /// No description provided for @driverPrivacyAgreementBridge.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get driverPrivacyAgreementBridge;

  /// No description provided for @driverPrivacyAgreementPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get driverPrivacyAgreementPolicy;

  /// No description provided for @driverAgreeAndContinue.
  ///
  /// In ar, this message translates to:
  /// **'موافقة ومتابعة'**
  String get driverAgreeAndContinue;

  /// No description provided for @driverCompleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'أصبحت جاهزًا'**
  String get driverCompleteTitle;

  /// No description provided for @driverStart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ'**
  String get driverStart;

  /// No description provided for @shopRoleTitle.
  ///
  /// In ar, this message translates to:
  /// **'متجر'**
  String get shopRoleTitle;

  /// No description provided for @shopRoleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'بيع قطع الغيار وإدارة المخزون'**
  String get shopRoleSubtitle;

  /// No description provided for @shopRegistrationStep.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة 1 من 2'**
  String get shopRegistrationStep;

  /// No description provided for @shopRegistrationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الشريك'**
  String get shopRegistrationTitle;

  /// No description provided for @shopRegistrationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أكمل النموذج أدناه لبدء بيع قطع الغيار على OnlyCars.'**
  String get shopRegistrationSubtitle;

  /// No description provided for @shopGeneralInformationTitle.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات العامة'**
  String get shopGeneralInformationTitle;

  /// No description provided for @shopNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المتجر'**
  String get shopNameLabel;

  /// No description provided for @shopNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: أبيكس لقطع الأداء'**
  String get shopNameHint;

  /// No description provided for @shopNameValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المتجر'**
  String get shopNameValidation;

  /// No description provided for @shopContactNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم جهة الاتصال'**
  String get shopContactNameLabel;

  /// No description provided for @shopContactNameHint.
  ///
  /// In ar, this message translates to:
  /// **'جون دو'**
  String get shopContactNameHint;

  /// No description provided for @shopContactNameValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم جهة الاتصال'**
  String get shopContactNameValidation;

  /// No description provided for @shopPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get shopPhoneLabel;

  /// No description provided for @shopPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'+974 5000 0000'**
  String get shopPhoneHint;

  /// No description provided for @shopPhoneValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتف صحيح'**
  String get shopPhoneValidation;

  /// No description provided for @shopLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get shopLocationTitle;

  /// No description provided for @shopLocationHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن عنوان المتجر...'**
  String get shopLocationHint;

  /// No description provided for @shopLocationValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عنوان المتجر'**
  String get shopLocationValidation;

  /// No description provided for @shopCategoriesTitle.
  ///
  /// In ar, this message translates to:
  /// **'فئات المخزون'**
  String get shopCategoriesTitle;

  /// No description provided for @shopCategoryEngine.
  ///
  /// In ar, this message translates to:
  /// **'محرك'**
  String get shopCategoryEngine;

  /// No description provided for @shopCategoryBrakes.
  ///
  /// In ar, this message translates to:
  /// **'فرامل'**
  String get shopCategoryBrakes;

  /// No description provided for @shopCategorySuspension.
  ///
  /// In ar, this message translates to:
  /// **'تعليق'**
  String get shopCategorySuspension;

  /// No description provided for @shopCategoryBody.
  ///
  /// In ar, this message translates to:
  /// **'هيكل'**
  String get shopCategoryBody;

  /// No description provided for @shopCategoryElectrical.
  ///
  /// In ar, this message translates to:
  /// **'كهرباء'**
  String get shopCategoryElectrical;

  /// No description provided for @shopCategoriesValidation.
  ///
  /// In ar, this message translates to:
  /// **'اختر فئة واحدة على الأقل'**
  String get shopCategoriesValidation;

  /// No description provided for @shopVerificationTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق'**
  String get shopVerificationTitle;

  /// No description provided for @shopBusinessLicenseUploadTitle.
  ///
  /// In ar, this message translates to:
  /// **'رفع الرخصة التجارية'**
  String get shopBusinessLicenseUploadTitle;

  /// No description provided for @shopBusinessLicenseUploadHint.
  ///
  /// In ar, this message translates to:
  /// **'JPEG أو PNG، صور فقط'**
  String get shopBusinessLicenseUploadHint;

  /// No description provided for @shopBusinessLicenseValidation.
  ///
  /// In ar, this message translates to:
  /// **'أضف صورة الرخصة التجارية'**
  String get shopBusinessLicenseValidation;

  /// No description provided for @shopChooseImageSource.
  ///
  /// In ar, this message translates to:
  /// **'اختر مصدر الصورة'**
  String get shopChooseImageSource;

  /// No description provided for @shopCamera.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا'**
  String get shopCamera;

  /// No description provided for @shopGallery.
  ///
  /// In ar, this message translates to:
  /// **'المعرض'**
  String get shopGallery;

  /// No description provided for @shopCompleteRegistration.
  ///
  /// In ar, this message translates to:
  /// **'إكمال التسجيل'**
  String get shopCompleteRegistration;

  /// No description provided for @shopSaveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كمسودة'**
  String get shopSaveDraft;

  /// No description provided for @shopLegalLead.
  ///
  /// In ar, this message translates to:
  /// **'بالمتابعة، فأنت توافق على '**
  String get shopLegalLead;

  /// No description provided for @shopLegalTerms.
  ///
  /// In ar, this message translates to:
  /// **'شروط الشركاء'**
  String get shopLegalTerms;

  /// No description provided for @shopLegalBridge.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get shopLegalBridge;

  /// No description provided for @shopLegalPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get shopLegalPrivacy;

  /// No description provided for @shopLegalTail.
  ///
  /// In ar, this message translates to:
  /// **'.'**
  String get shopLegalTail;

  /// No description provided for @shopPrivacyTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية وحماية البيانات'**
  String get shopPrivacyTitle;

  /// No description provided for @shopPrivacySummaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص سريع:'**
  String get shopPrivacySummaryTitle;

  /// No description provided for @shopPrivacyBulletEncryption.
  ///
  /// In ar, this message translates to:
  /// **'مستندات نشاطك مشفرة.'**
  String get shopPrivacyBulletEncryption;

  /// No description provided for @shopPrivacyBulletAccess.
  ///
  /// In ar, this message translates to:
  /// **'فقط فريق OnlyCars المصرح له يمكنه مراجعة بيانات التحقق.'**
  String get shopPrivacyBulletAccess;

  /// No description provided for @shopPrivacyBulletControl.
  ///
  /// In ar, this message translates to:
  /// **'أنت تتحكم في المعلومات التي تظهر عن متجرك للمشترين.'**
  String get shopPrivacyBulletControl;

  /// No description provided for @shopPrivacyAgreementLead.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على '**
  String get shopPrivacyAgreementLead;

  /// No description provided for @shopPrivacyAgreementTerms.
  ///
  /// In ar, this message translates to:
  /// **'شروط الشركاء'**
  String get shopPrivacyAgreementTerms;

  /// No description provided for @shopPrivacyAgreementBridge.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get shopPrivacyAgreementBridge;

  /// No description provided for @shopPrivacyAgreementPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get shopPrivacyAgreementPolicy;

  /// No description provided for @shopAgreeAndContinue.
  ///
  /// In ar, this message translates to:
  /// **'موافقة ومتابعة'**
  String get shopAgreeAndContinue;

  /// No description provided for @shopCompleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'أصبحت جاهزًا'**
  String get shopCompleteTitle;

  /// No description provided for @shopStart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ'**
  String get shopStart;

  /// No description provided for @workshopRegistrationEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الورشة'**
  String get workshopRegistrationEyebrow;

  /// No description provided for @workshopRegistrationTitle.
  ///
  /// In ar, this message translates to:
  /// **'جهّز ورشتك'**
  String get workshopRegistrationTitle;

  /// No description provided for @workshopRegistrationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بياناتك الأساسية لبدء إدارة مهام الصيانة على شبكة OnlyCars.'**
  String get workshopRegistrationSubtitle;

  /// No description provided for @workshopNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الورشة'**
  String get workshopNameLabel;

  /// No description provided for @workshopNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: ورشة الأداء المتقدم'**
  String get workshopNameHint;

  /// No description provided for @workshopNameValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الورشة'**
  String get workshopNameValidation;

  /// No description provided for @workshopOwnerLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل للمالك'**
  String get workshopOwnerLabel;

  /// No description provided for @workshopOwnerHint.
  ///
  /// In ar, this message translates to:
  /// **'جوناثان ستيرلينغ'**
  String get workshopOwnerHint;

  /// No description provided for @workshopOwnerValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المالك'**
  String get workshopOwnerValidation;

  /// No description provided for @workshopPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف النشاط'**
  String get workshopPhoneLabel;

  /// No description provided for @workshopPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'+974 5000 0000'**
  String get workshopPhoneHint;

  /// No description provided for @workshopPhoneValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتف صحيح'**
  String get workshopPhoneValidation;

  /// No description provided for @workshopLocationLabel.
  ///
  /// In ar, this message translates to:
  /// **'موقع الورشة'**
  String get workshopLocationLabel;

  /// No description provided for @workshopLocationHint.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الصناعية، الشارع 12'**
  String get workshopLocationHint;

  /// No description provided for @workshopLocationValidation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل موقع الورشة'**
  String get workshopLocationValidation;

  /// No description provided for @workshopSpecialtiesTitle.
  ///
  /// In ar, this message translates to:
  /// **'التخصصات'**
  String get workshopSpecialtiesTitle;

  /// No description provided for @workshopSpecialtyEngine.
  ///
  /// In ar, this message translates to:
  /// **'محرك'**
  String get workshopSpecialtyEngine;

  /// No description provided for @workshopSpecialtyElectrical.
  ///
  /// In ar, this message translates to:
  /// **'كهرباء'**
  String get workshopSpecialtyElectrical;

  /// No description provided for @workshopSpecialtyTires.
  ///
  /// In ar, this message translates to:
  /// **'إطارات'**
  String get workshopSpecialtyTires;

  /// No description provided for @workshopSpecialtyPaint.
  ///
  /// In ar, this message translates to:
  /// **'دهان'**
  String get workshopSpecialtyPaint;

  /// No description provided for @workshopSpecialtyOil.
  ///
  /// In ar, this message translates to:
  /// **'زيوت'**
  String get workshopSpecialtyOil;

  /// No description provided for @workshopSpecialtyOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get workshopSpecialtyOther;

  /// No description provided for @workshopSpecialtyValidation.
  ///
  /// In ar, this message translates to:
  /// **'اختر تخصصًا واحدًا على الأقل'**
  String get workshopSpecialtyValidation;

  /// No description provided for @workshopVerificationTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق'**
  String get workshopVerificationTitle;

  /// No description provided for @workshopTradeLicenseUploadTitle.
  ///
  /// In ar, this message translates to:
  /// **'رفع السجل التجاري'**
  String get workshopTradeLicenseUploadTitle;

  /// No description provided for @workshopTradeLicenseUploadHint.
  ///
  /// In ar, this message translates to:
  /// **'صورة فقط بصيغة JPEG أو PNG'**
  String get workshopTradeLicenseUploadHint;

  /// No description provided for @workshopTradeLicenseValidation.
  ///
  /// In ar, this message translates to:
  /// **'أضف صورة السجل التجاري'**
  String get workshopTradeLicenseValidation;

  /// No description provided for @workshopChooseImageSource.
  ///
  /// In ar, this message translates to:
  /// **'اختر مصدر الصورة'**
  String get workshopChooseImageSource;

  /// No description provided for @workshopCamera.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا'**
  String get workshopCamera;

  /// No description provided for @workshopGallery.
  ///
  /// In ar, this message translates to:
  /// **'المعرض'**
  String get workshopGallery;

  /// No description provided for @workshopCompleteRegistration.
  ///
  /// In ar, this message translates to:
  /// **'إكمال التسجيل'**
  String get workshopCompleteRegistration;

  /// No description provided for @workshopSaveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كمسودة'**
  String get workshopSaveDraft;

  /// No description provided for @workshopPrivacyTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية وحماية البيانات'**
  String get workshopPrivacyTitle;

  /// No description provided for @workshopPrivacySummaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص سريع:'**
  String get workshopPrivacySummaryTitle;

  /// No description provided for @workshopPrivacyBulletEncryption.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك مشفرة.'**
  String get workshopPrivacyBulletEncryption;

  /// No description provided for @workshopPrivacyBulletAccess.
  ///
  /// In ar, this message translates to:
  /// **'فقط مقدمو الخدمة المصرح لهم يمكنهم الوصول إلى سجلاتك.'**
  String get workshopPrivacyBulletAccess;

  /// No description provided for @workshopPrivacyBulletControl.
  ///
  /// In ar, this message translates to:
  /// **'أنت تتحكم بمن يمكنه الاطلاع على معلوماتك.'**
  String get workshopPrivacyBulletControl;

  /// No description provided for @workshopPrivacyAgreementLead.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على '**
  String get workshopPrivacyAgreementLead;

  /// No description provided for @workshopPrivacyAgreementPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get workshopPrivacyAgreementPolicy;

  /// No description provided for @workshopPrivacyAgreementBridge.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get workshopPrivacyAgreementBridge;

  /// No description provided for @workshopPrivacyAgreementHipaa.
  ///
  /// In ar, this message translates to:
  /// **'شروط HIPAA'**
  String get workshopPrivacyAgreementHipaa;

  /// No description provided for @workshopAgreeAndContinue.
  ///
  /// In ar, this message translates to:
  /// **'موافقة ومتابعة'**
  String get workshopAgreeAndContinue;

  /// No description provided for @workshopCompleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'أصبحت جاهزًا'**
  String get workshopCompleteTitle;

  /// No description provided for @workshopStart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ'**
  String get workshopStart;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ. حاول مرة أخرى'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
