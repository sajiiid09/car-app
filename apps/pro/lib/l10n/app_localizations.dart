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

  /// No description provided for @workshopShellDashboardTab.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get workshopShellDashboardTab;

  /// No description provided for @workshopShellJobsTab.
  ///
  /// In ar, this message translates to:
  /// **'الوظائف'**
  String get workshopShellJobsTab;

  /// No description provided for @workshopShellMessagesTab.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get workshopShellMessagesTab;

  /// No description provided for @workshopShellProfileTab.
  ///
  /// In ar, this message translates to:
  /// **'الملف'**
  String get workshopShellProfileTab;

  /// No description provided for @workshopOverviewEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'نظرة عامة على الورشة'**
  String get workshopOverviewEyebrow;

  /// No description provided for @workshopWelcomeBackChief.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا بعودتك'**
  String get workshopWelcomeBackChief;

  /// No description provided for @workshopDashboardSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص تشغيلي واضح للطلبات الجديدة والموافقات والوظائف الجاهزة للتسليم.'**
  String get workshopDashboardSubtitle;

  /// No description provided for @workshopCreateJob.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء وظيفة'**
  String get workshopCreateJob;

  /// No description provided for @workshopMetricNewRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات جديدة'**
  String get workshopMetricNewRequests;

  /// No description provided for @workshopMetricActiveJobs.
  ///
  /// In ar, this message translates to:
  /// **'وظائف نشطة'**
  String get workshopMetricActiveJobs;

  /// No description provided for @workshopMetricWaitingApproval.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الموافقة'**
  String get workshopMetricWaitingApproval;

  /// No description provided for @workshopMetricReadyPickup.
  ///
  /// In ar, this message translates to:
  /// **'جاهز للاستلام'**
  String get workshopMetricReadyPickup;

  /// No description provided for @workshopRecentServiceJobs.
  ///
  /// In ar, this message translates to:
  /// **'أحدث وظائف الخدمة'**
  String get workshopRecentServiceJobs;

  /// No description provided for @workshopViewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get workshopViewAll;

  /// No description provided for @workshopOperationsEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الورشة'**
  String get workshopOperationsEyebrow;

  /// No description provided for @workshopServiceRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الخدمة'**
  String get workshopServiceRequestsTitle;

  /// No description provided for @workshopJobsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع طلبات الطريق الجديدة وموافقات التشخيص والوظائف الجاهزة للتسليم في قائمة واحدة.'**
  String get workshopJobsSubtitle;

  /// No description provided for @workshopMetricPending.
  ///
  /// In ar, this message translates to:
  /// **'معلق'**
  String get workshopMetricPending;

  /// No description provided for @workshopMetricApprovalShort.
  ///
  /// In ar, this message translates to:
  /// **'موافقة'**
  String get workshopMetricApprovalShort;

  /// No description provided for @workshopMetricHandoverShort.
  ///
  /// In ar, this message translates to:
  /// **'تسليم'**
  String get workshopMetricHandoverShort;

  /// No description provided for @workshopJobsFilterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get workshopJobsFilterAll;

  /// No description provided for @workshopJobsFilterNew.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get workshopJobsFilterNew;

  /// No description provided for @workshopJobsFilterApproval.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة'**
  String get workshopJobsFilterApproval;

  /// No description provided for @workshopJobsFilterHandover.
  ///
  /// In ar, this message translates to:
  /// **'التسليم'**
  String get workshopJobsFilterHandover;

  /// No description provided for @workshopNoJobsForFilter.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد وظائف في هذه القائمة الآن.'**
  String get workshopNoJobsForFilter;

  /// No description provided for @workshopRequestNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على الطلب'**
  String get workshopRequestNotFound;

  /// No description provided for @workshopRoadsideRequestEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'شبكة خدمة مميزة'**
  String get workshopRoadsideRequestEyebrow;

  /// No description provided for @workshopRequestDetailTitle.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب سحب على الطريق'**
  String get workshopRequestDetailTitle;

  /// No description provided for @workshopRequestDetailSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع السيارة والمشكلة وتفاصيل التسليم قبل قبول الطلب.'**
  String get workshopRequestDetailSubtitle;

  /// No description provided for @workshopRequestIssueLabel.
  ///
  /// In ar, this message translates to:
  /// **'المشكلة المبلغ عنها'**
  String get workshopRequestIssueLabel;

  /// No description provided for @workshopRequestLocationLabel.
  ///
  /// In ar, this message translates to:
  /// **'موقع الاستلام'**
  String get workshopRequestLocationLabel;

  /// No description provided for @workshopRequestVehicleLabel.
  ///
  /// In ar, this message translates to:
  /// **'السيارة'**
  String get workshopRequestVehicleLabel;

  /// No description provided for @workshopRejectRequest.
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلب'**
  String get workshopRejectRequest;

  /// No description provided for @workshopAcceptRequest.
  ///
  /// In ar, this message translates to:
  /// **'قبول الطلب'**
  String get workshopAcceptRequest;

  /// No description provided for @workshopPickupAcceptedEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تم قبول الاستلام'**
  String get workshopPickupAcceptedEyebrow;

  /// No description provided for @workshopAssignDriverTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعيين سائق'**
  String get workshopAssignDriverTitle;

  /// No description provided for @workshopAssignDriverSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أرسل ناقلة الورشة وشارك سياق الاستلام مع السائق المعين.'**
  String get workshopAssignDriverSubtitle;

  /// No description provided for @workshopRequestWorkshopDriver.
  ///
  /// In ar, this message translates to:
  /// **'طلب سائق الورشة'**
  String get workshopRequestWorkshopDriver;

  /// No description provided for @workshopIncomingEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تتبع السيارة القادمة'**
  String get workshopIncomingEyebrow;

  /// No description provided for @workshopIncomingVehicleTitle.
  ///
  /// In ar, this message translates to:
  /// **'السيارة القادمة'**
  String get workshopIncomingVehicleTitle;

  /// No description provided for @workshopIncomingVehicleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع السائق المعين وحرّك الوظيفة عند وصول السيارة إلى الورشة.'**
  String get workshopIncomingVehicleSubtitle;

  /// No description provided for @workshopEtaToWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'الوقت حتى الورشة'**
  String get workshopEtaToWorkshop;

  /// No description provided for @workshopMarkVehicleArrived.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد وصول السيارة'**
  String get workshopMarkVehicleArrived;

  /// No description provided for @workshopDriverUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السائق غير متاحة'**
  String get workshopDriverUnavailable;

  /// No description provided for @workshopJobNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على الوظيفة'**
  String get workshopJobNotFound;

  /// No description provided for @workshopActiveJobEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'خليج خدمة نشط'**
  String get workshopActiveJobEyebrow;

  /// No description provided for @workshopActiveJobTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الوظيفة النشطة'**
  String get workshopActiveJobTitle;

  /// No description provided for @workshopActiveJobSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أكد حالة السيارة داخل الورشة وابدأ تقرير التشخيص فور بدء الفحص.'**
  String get workshopActiveJobSubtitle;

  /// No description provided for @workshopPickupEstimateShort.
  ///
  /// In ar, this message translates to:
  /// **'تقدير الاستلام'**
  String get workshopPickupEstimateShort;

  /// No description provided for @workshopSpecialtyLabel.
  ///
  /// In ar, this message translates to:
  /// **'التخصص'**
  String get workshopSpecialtyLabel;

  /// No description provided for @workshopStartDiagnosis.
  ///
  /// In ar, this message translates to:
  /// **'بدء التشخيص'**
  String get workshopStartDiagnosis;

  /// No description provided for @workshopDiagnosisEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تقرير التشخيص'**
  String get workshopDiagnosisEyebrow;

  /// No description provided for @workshopCreateDiagnosisTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء التشخيص'**
  String get workshopCreateDiagnosisTitle;

  /// No description provided for @workshopCreateDiagnosisSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابنِ ملخص الإصلاح وقدر تكلفة العمالة والقطع ثم أرسل التقرير للموافقة.'**
  String get workshopCreateDiagnosisSubtitle;

  /// No description provided for @workshopDiagnosisSummaryLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملخص التشخيص'**
  String get workshopDiagnosisSummaryLabel;

  /// No description provided for @workshopLaborEstimateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تقدير العمالة'**
  String get workshopLaborEstimateLabel;

  /// No description provided for @workshopPartsEstimateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تقدير القطع'**
  String get workshopPartsEstimateLabel;

  /// No description provided for @workshopDiagnosisNotesLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات الفني'**
  String get workshopDiagnosisNotesLabel;

  /// No description provided for @workshopDiagnosisPhotosLabel.
  ///
  /// In ar, this message translates to:
  /// **'الصور المرفقة'**
  String get workshopDiagnosisPhotosLabel;

  /// No description provided for @workshopSubmitForApproval.
  ///
  /// In ar, this message translates to:
  /// **'إرسال للموافقة'**
  String get workshopSubmitForApproval;

  /// No description provided for @workshopApprovalEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'موافقة التشخيص'**
  String get workshopApprovalEyebrow;

  /// No description provided for @workshopApprovalPendingTitle.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الموافقة'**
  String get workshopApprovalPendingTitle;

  /// No description provided for @workshopApprovalPendingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال التقرير إلى العميل. أبقِ الوظيفة في هذه المرحلة حتى وصول الموافقة.'**
  String get workshopApprovalPendingSubtitle;

  /// No description provided for @workshopWaitingForCustomer.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار العميل'**
  String get workshopWaitingForCustomer;

  /// No description provided for @workshopEditReport.
  ///
  /// In ar, this message translates to:
  /// **'تعديل التقرير'**
  String get workshopEditReport;

  /// No description provided for @workshopMarkApproved.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الموافقة'**
  String get workshopMarkApproved;

  /// No description provided for @workshopServiceEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة قيد التنفيذ'**
  String get workshopServiceEyebrow;

  /// No description provided for @workshopServiceInProgressTitle.
  ///
  /// In ar, this message translates to:
  /// **'بدأت الخدمة'**
  String get workshopServiceInProgressTitle;

  /// No description provided for @workshopServiceInProgressSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع قائمة التنفيذ وانتقل إلى التسليم بعد اكتمال فحص الجودة.'**
  String get workshopServiceInProgressSubtitle;

  /// No description provided for @workshopServiceChecklistTitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة تنفيذ الخدمة'**
  String get workshopServiceChecklistTitle;

  /// No description provided for @workshopMarkServiceComplete.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد اكتمال الخدمة'**
  String get workshopMarkServiceComplete;

  /// No description provided for @workshopHandoverEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تهيئة التسليم'**
  String get workshopHandoverEyebrow;

  /// No description provided for @workshopHandoverTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختيار التسليم'**
  String get workshopHandoverTitle;

  /// No description provided for @workshopHandoverSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر ما إذا كان العميل سيستلم السيارة من الورشة أو ستعيدها الورشة إليه.'**
  String get workshopHandoverSubtitle;

  /// No description provided for @workshopReturnViaDriver.
  ///
  /// In ar, this message translates to:
  /// **'إرجاع عبر سائق الورشة'**
  String get workshopReturnViaDriver;

  /// No description provided for @workshopReturnViaDriverSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أرسل السيارة مرة أخرى مع سائق الورشة وأبقِ العميل مطلعًا.'**
  String get workshopReturnViaDriverSubtitle;

  /// No description provided for @workshopCustomerPickup.
  ///
  /// In ar, this message translates to:
  /// **'استلام العميل من الورشة'**
  String get workshopCustomerPickup;

  /// No description provided for @workshopCustomerPickupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سيقوم العميل باستلام السيارة مباشرة من الورشة.'**
  String get workshopCustomerPickupSubtitle;

  /// No description provided for @workshopRequestReturnDelivery.
  ///
  /// In ar, this message translates to:
  /// **'طلب توصيل الإرجاع'**
  String get workshopRequestReturnDelivery;

  /// No description provided for @workshopCompleteHandover.
  ///
  /// In ar, this message translates to:
  /// **'إكمال التسليم'**
  String get workshopCompleteHandover;

  /// No description provided for @workshopReturnEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'توصيل الإرجاع'**
  String get workshopReturnEyebrow;

  /// No description provided for @workshopRequestReturnTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب توصيل الإرجاع'**
  String get workshopRequestReturnTitle;

  /// No description provided for @workshopRequestReturnSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حضّر مرحلة الإرجاع الأخيرة وأكد طلب السائق للخروج من الورشة.'**
  String get workshopRequestReturnSubtitle;

  /// No description provided for @workshopReturnDriverNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة للسائق'**
  String get workshopReturnDriverNote;

  /// No description provided for @workshopReturnDriverNoteBody.
  ///
  /// In ar, this message translates to:
  /// **'العميل يحتاج اتصالًا قبل الوصول ويتطلب تحميلًا منخفض الارتفاع عند التسليم.'**
  String get workshopReturnDriverNoteBody;

  /// No description provided for @workshopRequestDriverForReturn.
  ///
  /// In ar, this message translates to:
  /// **'طلب سائق الورشة للإرجاع'**
  String get workshopRequestDriverForReturn;

  /// No description provided for @workshopReturnTrackingEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تتبع الإرجاع'**
  String get workshopReturnTrackingEyebrow;

  /// No description provided for @workshopReturnTrackingTitle.
  ///
  /// In ar, this message translates to:
  /// **'تتبع توصيل الإرجاع'**
  String get workshopReturnTrackingTitle;

  /// No description provided for @workshopReturnTrackingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع رحلة الإرجاع وأكد التسليم بعد استلام العميل للسيارة.'**
  String get workshopReturnTrackingSubtitle;

  /// No description provided for @workshopVehicleOutbound.
  ///
  /// In ar, this message translates to:
  /// **'السيارة في الطريق'**
  String get workshopVehicleOutbound;

  /// No description provided for @workshopMarkDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التسليم'**
  String get workshopMarkDelivered;

  /// No description provided for @workshopCompletedEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'اكتملت الوظيفة'**
  String get workshopCompletedEyebrow;

  /// No description provided for @workshopCompletedTitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتملت الوظيفة بنجاح'**
  String get workshopCompletedTitle;

  /// No description provided for @workshopCompletedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إغلاق الوظيفة وأصبح سجل الخدمة جاهزًا لتقارير الورشة.'**
  String get workshopCompletedSubtitle;

  /// No description provided for @workshopRevenueBreakdown.
  ///
  /// In ar, this message translates to:
  /// **'الإيراد'**
  String get workshopRevenueBreakdown;

  /// No description provided for @workshopCompletionTime.
  ///
  /// In ar, this message translates to:
  /// **'مدة التنفيذ'**
  String get workshopCompletionTime;

  /// No description provided for @workshopBackToDashboard.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الرئيسية'**
  String get workshopBackToDashboard;

  /// No description provided for @workshopMessagesEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'صندوق وارد الورشة'**
  String get workshopMessagesEyebrow;

  /// No description provided for @workshopMessagesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get workshopMessagesTitle;

  /// No description provided for @workshopMessagesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل مبسطة عمدًا في هذه المرحلة. يظل التدفق التشغيلي الأساسي داخل قسم الوظائف.'**
  String get workshopMessagesSubtitle;

  /// No description provided for @workshopMessagesEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد محادثات مباشرة'**
  String get workshopMessagesEmptyTitle;

  /// No description provided for @workshopMessagesEmptySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عند ربط الرسائل لاحقًا ستظهر تحديثات العملاء والسائقين هنا دون تغيير هيكل الورشة.'**
  String get workshopMessagesEmptySubtitle;

  /// No description provided for @workshopProfileEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'ملف الورشة'**
  String get workshopProfileEyebrow;

  /// No description provided for @workshopProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملف الورشة'**
  String get workshopProfileTitle;

  /// No description provided for @workshopProfileSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اعرض حالة الحساب والرؤية المالية والتفاصيل العامة المعروضة عبر OnlyCars.'**
  String get workshopProfileSubtitle;

  /// No description provided for @workshopProfileCurrentBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الحالي'**
  String get workshopProfileCurrentBalance;

  /// No description provided for @workshopProfilePendingPayout.
  ///
  /// In ar, this message translates to:
  /// **'دفعة معلقة'**
  String get workshopProfilePendingPayout;

  /// No description provided for @workshopProfileMonthlyRevenue.
  ///
  /// In ar, this message translates to:
  /// **'إيراد شهري'**
  String get workshopProfileMonthlyRevenue;

  /// No description provided for @workshopProfileCompletionRate.
  ///
  /// In ar, this message translates to:
  /// **'معدل الإكمال'**
  String get workshopProfileCompletionRate;

  /// No description provided for @workshopProfileContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'التواصل'**
  String get workshopProfileContactTitle;

  /// No description provided for @workshopProfileSpecialtiesTitle.
  ///
  /// In ar, this message translates to:
  /// **'التخصصات'**
  String get workshopProfileSpecialtiesTitle;

  /// No description provided for @workshopProfilePayoutTitle.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات'**
  String get workshopProfilePayoutTitle;

  /// No description provided for @workshopProfileResponseTime.
  ///
  /// In ar, this message translates to:
  /// **'زمن الاستجابة'**
  String get workshopProfileResponseTime;

  /// No description provided for @workshopStageNewRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد'**
  String get workshopStageNewRequest;

  /// No description provided for @workshopStageDriverAssignment.
  ///
  /// In ar, this message translates to:
  /// **'تعيين سائق'**
  String get workshopStageDriverAssignment;

  /// No description provided for @workshopStageIncomingTracking.
  ///
  /// In ar, this message translates to:
  /// **'قادمة'**
  String get workshopStageIncomingTracking;

  /// No description provided for @workshopStageActive.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get workshopStageActive;

  /// No description provided for @workshopStageApprovalPending.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الموافقة'**
  String get workshopStageApprovalPending;

  /// No description provided for @workshopStageServiceInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد التنفيذ'**
  String get workshopStageServiceInProgress;

  /// No description provided for @workshopStageHandover.
  ///
  /// In ar, this message translates to:
  /// **'تسليم'**
  String get workshopStageHandover;

  /// No description provided for @workshopStageReturnRequested.
  ///
  /// In ar, this message translates to:
  /// **'تم طلب الإرجاع'**
  String get workshopStageReturnRequested;

  /// No description provided for @workshopStageReturnTracking.
  ///
  /// In ar, this message translates to:
  /// **'تتبع الإرجاع'**
  String get workshopStageReturnTracking;

  /// No description provided for @workshopStageCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get workshopStageCompleted;

  /// No description provided for @shopShellDashboardTab.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get shopShellDashboardTab;

  /// No description provided for @shopShellOrdersTab.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get shopShellOrdersTab;

  /// No description provided for @shopShellProductsTab.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get shopShellProductsTab;

  /// No description provided for @shopShellMessagesTab.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get shopShellMessagesTab;

  /// No description provided for @shopShellProfileTab.
  ///
  /// In ar, this message translates to:
  /// **'الملف'**
  String get shopShellProfileTab;

  /// No description provided for @shopDashboardEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل القطع'**
  String get shopDashboardEyebrow;

  /// No description provided for @shopDashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة المتجر'**
  String get shopDashboardTitle;

  /// No description provided for @shopDashboardSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدر تشغيل متجر القطع المميزة مع رؤية واضحة للتوصيل والمخزون وواجهة هادئة تعتمد تدرجات الأزرق الخاصة بالمشروع.'**
  String get shopDashboardSubtitle;

  /// No description provided for @shopMetricPendingOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات معلقة'**
  String get shopMetricPendingOrders;

  /// No description provided for @shopMetricOutForDelivery.
  ///
  /// In ar, this message translates to:
  /// **'خارج للتوصيل'**
  String get shopMetricOutForDelivery;

  /// No description provided for @shopMetricLowStock.
  ///
  /// In ar, this message translates to:
  /// **'مخزون منخفض'**
  String get shopMetricLowStock;

  /// No description provided for @shopMetricTodayRevenue.
  ///
  /// In ar, this message translates to:
  /// **'إيراد اليوم'**
  String get shopMetricTodayRevenue;

  /// No description provided for @shopQuickActionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات سريعة'**
  String get shopQuickActionsTitle;

  /// No description provided for @shopQuickActionOrders.
  ///
  /// In ar, this message translates to:
  /// **'فتح الطلبات'**
  String get shopQuickActionOrders;

  /// No description provided for @shopQuickActionProducts.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المنتجات'**
  String get shopQuickActionProducts;

  /// No description provided for @shopQuickActionProfile.
  ///
  /// In ar, this message translates to:
  /// **'عرض الملف'**
  String get shopQuickActionProfile;

  /// No description provided for @shopQuickActionDelivery.
  ///
  /// In ar, this message translates to:
  /// **'تتبع التوصيل'**
  String get shopQuickActionDelivery;

  /// No description provided for @shopOperationalQueueTitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة التشغيل'**
  String get shopOperationalQueueTitle;

  /// No description provided for @shopFeaturedPartsTitle.
  ///
  /// In ar, this message translates to:
  /// **'مخزون مميز'**
  String get shopFeaturedPartsTitle;

  /// No description provided for @shopSeeAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get shopSeeAll;

  /// No description provided for @shopOrdersEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'قائمة التنفيذ'**
  String get shopOrdersEyebrow;

  /// No description provided for @shopOrdersTitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الطلبات'**
  String get shopOrdersTitle;

  /// No description provided for @shopOrdersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع الطلبات الجديدة وحركة السائقين والطلبات المكتملة من قائمة تشغيل واحدة.'**
  String get shopOrdersSubtitle;

  /// No description provided for @shopOrdersFilterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get shopOrdersFilterAll;

  /// No description provided for @shopOrdersFilterActive.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get shopOrdersFilterActive;

  /// No description provided for @shopOrdersFilterCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get shopOrdersFilterCompleted;

  /// No description provided for @shopProductsEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'التحكم بالمخزون'**
  String get shopProductsEyebrow;

  /// No description provided for @shopProductsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات والمخزون'**
  String get shopProductsTitle;

  /// No description provided for @shopProductsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حافظ على وضوح مستويات المخزون وأظهر النقص مبكرًا وأضف القطع الجديدة مباشرة من شاشة المنتجات.'**
  String get shopProductsSubtitle;

  /// No description provided for @shopAddPart.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قطعة'**
  String get shopAddPart;

  /// No description provided for @shopLowStock.
  ///
  /// In ar, this message translates to:
  /// **'مخزون منخفض'**
  String get shopLowStock;

  /// No description provided for @shopInStock.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get shopInStock;

  /// No description provided for @shopInlineAddTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنصر للمخزون'**
  String get shopInlineAddTitle;

  /// No description provided for @shopInlineAddSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تتم إضافة المخزون السريع من شاشة المنتجات بدلًا من مسار منفصل.'**
  String get shopInlineAddSubtitle;

  /// No description provided for @shopFieldPartName.
  ///
  /// In ar, this message translates to:
  /// **'اسم القطعة'**
  String get shopFieldPartName;

  /// No description provided for @shopFieldPartSku.
  ///
  /// In ar, this message translates to:
  /// **'رمز SKU'**
  String get shopFieldPartSku;

  /// No description provided for @shopFieldPartPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get shopFieldPartPrice;

  /// No description provided for @shopFieldPartStock.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get shopFieldPartStock;

  /// No description provided for @shopSavePart.
  ///
  /// In ar, this message translates to:
  /// **'حفظ القطعة'**
  String get shopSavePart;

  /// No description provided for @shopMessagesEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'صندوق المتجر'**
  String get shopMessagesEyebrow;

  /// No description provided for @shopMessagesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get shopMessagesTitle;

  /// No description provided for @shopMessagesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل مبسطة عمدًا في هذه المرحلة. يبقى تشغيل الطلبات والتوصيل داخل قسم الطلبات.'**
  String get shopMessagesSubtitle;

  /// No description provided for @shopMessagesEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل لاحقًا'**
  String get shopMessagesEmptyTitle;

  /// No description provided for @shopMessagesEmptySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'هذا الموضع يحافظ على اكتمال الشريط السفلي بينما يتم تأجيل صندوق الرسائل المتصل بين العملاء والسائقين إلى مرحلة لاحقة.'**
  String get shopMessagesEmptySubtitle;

  /// No description provided for @shopProfileEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'ملف البائع'**
  String get shopProfileEyebrow;

  /// No description provided for @shopProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملف المتجر'**
  String get shopProfileTitle;

  /// No description provided for @shopProfileSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع وضع الدفعات والتفاصيل العامة للتاجر ونطاق التوصيل المميز الظاهر للعملاء.'**
  String get shopProfileSubtitle;

  /// No description provided for @shopProfileBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد المتاح'**
  String get shopProfileBalance;

  /// No description provided for @shopProfileOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات هذا الأسبوع'**
  String get shopProfileOrders;

  /// No description provided for @shopProfileRating.
  ///
  /// In ar, this message translates to:
  /// **'تقييم المتجر'**
  String get shopProfileRating;

  /// No description provided for @shopProfileResponseTime.
  ///
  /// In ar, this message translates to:
  /// **'زمن الاستجابة'**
  String get shopProfileResponseTime;

  /// No description provided for @shopProfileContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'التواصل'**
  String get shopProfileContactTitle;

  /// No description provided for @shopProfileCoverageTitle.
  ///
  /// In ar, this message translates to:
  /// **'التغطية'**
  String get shopProfileCoverageTitle;

  /// No description provided for @shopProfileHoursTitle.
  ///
  /// In ar, this message translates to:
  /// **'ساعات العمل'**
  String get shopProfileHoursTitle;

  /// No description provided for @shopOrderNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على الطلب'**
  String get shopOrderNotFound;

  /// No description provided for @shopOrderDetailEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'استقبال الطلب'**
  String get shopOrderDetailEyebrow;

  /// No description provided for @shopOrderDetailTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get shopOrderDetailTitle;

  /// No description provided for @shopOrderDetailSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أكد بيانات العميل والعناصر ومعلومات التوصيل قبل نقل الطرد إلى التعبئة.'**
  String get shopOrderDetailSubtitle;

  /// No description provided for @shopPackingEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'منطقة التعبئة'**
  String get shopPackingEyebrow;

  /// No description provided for @shopPackingTitle.
  ///
  /// In ar, this message translates to:
  /// **'عرض التعبئة'**
  String get shopPackingTitle;

  /// No description provided for @shopPackingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ثبت قائمة الالتقاط وعبّئ العناصر وجهز الطلب لتسليمه إلى السائق.'**
  String get shopPackingSubtitle;

  /// No description provided for @shopDeliveryRequestEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'طلب التوصيل'**
  String get shopDeliveryRequestEyebrow;

  /// No description provided for @shopDeliveryRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب التوصيل'**
  String get shopDeliveryRequestTitle;

  /// No description provided for @shopDeliveryRequestSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من الوجهة وأرسل طلب التوصيل بعد أن يصبح الطرد جاهزًا لمغادرة المتجر.'**
  String get shopDeliveryRequestSubtitle;

  /// No description provided for @shopSearchingDriverEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'مطابقة السائق'**
  String get shopSearchingDriverEyebrow;

  /// No description provided for @shopSearchingDriverTitle.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن سائق'**
  String get shopSearchingDriverTitle;

  /// No description provided for @shopSearchingDriverSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أبقِ الطلب في مرحلة المطابقة حتى يتم تأكيد سعة السائق.'**
  String get shopSearchingDriverSubtitle;

  /// No description provided for @shopCourierAssignedEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد السائق'**
  String get shopCourierAssignedEyebrow;

  /// No description provided for @shopCourierAssignedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تعيين السائق'**
  String get shopCourierAssignedTitle;

  /// No description provided for @shopCourierAssignedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تثبيت هوية السائق ووقت الوصول. جهز الطرد لتسليم منظم.'**
  String get shopCourierAssignedSubtitle;

  /// No description provided for @shopHandoverEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'تسليم الخروج'**
  String get shopHandoverEyebrow;

  /// No description provided for @shopHandoverTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسليم إلى السائق'**
  String get shopHandoverTitle;

  /// No description provided for @shopHandoverSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من الطرد وختم الإرسال وبيانات السائق قبل تسليم الشحنة.'**
  String get shopHandoverSubtitle;

  /// No description provided for @shopTrackingEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'المسار المباشر'**
  String get shopTrackingEyebrow;

  /// No description provided for @shopTrackingTitle.
  ///
  /// In ar, this message translates to:
  /// **'تتبع التوصيل'**
  String get shopTrackingTitle;

  /// No description provided for @shopTrackingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'غادر الطرد المتجر. تابع المسار وأغلق الطلب عند تأكيد التسليم.'**
  String get shopTrackingSubtitle;

  /// No description provided for @shopCompletedEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'إثبات التسليم'**
  String get shopCompletedEyebrow;

  /// No description provided for @shopCompletedTitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتمل التوصيل'**
  String get shopCompletedTitle;

  /// No description provided for @shopCompletedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل إثبات التسليم وأصبح الطلب في الحالة المغلقة.'**
  String get shopCompletedSubtitle;

  /// No description provided for @shopOrderItemsTitle.
  ///
  /// In ar, this message translates to:
  /// **'عناصر الطلب'**
  String get shopOrderItemsTitle;

  /// No description provided for @shopCourierCardTitle.
  ///
  /// In ar, this message translates to:
  /// **'السائق المعين'**
  String get shopCourierCardTitle;

  /// No description provided for @shopCustomerDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'العميل والتوصيل'**
  String get shopCustomerDetailsTitle;

  /// No description provided for @shopTrackingCodeLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز التتبع'**
  String get shopTrackingCodeLabel;

  /// No description provided for @shopOrderTimelineTitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة التشغيل'**
  String get shopOrderTimelineTitle;

  /// No description provided for @shopDeliveryWindowLabel.
  ///
  /// In ar, this message translates to:
  /// **'نافذة التوصيل'**
  String get shopDeliveryWindowLabel;

  /// No description provided for @shopVehicleLabel.
  ///
  /// In ar, this message translates to:
  /// **'السيارة'**
  String get shopVehicleLabel;

  /// No description provided for @shopPrimaryAddressLabel.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get shopPrimaryAddressLabel;

  /// No description provided for @shopStartPacking.
  ///
  /// In ar, this message translates to:
  /// **'بدء التعبئة'**
  String get shopStartPacking;

  /// No description provided for @shopRequestCourier.
  ///
  /// In ar, this message translates to:
  /// **'طلب سائق'**
  String get shopRequestCourier;

  /// No description provided for @shopSendDeliveryRequest.
  ///
  /// In ar, this message translates to:
  /// **'إرسال طلب التوصيل'**
  String get shopSendDeliveryRequest;

  /// No description provided for @shopSimulateDriverAssigned.
  ///
  /// In ar, this message translates to:
  /// **'محاكاة تعيين السائق'**
  String get shopSimulateDriverAssigned;

  /// No description provided for @shopContinueToHandover.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة إلى التسليم'**
  String get shopContinueToHandover;

  /// No description provided for @shopConfirmHandover.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التسليم'**
  String get shopConfirmHandover;

  /// No description provided for @shopMarkDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التسليم'**
  String get shopMarkDelivered;

  /// No description provided for @shopBackToOrders.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الطلبات'**
  String get shopBackToOrders;

  /// No description provided for @shopBackToDashboard.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الرئيسية'**
  String get shopBackToDashboard;

  /// No description provided for @shopStageNewOrder.
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد'**
  String get shopStageNewOrder;

  /// No description provided for @shopStagePacking.
  ///
  /// In ar, this message translates to:
  /// **'تعبئة'**
  String get shopStagePacking;

  /// No description provided for @shopStageDeliveryRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب توصيل'**
  String get shopStageDeliveryRequest;

  /// No description provided for @shopStageSearchingDriver.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get shopStageSearchingDriver;

  /// No description provided for @shopStageCourierAssigned.
  ///
  /// In ar, this message translates to:
  /// **'معين'**
  String get shopStageCourierAssigned;

  /// No description provided for @shopStageHandover.
  ///
  /// In ar, this message translates to:
  /// **'تسليم'**
  String get shopStageHandover;

  /// No description provided for @shopStageTracking.
  ///
  /// In ar, this message translates to:
  /// **'تتبع'**
  String get shopStageTracking;

  /// No description provided for @shopStageCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get shopStageCompleted;

  /// No description provided for @driverShellDashboardTab.
  ///
  /// In ar, this message translates to:
  /// **'لوحة القيادة'**
  String get driverShellDashboardTab;

  /// No description provided for @driverShellOrdersTab.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get driverShellOrdersTab;

  /// No description provided for @driverShellEarningsTab.
  ///
  /// In ar, this message translates to:
  /// **'الأرباح'**
  String get driverShellEarningsTab;

  /// No description provided for @driverShellMessagesTab.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get driverShellMessagesTab;

  /// No description provided for @driverShellProfileTab.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get driverShellProfileTab;

  /// No description provided for @driverDashboardEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'عمليات التوصيل'**
  String get driverDashboardEyebrow;

  /// No description provided for @driverDashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة المندوب'**
  String get driverDashboardTitle;

  /// No description provided for @driverDashboardSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع طلبات التوصيل وأرباحك وحالة المهام من واجهة تشغيل واحدة بالهوية الزرقاء الجديدة.'**
  String get driverDashboardSubtitle;

  /// No description provided for @driverAvailabilityOnTitle.
  ///
  /// In ar, this message translates to:
  /// **'متاح للتوزيع'**
  String get driverAvailabilityOnTitle;

  /// No description provided for @driverAvailabilityOnSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمكن إسناد طلبات قطع الغيار القريبة إليك فورًا.'**
  String get driverAvailabilityOnSubtitle;

  /// No description provided for @driverAvailabilityOffTitle.
  ///
  /// In ar, this message translates to:
  /// **'غير متاح الآن'**
  String get driverAvailabilityOffTitle;

  /// No description provided for @driverAvailabilityOffSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إيقاف الطلبات الجديدة حتى تعود إلى وضع المتاح.'**
  String get driverAvailabilityOffSubtitle;

  /// No description provided for @driverMetricTodayTrips.
  ///
  /// In ar, this message translates to:
  /// **'رحلات اليوم'**
  String get driverMetricTodayTrips;

  /// No description provided for @driverMetricTodayEarnings.
  ///
  /// In ar, this message translates to:
  /// **'أرباح اليوم'**
  String get driverMetricTodayEarnings;

  /// No description provided for @driverMetricPendingRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات معلقة'**
  String get driverMetricPendingRequests;

  /// No description provided for @driverMetricActiveDeliveries.
  ///
  /// In ar, this message translates to:
  /// **'توصيلات نشطة'**
  String get driverMetricActiveDeliveries;

  /// No description provided for @driverQuickActionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات سريعة'**
  String get driverQuickActionsTitle;

  /// No description provided for @driverQuickActionOrders.
  ///
  /// In ar, this message translates to:
  /// **'فتح الطلبات'**
  String get driverQuickActionOrders;

  /// No description provided for @driverQuickActionEarnings.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأرباح'**
  String get driverQuickActionEarnings;

  /// No description provided for @driverQuickActionProfile.
  ///
  /// In ar, this message translates to:
  /// **'فتح الملف الشخصي'**
  String get driverQuickActionProfile;

  /// No description provided for @driverLiveDeliveryTitle.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل الجاري'**
  String get driverLiveDeliveryTitle;

  /// No description provided for @driverNewRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات جديدة'**
  String get driverNewRequestsTitle;

  /// No description provided for @driverSeeAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get driverSeeAll;

  /// No description provided for @driverOrdersEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'صف التوصيل'**
  String get driverOrdersEyebrow;

  /// No description provided for @driverOrdersTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل الطلبات'**
  String get driverOrdersTitle;

  /// No description provided for @driverOrdersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع الطلبات الجديدة والمهام الجارية والرحلات المكتملة من قائمة واحدة.'**
  String get driverOrdersSubtitle;

  /// No description provided for @driverOrdersFilterNew.
  ///
  /// In ar, this message translates to:
  /// **'جديدة'**
  String get driverOrdersFilterNew;

  /// No description provided for @driverOrdersFilterActive.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get driverOrdersFilterActive;

  /// No description provided for @driverOrdersFilterCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get driverOrdersFilterCompleted;

  /// No description provided for @driverOrdersEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مهام ضمن هذا التصنيف بعد.'**
  String get driverOrdersEmpty;

  /// No description provided for @driverEarningsEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الأرباح'**
  String get driverEarningsEyebrow;

  /// No description provided for @driverEarningsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأرباح والمعاملات'**
  String get driverEarningsTitle;

  /// No description provided for @driverEarningsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع أرباح اليوم والمدفوعات المعلقة وسجل العمليات المرتبط بالرحلات المكتملة.'**
  String get driverEarningsSubtitle;

  /// No description provided for @driverEarningsToday.
  ///
  /// In ar, this message translates to:
  /// **'أرباح اليوم'**
  String get driverEarningsToday;

  /// No description provided for @driverEarningsPending.
  ///
  /// In ar, this message translates to:
  /// **'دفعات معلقة'**
  String get driverEarningsPending;

  /// No description provided for @driverEarningsThisWeek.
  ///
  /// In ar, this message translates to:
  /// **'هذا الأسبوع'**
  String get driverEarningsThisWeek;

  /// No description provided for @driverEarningsCompletion.
  ///
  /// In ar, this message translates to:
  /// **'معدل الإنجاز'**
  String get driverEarningsCompletion;

  /// No description provided for @driverTransactionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المعاملات'**
  String get driverTransactionsTitle;

  /// No description provided for @driverTransactionPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get driverTransactionPaid;

  /// No description provided for @driverTransactionProcessing.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get driverTransactionProcessing;

  /// No description provided for @driverMessagesEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'صندوق المندوب'**
  String get driverMessagesEyebrow;

  /// No description provided for @driverMessagesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get driverMessagesTitle;

  /// No description provided for @driverMessagesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحديثات التوزيع ورسائل المتاجر والورش تظهر هنا ضمن قائمة موحدة للمندوب.'**
  String get driverMessagesSubtitle;

  /// No description provided for @driverMessagesSupportTitle.
  ///
  /// In ar, this message translates to:
  /// **'دعم التوزيع'**
  String get driverMessagesSupportTitle;

  /// No description provided for @driverMessagesSupportSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تجميع التحديثات التشغيلية هنا مع إبقاء هذا المسار واجهة فقط في هذه المرحلة.'**
  String get driverMessagesSupportSubtitle;

  /// No description provided for @driverProfileEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'هوية المندوب'**
  String get driverProfileEyebrow;

  /// No description provided for @driverProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get driverProfileTitle;

  /// No description provided for @driverProfileSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع نطاق الخدمة ووضع الأرباح والتفاصيل العامة للمندوب داخل OnlyCars.'**
  String get driverProfileSubtitle;

  /// No description provided for @driverProfileTrips.
  ///
  /// In ar, this message translates to:
  /// **'الرحلات'**
  String get driverProfileTrips;

  /// No description provided for @driverProfileRating.
  ///
  /// In ar, this message translates to:
  /// **'التقييم'**
  String get driverProfileRating;

  /// No description provided for @driverProfileCompletion.
  ///
  /// In ar, this message translates to:
  /// **'الإنجاز'**
  String get driverProfileCompletion;

  /// No description provided for @driverProfileMonthlyPayout.
  ///
  /// In ar, this message translates to:
  /// **'أرباح الشهر'**
  String get driverProfileMonthlyPayout;

  /// No description provided for @driverProfileContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'التواصل'**
  String get driverProfileContactTitle;

  /// No description provided for @driverProfileCoverageTitle.
  ///
  /// In ar, this message translates to:
  /// **'نطاق الخدمة'**
  String get driverProfileCoverageTitle;

  /// No description provided for @driverProfileVehicleTitle.
  ///
  /// In ar, this message translates to:
  /// **'المركبة'**
  String get driverProfileVehicleTitle;

  /// No description provided for @driverEmailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get driverEmailLabel;

  /// No description provided for @driverRequestEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'طلب توزيع'**
  String get driverRequestEyebrow;

  /// No description provided for @driverRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب توصيل جديد'**
  String get driverRequestTitle;

  /// No description provided for @driverRequestSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع تفاصيل الاستلام والتسليم والعائد قبل تثبيت المهمة على حسابك.'**
  String get driverRequestSubtitle;

  /// No description provided for @driverNavigationEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'المسار الجاري'**
  String get driverNavigationEyebrow;

  /// No description provided for @driverNavigationTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملاحة التوصيل النشط'**
  String get driverNavigationTitle;

  /// No description provided for @driverNavigationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الملاحة مركزة على المهمة الحالية. حافظ على وقت الوصول وانتقل للتأكيد بعد وصول الشحنة.'**
  String get driverNavigationSubtitle;

  /// No description provided for @driverConfirmEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'إثبات التسليم'**
  String get driverConfirmEyebrow;

  /// No description provided for @driverConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التسليم'**
  String get driverConfirmTitle;

  /// No description provided for @driverConfirmSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من المستلم وسجّل التسليم النهائي لإغلاق الرحلة وصرف العائد.'**
  String get driverConfirmSubtitle;

  /// No description provided for @driverCompletedEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق الرحلة'**
  String get driverCompletedEyebrow;

  /// No description provided for @driverCompletedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get driverCompletedTitle;

  /// No description provided for @driverCompletedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد التسليم وأصبحت الرحلة مسجلة ضمن أرباحك.'**
  String get driverCompletedSubtitle;

  /// No description provided for @driverRequestDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get driverRequestDetailsTitle;

  /// No description provided for @driverPickupDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الاستلام'**
  String get driverPickupDetailsTitle;

  /// No description provided for @driverDropoffDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل التسليم'**
  String get driverDropoffDetailsTitle;

  /// No description provided for @driverRecipientTitle.
  ///
  /// In ar, this message translates to:
  /// **'المستلم'**
  String get driverRecipientTitle;

  /// No description provided for @driverTrackingCodeLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز التتبع'**
  String get driverTrackingCodeLabel;

  /// No description provided for @driverPickupWindowLabel.
  ///
  /// In ar, this message translates to:
  /// **'نافذة الاستلام'**
  String get driverPickupWindowLabel;

  /// No description provided for @driverDropoffWindowLabel.
  ///
  /// In ar, this message translates to:
  /// **'نافذة التسليم'**
  String get driverDropoffWindowLabel;

  /// No description provided for @driverDistanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'المسافة'**
  String get driverDistanceLabel;

  /// No description provided for @driverPayoutLabel.
  ///
  /// In ar, this message translates to:
  /// **'العائد'**
  String get driverPayoutLabel;

  /// No description provided for @driverRecipientLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستلم'**
  String get driverRecipientLabel;

  /// No description provided for @driverNoteLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة'**
  String get driverNoteLabel;

  /// No description provided for @driverAcceptDelivery.
  ///
  /// In ar, this message translates to:
  /// **'قبول التوصيل'**
  String get driverAcceptDelivery;

  /// No description provided for @driverProceedToConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة إلى التأكيد'**
  String get driverProceedToConfirmation;

  /// No description provided for @driverMarkDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تحديد كمكتمل'**
  String get driverMarkDelivered;

  /// No description provided for @driverBackToOrders.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الطلبات'**
  String get driverBackToOrders;

  /// No description provided for @driverBackToDashboard.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى اللوحة'**
  String get driverBackToDashboard;

  /// No description provided for @driverStageNewRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد'**
  String get driverStageNewRequest;

  /// No description provided for @driverStageNavigation.
  ///
  /// In ar, this message translates to:
  /// **'ملاحة'**
  String get driverStageNavigation;

  /// No description provided for @driverStageConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get driverStageConfirm;

  /// No description provided for @driverStageCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get driverStageCompleted;

  /// No description provided for @driverDeliveryNotFound.
  ///
  /// In ar, this message translates to:
  /// **'تعذر العثور على هذه المهمة.'**
  String get driverDeliveryNotFound;

  /// No description provided for @driverNavigationChecklistOne.
  ///
  /// In ar, this message translates to:
  /// **'اتبع المسار المعتمد من التوزيع للحفاظ على موعد الورشة.'**
  String get driverNavigationChecklistOne;

  /// No description provided for @driverNavigationChecklistTwo.
  ///
  /// In ar, this message translates to:
  /// **'اتصل مسبقًا إذا تغيّر وقت الوصول بأكثر من خمس دقائق.'**
  String get driverNavigationChecklistTwo;

  /// No description provided for @driverNavigationChecklistThree.
  ///
  /// In ar, this message translates to:
  /// **'أبقِ الشحنة مختومة حتى يتحقق المستلم من التسليم.'**
  String get driverNavigationChecklistThree;

  /// No description provided for @driverConfirmHeroNote.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد المستلم هو الخطوة الأخيرة قبل تحرير العائد.'**
  String get driverConfirmHeroNote;

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
