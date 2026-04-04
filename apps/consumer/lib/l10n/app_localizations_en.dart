// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OnlyCars';

  @override
  String get login => 'Login';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get sendOtp => 'Send Code';

  @override
  String get verifyOtp => 'Verify Code';

  @override
  String get otpHint => 'Enter the 6-digit code';

  @override
  String get resendOtp => 'Resend';

  @override
  String get profileSetup => 'Profile Setup';

  @override
  String get name => 'Name';

  @override
  String get save => 'Save';

  @override
  String get home => 'Home';

  @override
  String get workshops => 'Workshops';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get orders => 'Orders';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get myCars => 'My Cars';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get newReports => 'New Reports';

  @override
  String get workshopMap => 'Workshop Map';

  @override
  String get addVehicle => 'Add Vehicle';

  @override
  String get diagnosisReport => 'Diagnosis Report';

  @override
  String get chat => 'Chat';

  @override
  String get chatInboxTitle => 'Chats';

  @override
  String get chatMessagesSectionLabel => 'Messages';

  @override
  String get chatFilterAll => 'All';

  @override
  String get chatFilterUnread => 'Unread';

  @override
  String get chatYouPrefix => 'You';

  @override
  String chatUnreadCount(int count) {
    return '$count new messages';
  }

  @override
  String get chatEmptyTitle => 'No chats yet';

  @override
  String get chatEmptySubtitle =>
      'Start a conversation from a workshop profile and it will appear here.';

  @override
  String get chatLoadError => 'Unable to load chats';

  @override
  String get chatThreadFallbackTitle => 'Chats';

  @override
  String get chatNoMessagesYet => 'Say hello to start the conversation.';

  @override
  String get chatComposerHint => 'Write a message';

  @override
  String get chatSend => 'Send';

  @override
  String get chatSendFailed => 'Failed to send message';

  @override
  String get cart => 'Cart';

  @override
  String get checkout => 'Checkout';

  @override
  String get orderTracking => 'Order Tracking';

  @override
  String get workshopBill => 'Workshop Bill';

  @override
  String get rateWorkshop => 'Rate Workshop';

  @override
  String get carHealthVault => 'Car Health Vault';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get negotiate => 'Negotiate';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get workshopCode => 'Workshop Code';

  @override
  String get total => 'Total';

  @override
  String get pay => 'Pay';

  @override
  String get loading => 'Loading...';

  @override
  String get errorGeneric => 'Something went wrong. Try again';

  @override
  String get noData => 'No data';

  @override
  String get retry => 'Retry';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get discoveryNavProfile => 'Profile';

  @override
  String get discoveryNavChat => 'Chat';

  @override
  String get discoveryNavOrders => 'Orders';

  @override
  String get discoveryNavMap => 'Map';

  @override
  String get discoveryNavHome => 'Home';

  @override
  String discoveryWelcomeBack(String name) {
    return 'Welcome Back, $name';
  }

  @override
  String get discoverySearchHint => 'Search Workshops, Parts...';

  @override
  String get discoveryMapLabel => 'Map';

  @override
  String get discoveryListLabel => 'List';

  @override
  String get discoveryServicesLabel => 'Services';

  @override
  String get discoveryPartsLabel => 'Parts';

  @override
  String get discoverySummerEssentials => 'SUMMER ESSENTIALS';

  @override
  String get discoveryHeroTitle => 'Upgrade Your Ride with 25% Off Parts';

  @override
  String get discoveryShopCollection => 'Shop Collection';

  @override
  String get discoveryPremiumCare => 'PREMIUM CARE';

  @override
  String get discoveryHeroSecondaryTitle =>
      'Certified garages ready for your next service booking';

  @override
  String get discoveryBookNow => 'Book Now';

  @override
  String discoveryOrderInTransitTitle(String itemName) {
    return 'In Transit: $itemName';
  }

  @override
  String get discoveryDiagnosticTitle => 'Diagnostic Scan Tool';

  @override
  String get discoveryDiagnosticSubtitle =>
      'Connect your vehicle and get instant health reports, error code clearing, and performance metrics.';

  @override
  String get discoveryLearnMore => 'Learn More';

  @override
  String get discoveryUploadImage => 'Upload your image';

  @override
  String get discoveryRecommended => 'Recommended';

  @override
  String get discoveryRatingFilter => 'Rating 4.5+';

  @override
  String get discoveryDistanceFilter => 'Distance';

  @override
  String get discoveryTopRatedWorkshop => 'Top Rated Workshop';

  @override
  String get discoveryViewAll => 'View All';

  @override
  String get discoveryPopularParts => 'Popular Parts';

  @override
  String get discoveryExploreStore => 'Explore Store';

  @override
  String get discoveryPopularServices => 'Popular Services';

  @override
  String get discoveryNearbyWorkshops => 'Nearby Workshops';

  @override
  String get discoverySeeAll => 'See All';

  @override
  String get discoveryBookService => 'Book Service';

  @override
  String get discoveryWorkshopFallbackLocation => 'Doha';

  @override
  String get discoveryLuxuryExpert => 'Luxury Expert';

  @override
  String get discoveryAuthorizedDealer => 'Authorized Dealer';

  @override
  String get discoveryOilChange => 'Oil Change';

  @override
  String get discoveryBrakeService => 'Brake Service';

  @override
  String get discoveryAcRepair => 'AC Repair';

  @override
  String get discoveryRegularCheckup => 'Regular Checkup';

  @override
  String get discoveryPrecisionParts => 'Precision Parts';

  @override
  String get discoveryPartsSearchHint =>
      'Search Genuine Parts, Serial Numbers...';

  @override
  String get discoveryFilters => 'Filters';

  @override
  String get discoveryBrandToyota => 'Brand: Toyota';

  @override
  String get discoveryPriceRange => 'Price Range';

  @override
  String get discoveryInStock => 'In Stock';

  @override
  String get discoveryEngine => 'Engine';

  @override
  String get discoveryExterior => 'Exterior';

  @override
  String get discoveryLighting => 'Lighting';

  @override
  String get discoveryTires => 'Tires';

  @override
  String get discoveryElectrical => 'Electrical';

  @override
  String get discoveryGenuine => 'Genuine';

  @override
  String get discoveryPopular => 'Popular';

  @override
  String get discoveryFindNearbyWorkshops => 'Find Nearby Workshops';

  @override
  String get discoveryMapSector => 'Sector 22';

  @override
  String get discoverySearchWorkshopsAndParts => 'Search workshops, PartsShops';

  @override
  String get discoveryYourNearbyWorkshops => 'Your Nearby Workshops';

  @override
  String get discoveryRoadside => 'Roadside';

  @override
  String get discoveryHomeContext => 'Home';

  @override
  String get discoveryWorkshopContext => 'Workshop';

  @override
  String get discoveryOfficeContext => 'Office';

  @override
  String get discoveryPremiumService => 'Premium Service';

  @override
  String get discoveryServiceNetwork => 'Service Network';

  @override
  String get discoveryChooseWorkshop => 'Choose Workshop';

  @override
  String get discoveryChooseWorkshopSubtitle =>
      'Select a destination for your vehicle pickup. These locations are authorized for your specific roadside assistance plan.';

  @override
  String get discoverySelectWorkshop => 'Select Workshop';

  @override
  String get discoveryPickupEstimateLabel => 'Pickup Est.';

  @override
  String get discoveryCapacityLabel => 'Capacity';

  @override
  String get discoverySpecialtyLabel => 'Specialty';

  @override
  String get discoveryViewMap => 'View Map';

  @override
  String get discoveryAvailableNow => 'Available Now';

  @override
  String discoverySlotsOpen(int count) {
    return '$count Slots Open';
  }

  @override
  String get discoverySameDayReady => 'Same Day Ready';

  @override
  String get discoveryGermanEngineering => 'German Engineering';

  @override
  String get discoveryGeneralService => 'General Service';

  @override
  String get discoveryDiagnostics => 'Diagnostics';

  @override
  String discoveryMinutesValue(int minutes) {
    return '$minutes mins';
  }

  @override
  String get discoveryServiceRequest => 'Service Request';

  @override
  String get discoveryPickupDetails => 'Pickup Details';

  @override
  String get discoveryBreakdownLocation => 'Breakdown Location';

  @override
  String get discoveryPreferredWorkshop => 'Preferred Workshop';

  @override
  String get discoveryIssueNote => 'Issue Note';

  @override
  String get discoveryEnterLocation => 'Enter location';

  @override
  String get discoveryIssueNoteHint => 'Steering issue, car won\'t start.';

  @override
  String get discoveryPickupReturnTitle => 'Pickup + Return Drop-off';

  @override
  String get discoveryPickupReturnSubtitle =>
      'We\'ll bring it back after service';

  @override
  String get discoveryEstimatedTowingFee => 'Estimated Towing Fee';

  @override
  String get discoveryGuaranteedWithinDoha =>
      'Guaranteed within 5km of Doha City';

  @override
  String get discoveryProceed => 'Proceed';

  @override
  String get discoveryReadyForService => 'Ready for Service';

  @override
  String get discoveryNoVehicleTitle => 'No vehicle selected';

  @override
  String get discoveryAddVehicleToContinue =>
      'Add or choose a vehicle before continuing.';

  @override
  String get discoverySelectVehicle => 'Select Vehicle';

  @override
  String get discoveryPlatePrefix => 'Plate:';

  @override
  String get discoveryDefaultBreakdownLocation => 'The Pearl, Tower 4';

  @override
  String get discoveryActiveLabel => 'Active';

  @override
  String get discoveryCompletedLabel => 'Completed';

  @override
  String get discoveryCancelledLabel => 'Cancelled';

  @override
  String get discoveryActiveTrackings => 'Active Trackings';

  @override
  String get discoveryRecentHistory => 'Recent History';

  @override
  String discoveryItemsCount(int count) {
    return '$count items';
  }

  @override
  String get discoveryInProgress => 'In Progress';

  @override
  String get discoveryWorkshopService => 'Workshop Service';

  @override
  String discoveryServiceBookingAt(String workshopName) {
    return 'Service Booking at $workshopName';
  }

  @override
  String discoveryScheduledFor(String value) {
    return 'Scheduled for $value';
  }

  @override
  String get discoveryDropOff => 'Drop Off';

  @override
  String get discoveryServicing => 'Servicing';

  @override
  String get discoveryQualityCheck => 'Quality Check';

  @override
  String get discoveryReadyLabel => 'Ready';

  @override
  String get discoveryTrackPackage => 'Track Package';

  @override
  String get discoveryDetails => 'Details';

  @override
  String get discoveryEstimatedDateLabel => 'Estimated';

  @override
  String discoveryPartsOrderTitle(String title) {
    return 'Parts Order: $title';
  }

  @override
  String discoveryDispatchedVia(String method) {
    return 'Dispatched via $method';
  }

  @override
  String get discoveryOrderFallbackTitle => 'OnlyCars Order';

  @override
  String get discoveryReorderService => 'Reorder Service';

  @override
  String get discoveryDownloadReceipt => 'Download Receipt';

  @override
  String get discoveryNoActiveOrders => 'No active requests or orders yet.';

  @override
  String get discoveryNoCompletedOrders => 'No completed orders yet.';

  @override
  String get discoveryNoCancelledOrders => 'No cancelled orders.';

  @override
  String get discoveryProfileTitle => 'Profile';
}
