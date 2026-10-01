import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('sw'),
  ];

  /// App tagline shown on the welcome screen
  ///
  /// In en, this message translates to:
  /// **'Discover. Connect. Live.'**
  String get tagline;

  /// Main headline on the onboarding flow
  ///
  /// In en, this message translates to:
  /// **'Find a place you\'ll love.'**
  String get onboardingHeadline;

  /// Main body copy on the onboarding flow
  ///
  /// In en, this message translates to:
  /// **'Discover verified properties, connect directly with landlords, and make finding your next home easier.'**
  String get onboardingBody;

  /// Onboarding slide 1 title
  ///
  /// In en, this message translates to:
  /// **'Verified properties only'**
  String get onboardingVerifiedTitle;

  /// Onboarding slide 1 body
  ///
  /// In en, this message translates to:
  /// **'Every listing is reviewed before it appears, so you avoid scams and fakes.'**
  String get onboardingVerifiedBody;

  /// Onboarding slide 2 title
  ///
  /// In en, this message translates to:
  /// **'Connect for less'**
  String get onboardingConnectTitle;

  /// Onboarding slide 2 body
  ///
  /// In en, this message translates to:
  /// **'5,000 Tsh/month unlocks up to 5 landlord contacts.'**
  String get onboardingConnectBody;

  /// Primary call-to-action after onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Advance to the next onboarding slide
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Skip the onboarding flow
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Auth screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kazora'**
  String get login;

  /// Sign the user out
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// Search tab/label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Favorites tab/label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Profile tab/label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Subscribe to the contact-credits plan
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// Button that spends a credit to reveal a landlord's contact
  ///
  /// In en, this message translates to:
  /// **'Reveal Contact'**
  String get revealContact;

  /// Subtitle on the auth screen
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to get started. We\'ll send you a verification code.'**
  String get authSubtitle;

  /// Label for the phone number field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// Hint for the phone number field
  ///
  /// In en, this message translates to:
  /// **'+255 7XX XXX XXX'**
  String get phoneNumberHint;

  /// Label for the OTP field
  ///
  /// In en, this message translates to:
  /// **'One-time password'**
  String get otpLabel;

  /// Hint for the OTP field
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpHint;

  /// Button that requests the OTP
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// Button that verifies the OTP
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyContinue;

  /// Title on the role selection screen
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get roleSelectionTitle;

  /// Title of the renter role card
  ///
  /// In en, this message translates to:
  /// **'I want to rent'**
  String get roleRenterTitle;

  /// Subtitle of the renter role card
  ///
  /// In en, this message translates to:
  /// **'Browse verified properties and connect with landlords.'**
  String get roleRenterSubtitle;

  /// Title of the landlord role card
  ///
  /// In en, this message translates to:
  /// **'I have a property'**
  String get roleLandlordTitle;

  /// Subtitle of the landlord role card
  ///
  /// In en, this message translates to:
  /// **'List your property and manage inquiries.'**
  String get roleLandlordSubtitle;

  /// Validation message when the phone number is empty
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get phoneRequired;

  /// Validation message when the OTP is empty
  ///
  /// In en, this message translates to:
  /// **'Enter the code you received.'**
  String get otpRequired;

  /// Button that continues after choosing a role
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Validation message when no role is selected
  ///
  /// In en, this message translates to:
  /// **'Please choose a role to continue.'**
  String get roleRequired;

  /// Tooltip for back navigation buttons
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Button that requests a fresh OTP
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// Confirmation shown after resending the OTP
  ///
  /// In en, this message translates to:
  /// **'New code sent.'**
  String get codeResent;

  /// Validation message when the phone number format is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get phoneInvalid;

  /// Countdown showing how long the OTP remains valid
  ///
  /// In en, this message translates to:
  /// **'Code expires in {time}'**
  String otpExpiresIn(String time);

  /// Message shown when the OTP validity period has elapsed
  ///
  /// In en, this message translates to:
  /// **'Code expired. Request a new one below.'**
  String get otpExpired;

  /// App name used in app bars
  ///
  /// In en, this message translates to:
  /// **'Kazora'**
  String get appName;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Messages tab label
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Greeting headline on the tenant home tab
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeGreeting;

  /// Title of the search entry card on home
  ///
  /// In en, this message translates to:
  /// **'Find your next place'**
  String get homeSearchTitle;

  /// Subtitle of the search entry card on home
  ///
  /// In en, this message translates to:
  /// **'Search verified properties'**
  String get homeSearchSubtitle;

  /// Section title for featured properties
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// Section title for the latest properties
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// Button that opens the full property list
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// Empty message for the featured section
  ///
  /// In en, this message translates to:
  /// **'No featured properties yet'**
  String get noFeatured;

  /// Empty message when no properties are available
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get noProperties;

  /// Hint shown with the empty properties message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or check back later.'**
  String get adjustFilters;

  /// Hint for the property search field
  ///
  /// In en, this message translates to:
  /// **'Search properties...'**
  String get searchHint;

  /// Region filter chip that clears the region filter
  ///
  /// In en, this message translates to:
  /// **'All regions'**
  String get allRegions;

  /// Badge shown on verified properties
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Heading for the property description section
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Bedroom count badge on property details
  ///
  /// In en, this message translates to:
  /// **'{count} beds'**
  String bedsCount(int count);

  /// Bathroom count badge on property details
  ///
  /// In en, this message translates to:
  /// **'{count} baths'**
  String bathsCount(int count);

  /// Badge shown when a property is furnished
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get furnished;

  /// Heading for the property video tour section
  ///
  /// In en, this message translates to:
  /// **'Video tour'**
  String get videoTour;

  /// Message shown when tapping reveal contact without a subscription
  ///
  /// In en, this message translates to:
  /// **'Contact details are available after subscribing.'**
  String get contactSubscribeNotice;

  /// Heading for one-tap preset searches
  ///
  /// In en, this message translates to:
  /// **'Try this'**
  String get tryThis;

  /// Label for the region filter chips
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get regionFilter;

  /// Label for the property type filter chips
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeFilter;

  /// Label for the price band filter chips
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceFilter;

  /// Type chip that clears the type filter
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get typeAny;

  /// Residential type filter chip
  ///
  /// In en, this message translates to:
  /// **'Residential'**
  String get typeResidential;

  /// Commercial type filter chip
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get typeCommercial;

  /// Price chip that clears the price filter
  ///
  /// In en, this message translates to:
  /// **'Any price'**
  String get priceAny;

  /// Price band chip for listings under 200,000 TSh
  ///
  /// In en, this message translates to:
  /// **'Under 200K'**
  String get priceUnder200k;

  /// Price band chip for listings between 200,000 and 500,000 TSh
  ///
  /// In en, this message translates to:
  /// **'200K - 500K'**
  String get price200to500k;

  /// Price band chip for listings between 500,000 and 1,000,000 TSh
  ///
  /// In en, this message translates to:
  /// **'500K - 1M'**
  String get price500kto1m;

  /// Price band chip for listings over 1,000,000 TSh
  ///
  /// In en, this message translates to:
  /// **'Over 1M'**
  String get priceOver1m;

  /// Preset search for cheap rooms
  ///
  /// In en, this message translates to:
  /// **'Rooms under 200K'**
  String get presetRoomsUnder200k;

  /// Preset search for two-bedroom homes
  ///
  /// In en, this message translates to:
  /// **'2BR homes'**
  String get preset2br;

  /// Preset search for offices
  ///
  /// In en, this message translates to:
  /// **'Offices'**
  String get presetOffices;

  /// Preset search for shops in Kariakoo
  ///
  /// In en, this message translates to:
  /// **'Shops in Kariakoo'**
  String get presetShopsKariakoo;

  /// Heading for the recent searches list
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// Button that clears recent searches
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Header showing how many search results were found
  ///
  /// In en, this message translates to:
  /// **'{count} places found'**
  String resultsCount(int count);

  /// Button that clears the search and filters
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Title shown when a search returns nothing
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// Hint shown when a search returns nothing
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or fewer filters.'**
  String get differentTerm;

  /// Button and heading for the search filters sheet
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Button that applies the selected search filters
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Sort option for newest listings first
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// Sort option for cheapest listings first
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get sortPriceAsc;

  /// Sort option for most expensive listings first
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get sortPriceDesc;

  /// Indicator shown while voice search is listening
  ///
  /// In en, this message translates to:
  /// **'Listening... speak now'**
  String get voiceListening;

  /// Message shown when microphone permission is denied
  ///
  /// In en, this message translates to:
  /// **'Microphone access is needed for voice search.'**
  String get voiceDenied;

  /// Category tile that clears the category filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catAll;

  /// Category tile for rooms
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get catRoom;

  /// Category tile for apartments
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get catApartment;

  /// Category tile for houses
  ///
  /// In en, this message translates to:
  /// **'Houses'**
  String get catHouse;

  /// Category tile for offices
  ///
  /// In en, this message translates to:
  /// **'Offices'**
  String get catOffice;

  /// Category tile for shops
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get catShop;
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
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
