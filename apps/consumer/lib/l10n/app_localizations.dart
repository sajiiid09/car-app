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
  /// **'OnlyCars'**
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

  /// No description provided for @otpHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المكون من 6 أرقام'**
  String get otpHint;

  /// No description provided for @resendOtp.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال'**
  String get resendOtp;

  /// No description provided for @profileSetup.
  ///
  /// In ar, this message translates to:
  /// **'إعداد الملف الشخصي'**
  String get profileSetup;

  /// No description provided for @name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get name;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @workshops.
  ///
  /// In ar, this message translates to:
  /// **'الورش'**
  String get workshops;

  /// No description provided for @marketplace.
  ///
  /// In ar, this message translates to:
  /// **'سوق القطع'**
  String get marketplace;

  /// No description provided for @orders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get orders;

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

  /// No description provided for @myCars.
  ///
  /// In ar, this message translates to:
  /// **'سياراتي'**
  String get myCars;

  /// No description provided for @activeOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات نشطة'**
  String get activeOrders;

  /// No description provided for @newReports.
  ///
  /// In ar, this message translates to:
  /// **'تقارير جديدة'**
  String get newReports;

  /// No description provided for @workshopMap.
  ///
  /// In ar, this message translates to:
  /// **'خريطة الورش'**
  String get workshopMap;

  /// No description provided for @addVehicle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة سيارة'**
  String get addVehicle;

  /// No description provided for @diagnosisReport.
  ///
  /// In ar, this message translates to:
  /// **'تقرير الفحص'**
  String get diagnosisReport;

  /// No description provided for @chat.
  ///
  /// In ar, this message translates to:
  /// **'المحادثة'**
  String get chat;

  /// No description provided for @cart.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get cart;

  /// No description provided for @checkout.
  ///
  /// In ar, this message translates to:
  /// **'الدفع'**
  String get checkout;

  /// No description provided for @orderTracking.
  ///
  /// In ar, this message translates to:
  /// **'تتبع الطلب'**
  String get orderTracking;

  /// No description provided for @workshopBill.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة الورشة'**
  String get workshopBill;

  /// No description provided for @rateWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'تقييم الورشة'**
  String get rateWorkshop;

  /// No description provided for @carHealthVault.
  ///
  /// In ar, this message translates to:
  /// **'سجل صحة السيارة'**
  String get carHealthVault;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @approve.
  ///
  /// In ar, this message translates to:
  /// **'موافق'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get reject;

  /// No description provided for @negotiate.
  ///
  /// In ar, this message translates to:
  /// **'تفاوض'**
  String get negotiate;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In ar, this message translates to:
  /// **'فلتر'**
  String get filter;

  /// No description provided for @addToCart.
  ///
  /// In ar, this message translates to:
  /// **'إضافة للسلة'**
  String get addToCart;

  /// No description provided for @workshopCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الورشة'**
  String get workshopCode;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get total;

  /// No description provided for @pay.
  ///
  /// In ar, this message translates to:
  /// **'ادفع'**
  String get pay;

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

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @noInternet.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت'**
  String get noInternet;

  /// No description provided for @discoveryNavProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get discoveryNavProfile;

  /// No description provided for @discoveryNavChat.
  ///
  /// In ar, this message translates to:
  /// **'المحادثة'**
  String get discoveryNavChat;

  /// No description provided for @discoveryNavOrders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get discoveryNavOrders;

  /// No description provided for @discoveryNavMap.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get discoveryNavMap;

  /// No description provided for @discoveryNavHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get discoveryNavHome;

  /// No description provided for @discoveryWelcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك، {name}'**
  String discoveryWelcomeBack(String name);

  /// No description provided for @discoverySearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن ورش وقطع...'**
  String get discoverySearchHint;

  /// No description provided for @discoveryMapLabel.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get discoveryMapLabel;

  /// No description provided for @discoveryListLabel.
  ///
  /// In ar, this message translates to:
  /// **'القائمة'**
  String get discoveryListLabel;

  /// No description provided for @discoveryServicesLabel.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get discoveryServicesLabel;

  /// No description provided for @discoveryPartsLabel.
  ///
  /// In ar, this message translates to:
  /// **'القطع'**
  String get discoveryPartsLabel;

  /// No description provided for @discoverySummerEssentials.
  ///
  /// In ar, this message translates to:
  /// **'أساسيات الصيف'**
  String get discoverySummerEssentials;

  /// No description provided for @discoveryHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'قم بترقية سيارتك بخصم 25٪ على القطع'**
  String get discoveryHeroTitle;

  /// No description provided for @discoveryShopCollection.
  ///
  /// In ar, this message translates to:
  /// **'تسوّق المجموعة'**
  String get discoveryShopCollection;

  /// No description provided for @discoveryPremiumCare.
  ///
  /// In ar, this message translates to:
  /// **'عناية مميزة'**
  String get discoveryPremiumCare;

  /// No description provided for @discoveryHeroSecondaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ورش معتمدة جاهزة لخدمة حجزك القادم'**
  String get discoveryHeroSecondaryTitle;

  /// No description provided for @discoveryBookNow.
  ///
  /// In ar, this message translates to:
  /// **'احجز الآن'**
  String get discoveryBookNow;

  /// No description provided for @discoveryOrderInTransitTitle.
  ///
  /// In ar, this message translates to:
  /// **'في الطريق: {itemName}'**
  String discoveryOrderInTransitTitle(String itemName);

  /// No description provided for @discoveryDiagnosticTitle.
  ///
  /// In ar, this message translates to:
  /// **'أداة الفحص التشخيصي'**
  String get discoveryDiagnosticTitle;

  /// No description provided for @discoveryDiagnosticSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اربط مركبتك واحصل على تقارير فورية عن الحالة ومسح للأخطاء وبيانات الأداء.'**
  String get discoveryDiagnosticSubtitle;

  /// No description provided for @discoveryLearnMore.
  ///
  /// In ar, this message translates to:
  /// **'اعرف المزيد'**
  String get discoveryLearnMore;

  /// No description provided for @discoveryUploadImage.
  ///
  /// In ar, this message translates to:
  /// **'ارفع صورتك'**
  String get discoveryUploadImage;

  /// No description provided for @discoveryRecommended.
  ///
  /// In ar, this message translates to:
  /// **'موصى به'**
  String get discoveryRecommended;

  /// No description provided for @discoveryRatingFilter.
  ///
  /// In ar, this message translates to:
  /// **'تقييم 4.5+'**
  String get discoveryRatingFilter;

  /// No description provided for @discoveryDistanceFilter.
  ///
  /// In ar, this message translates to:
  /// **'المسافة'**
  String get discoveryDistanceFilter;

  /// No description provided for @discoveryTopRatedWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'أفضل ورشة'**
  String get discoveryTopRatedWorkshop;

  /// No description provided for @discoveryViewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get discoveryViewAll;

  /// No description provided for @discoveryPopularParts.
  ///
  /// In ar, this message translates to:
  /// **'قطع رائجة'**
  String get discoveryPopularParts;

  /// No description provided for @discoveryExploreStore.
  ///
  /// In ar, this message translates to:
  /// **'استكشف المتجر'**
  String get discoveryExploreStore;

  /// No description provided for @discoveryPopularServices.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات الشائعة'**
  String get discoveryPopularServices;

  /// No description provided for @discoveryNearbyWorkshops.
  ///
  /// In ar, this message translates to:
  /// **'ورش قريبة'**
  String get discoveryNearbyWorkshops;

  /// No description provided for @discoverySeeAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get discoverySeeAll;

  /// No description provided for @discoveryBookService.
  ///
  /// In ar, this message translates to:
  /// **'احجز الخدمة'**
  String get discoveryBookService;

  /// No description provided for @discoveryWorkshopFallbackLocation.
  ///
  /// In ar, this message translates to:
  /// **'الدوحة'**
  String get discoveryWorkshopFallbackLocation;

  /// No description provided for @discoveryLuxuryExpert.
  ///
  /// In ar, this message translates to:
  /// **'خبير فاخر'**
  String get discoveryLuxuryExpert;

  /// No description provided for @discoveryAuthorizedDealer.
  ///
  /// In ar, this message translates to:
  /// **'وكيل معتمد'**
  String get discoveryAuthorizedDealer;

  /// No description provided for @discoveryOilChange.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الزيت'**
  String get discoveryOilChange;

  /// No description provided for @discoveryBrakeService.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الفرامل'**
  String get discoveryBrakeService;

  /// No description provided for @discoveryAcRepair.
  ///
  /// In ar, this message translates to:
  /// **'إصلاح التكييف'**
  String get discoveryAcRepair;

  /// No description provided for @discoveryRegularCheckup.
  ///
  /// In ar, this message translates to:
  /// **'فحص دوري'**
  String get discoveryRegularCheckup;

  /// No description provided for @discoveryPrecisionParts.
  ///
  /// In ar, this message translates to:
  /// **'قطع دقيقة'**
  String get discoveryPrecisionParts;

  /// No description provided for @discoveryPartsSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن قطع أصلية أو أرقام تسلسلية...'**
  String get discoveryPartsSearchHint;

  /// No description provided for @discoveryFilters.
  ///
  /// In ar, this message translates to:
  /// **'فلاتر'**
  String get discoveryFilters;

  /// No description provided for @discoveryBrandToyota.
  ///
  /// In ar, this message translates to:
  /// **'العلامة: تويوتا'**
  String get discoveryBrandToyota;

  /// No description provided for @discoveryPriceRange.
  ///
  /// In ar, this message translates to:
  /// **'نطاق السعر'**
  String get discoveryPriceRange;

  /// No description provided for @discoveryInStock.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get discoveryInStock;

  /// No description provided for @discoveryEngine.
  ///
  /// In ar, this message translates to:
  /// **'المحرك'**
  String get discoveryEngine;

  /// No description provided for @discoveryExterior.
  ///
  /// In ar, this message translates to:
  /// **'الخارجي'**
  String get discoveryExterior;

  /// No description provided for @discoveryLighting.
  ///
  /// In ar, this message translates to:
  /// **'الإضاءة'**
  String get discoveryLighting;

  /// No description provided for @discoveryTires.
  ///
  /// In ar, this message translates to:
  /// **'الإطارات'**
  String get discoveryTires;

  /// No description provided for @discoveryElectrical.
  ///
  /// In ar, this message translates to:
  /// **'الكهرباء'**
  String get discoveryElectrical;

  /// No description provided for @discoveryGenuine.
  ///
  /// In ar, this message translates to:
  /// **'أصلي'**
  String get discoveryGenuine;

  /// No description provided for @discoveryPopular.
  ///
  /// In ar, this message translates to:
  /// **'رائج'**
  String get discoveryPopular;

  /// No description provided for @discoveryFindNearbyWorkshops.
  ///
  /// In ar, this message translates to:
  /// **'اعثر على ورش قريبة'**
  String get discoveryFindNearbyWorkshops;

  /// No description provided for @discoveryMapSector.
  ///
  /// In ar, this message translates to:
  /// **'القطاع 22'**
  String get discoveryMapSector;

  /// No description provided for @discoverySearchWorkshopsAndParts.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن ورش وقطع ومتاجر قطع'**
  String get discoverySearchWorkshopsAndParts;

  /// No description provided for @discoveryYourNearbyWorkshops.
  ///
  /// In ar, this message translates to:
  /// **'ورش قريبة منك'**
  String get discoveryYourNearbyWorkshops;

  /// No description provided for @discoveryRoadside.
  ///
  /// In ar, this message translates to:
  /// **'طريق'**
  String get discoveryRoadside;

  /// No description provided for @discoveryHomeContext.
  ///
  /// In ar, this message translates to:
  /// **'المنزل'**
  String get discoveryHomeContext;

  /// No description provided for @discoveryWorkshopContext.
  ///
  /// In ar, this message translates to:
  /// **'الورشة'**
  String get discoveryWorkshopContext;

  /// No description provided for @discoveryOfficeContext.
  ///
  /// In ar, this message translates to:
  /// **'المكتب'**
  String get discoveryOfficeContext;

  /// No description provided for @discoveryPremiumService.
  ///
  /// In ar, this message translates to:
  /// **'خدمة مميزة'**
  String get discoveryPremiumService;

  /// No description provided for @discoveryServiceNetwork.
  ///
  /// In ar, this message translates to:
  /// **'شبكة الخدمة'**
  String get discoveryServiceNetwork;

  /// No description provided for @discoveryChooseWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'اختر الورشة'**
  String get discoveryChooseWorkshop;

  /// No description provided for @discoveryChooseWorkshopSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدد وجهة سحب مركبتك. هذه المواقع معتمدة لخطة المساعدة على الطريق الخاصة بك.'**
  String get discoveryChooseWorkshopSubtitle;

  /// No description provided for @discoverySelectWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'اختر الورشة'**
  String get discoverySelectWorkshop;

  /// No description provided for @discoveryPickupEstimateLabel.
  ///
  /// In ar, this message translates to:
  /// **'زمن السحب'**
  String get discoveryPickupEstimateLabel;

  /// No description provided for @discoveryCapacityLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعة'**
  String get discoveryCapacityLabel;

  /// No description provided for @discoverySpecialtyLabel.
  ///
  /// In ar, this message translates to:
  /// **'التخصص'**
  String get discoverySpecialtyLabel;

  /// No description provided for @discoveryViewMap.
  ///
  /// In ar, this message translates to:
  /// **'عرض الخريطة'**
  String get discoveryViewMap;

  /// No description provided for @discoveryAvailableNow.
  ///
  /// In ar, this message translates to:
  /// **'متاح الآن'**
  String get discoveryAvailableNow;

  /// No description provided for @discoverySlotsOpen.
  ///
  /// In ar, this message translates to:
  /// **'{count} خانات متاحة'**
  String discoverySlotsOpen(int count);

  /// No description provided for @discoverySameDayReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهز اليوم نفسه'**
  String get discoverySameDayReady;

  /// No description provided for @discoveryGermanEngineering.
  ///
  /// In ar, this message translates to:
  /// **'هندسة ألمانية'**
  String get discoveryGermanEngineering;

  /// No description provided for @discoveryGeneralService.
  ///
  /// In ar, this message translates to:
  /// **'خدمة عامة'**
  String get discoveryGeneralService;

  /// No description provided for @discoveryDiagnostics.
  ///
  /// In ar, this message translates to:
  /// **'تشخيص'**
  String get discoveryDiagnostics;

  /// No description provided for @discoveryMinutesValue.
  ///
  /// In ar, this message translates to:
  /// **'{minutes} دقيقة'**
  String discoveryMinutesValue(int minutes);

  /// No description provided for @discoveryServiceRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب خدمة'**
  String get discoveryServiceRequest;

  /// No description provided for @discoveryPickupDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السحب'**
  String get discoveryPickupDetails;

  /// No description provided for @discoveryBreakdownLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقع العطل'**
  String get discoveryBreakdownLocation;

  /// No description provided for @discoveryPreferredWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'الورشة المفضلة'**
  String get discoveryPreferredWorkshop;

  /// No description provided for @discoveryIssueNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة العطل'**
  String get discoveryIssueNote;

  /// No description provided for @discoveryEnterLocation.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الموقع'**
  String get discoveryEnterLocation;

  /// No description provided for @discoveryIssueNoteHint.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة في المقود، السيارة لا تعمل.'**
  String get discoveryIssueNoteHint;

  /// No description provided for @discoveryPickupReturnTitle.
  ///
  /// In ar, this message translates to:
  /// **'سحب + إرجاع بعد الخدمة'**
  String get discoveryPickupReturnTitle;

  /// No description provided for @discoveryPickupReturnSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سنعيدها إليك بعد انتهاء الخدمة'**
  String get discoveryPickupReturnSubtitle;

  /// No description provided for @discoveryEstimatedTowingFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم السحب التقديرية'**
  String get discoveryEstimatedTowingFee;

  /// No description provided for @discoveryGuaranteedWithinDoha.
  ///
  /// In ar, this message translates to:
  /// **'مضمون ضمن 5 كم من مدينة الدوحة'**
  String get discoveryGuaranteedWithinDoha;

  /// No description provided for @discoveryProceed.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get discoveryProceed;

  /// No description provided for @discoveryReadyForService.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة للخدمة'**
  String get discoveryReadyForService;

  /// No description provided for @discoveryNoVehicleTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مركبة محددة'**
  String get discoveryNoVehicleTitle;

  /// No description provided for @discoveryAddVehicleToContinue.
  ///
  /// In ar, this message translates to:
  /// **'أضف أو اختر مركبة قبل المتابعة.'**
  String get discoveryAddVehicleToContinue;

  /// No description provided for @discoverySelectVehicle.
  ///
  /// In ar, this message translates to:
  /// **'اختر المركبة'**
  String get discoverySelectVehicle;

  /// No description provided for @discoveryPlatePrefix.
  ///
  /// In ar, this message translates to:
  /// **'اللوحة:'**
  String get discoveryPlatePrefix;

  /// No description provided for @discoveryDefaultBreakdownLocation.
  ///
  /// In ar, this message translates to:
  /// **'اللؤلؤة، البرج 4'**
  String get discoveryDefaultBreakdownLocation;

  /// No description provided for @discoveryActiveLabel.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get discoveryActiveLabel;

  /// No description provided for @discoveryCompletedLabel.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get discoveryCompletedLabel;

  /// No description provided for @discoveryCancelledLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get discoveryCancelledLabel;

  /// No description provided for @discoveryActiveTrackings.
  ///
  /// In ar, this message translates to:
  /// **'التتبعات النشطة'**
  String get discoveryActiveTrackings;

  /// No description provided for @discoveryRecentHistory.
  ///
  /// In ar, this message translates to:
  /// **'السجل الحديث'**
  String get discoveryRecentHistory;

  /// No description provided for @discoveryItemsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} عنصر'**
  String discoveryItemsCount(int count);

  /// No description provided for @discoveryInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد التنفيذ'**
  String get discoveryInProgress;

  /// No description provided for @discoveryWorkshopService.
  ///
  /// In ar, this message translates to:
  /// **'خدمة ورشة'**
  String get discoveryWorkshopService;

  /// No description provided for @discoveryServiceBookingAt.
  ///
  /// In ar, this message translates to:
  /// **'حجز خدمة لدى {workshopName}'**
  String discoveryServiceBookingAt(String workshopName);

  /// No description provided for @discoveryScheduledFor.
  ///
  /// In ar, this message translates to:
  /// **'مجدول في {value}'**
  String discoveryScheduledFor(String value);

  /// No description provided for @discoveryDropOff.
  ///
  /// In ar, this message translates to:
  /// **'التسليم'**
  String get discoveryDropOff;

  /// No description provided for @discoveryServicing.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة'**
  String get discoveryServicing;

  /// No description provided for @discoveryQualityCheck.
  ///
  /// In ar, this message translates to:
  /// **'فحص الجودة'**
  String get discoveryQualityCheck;

  /// No description provided for @discoveryReadyLabel.
  ///
  /// In ar, this message translates to:
  /// **'جاهز'**
  String get discoveryReadyLabel;

  /// No description provided for @discoveryTrackPackage.
  ///
  /// In ar, this message translates to:
  /// **'تتبع الشحنة'**
  String get discoveryTrackPackage;

  /// No description provided for @discoveryDetails.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get discoveryDetails;

  /// No description provided for @discoveryEstimatedDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ المتوقع'**
  String get discoveryEstimatedDateLabel;

  /// No description provided for @discoveryPartsOrderTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب قطع: {title}'**
  String discoveryPartsOrderTitle(String title);

  /// No description provided for @discoveryDispatchedVia.
  ///
  /// In ar, this message translates to:
  /// **'تم الإرسال عبر {method}'**
  String discoveryDispatchedVia(String method);

  /// No description provided for @discoveryOrderFallbackTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب OnlyCars'**
  String get discoveryOrderFallbackTitle;

  /// No description provided for @discoveryReorderService.
  ///
  /// In ar, this message translates to:
  /// **'إعادة طلب الخدمة'**
  String get discoveryReorderService;

  /// No description provided for @discoveryDownloadReceipt.
  ///
  /// In ar, this message translates to:
  /// **'تنزيل الإيصال'**
  String get discoveryDownloadReceipt;

  /// No description provided for @discoveryNoActiveOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات أو طلبات سحب نشطة حالياً.'**
  String get discoveryNoActiveOrders;

  /// No description provided for @discoveryNoCompletedOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات مكتملة بعد.'**
  String get discoveryNoCompletedOrders;

  /// No description provided for @discoveryNoCancelledOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات ملغاة.'**
  String get discoveryNoCancelledOrders;

  /// No description provided for @discoveryProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get discoveryProfileTitle;
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
