// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tagline => 'Discover. Connect. Live.';

  @override
  String get onboardingHeadline => 'Find a place you\'ll love.';

  @override
  String get onboardingBody =>
      'Discover verified properties, connect directly with landlords, and make finding your next home easier.';

  @override
  String get onboardingVerifiedTitle => 'Verified properties only';

  @override
  String get onboardingVerifiedBody =>
      'Every listing is reviewed before it appears, so you avoid scams and fakes.';

  @override
  String get onboardingConnectTitle => 'Connect for less';

  @override
  String get onboardingConnectBody =>
      '5,000 Tsh/month unlocks up to 5 landlord contacts.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get login => 'Welcome to Kazora';

  @override
  String get logout => 'Log out';

  @override
  String get search => 'Search';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get revealContact => 'Reveal Contact';

  @override
  String get authSubtitle =>
      'Enter your phone number to get started. We\'ll send you a verification code.';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get phoneNumberHint => '+255 7XX XXX XXX';

  @override
  String get otpLabel => 'One-time password';

  @override
  String get otpHint => '6-digit code';

  @override
  String get sendCode => 'Send Code';

  @override
  String get verifyContinue => 'Verify & Continue';

  @override
  String get roleSelectionTitle => 'Who are you?';

  @override
  String get roleRenterTitle => 'I want to rent';

  @override
  String get roleRenterSubtitle =>
      'Browse verified properties and connect with landlords.';

  @override
  String get roleLandlordTitle => 'I have a property';

  @override
  String get roleLandlordSubtitle => 'List your property and manage inquiries.';

  @override
  String get phoneRequired => 'Enter your phone number.';

  @override
  String get otpRequired => 'Enter the code you received.';

  @override
  String get continueButton => 'Continue';

  @override
  String get roleRequired => 'Please choose a role to continue.';

  @override
  String get back => 'Back';

  @override
  String get resendCode => 'Resend code';

  @override
  String get codeResent => 'New code sent.';

  @override
  String get phoneInvalid => 'Enter a valid phone number.';

  @override
  String otpExpiresIn(String time) {
    return 'Code expires in $time';
  }

  @override
  String get otpExpired => 'Code expired. Request a new one below.';

  @override
  String get appName => 'Kazora';

  @override
  String get home => 'Home';

  @override
  String get messages => 'Messages';

  @override
  String get homeGreeting => 'Welcome back';

  @override
  String get homeSearchTitle => 'Find your next place';

  @override
  String get homeSearchSubtitle => 'Search verified properties';

  @override
  String get featured => 'Featured';

  @override
  String get latest => 'Latest';

  @override
  String get seeAll => 'See all';

  @override
  String get noFeatured => 'No featured properties yet';

  @override
  String get noProperties => 'No properties found';

  @override
  String get adjustFilters => 'Try adjusting your filters or check back later.';

  @override
  String get searchHint => 'Search properties...';

  @override
  String get allRegions => 'All regions';

  @override
  String get verified => 'Verified';

  @override
  String get description => 'Description';

  @override
  String bedsCount(int count) {
    return '$count beds';
  }

  @override
  String bathsCount(int count) {
    return '$count baths';
  }

  @override
  String get furnished => 'Furnished';

  @override
  String get videoTour => 'Video tour';

  @override
  String get contactSubscribeNotice =>
      'Contact details are available after subscribing.';

  @override
  String get tryThis => 'Try this';

  @override
  String get regionFilter => 'Region';

  @override
  String get typeFilter => 'Type';

  @override
  String get priceFilter => 'Price';

  @override
  String get typeAny => 'Any';

  @override
  String get typeResidential => 'Residential';

  @override
  String get typeCommercial => 'Commercial';

  @override
  String get priceAny => 'Any price';

  @override
  String get priceUnder200k => 'Under 200K';

  @override
  String get price200to500k => '200K - 500K';

  @override
  String get price500kto1m => '500K - 1M';

  @override
  String get priceOver1m => 'Over 1M';

  @override
  String get presetRoomsUnder200k => 'Rooms under 200K';

  @override
  String get preset2br => '2BR homes';

  @override
  String get presetOffices => 'Offices';

  @override
  String get presetShopsKariakoo => 'Shops in Kariakoo';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clear => 'Clear';

  @override
  String resultsCount(int count) {
    return '$count places found';
  }

  @override
  String get reset => 'Reset';

  @override
  String get noResults => 'No results';

  @override
  String get differentTerm => 'Try a different search term or fewer filters.';

  @override
  String get filters => 'Filters';

  @override
  String get apply => 'Apply';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortPriceAsc => 'Price: low to high';

  @override
  String get sortPriceDesc => 'Price: high to low';

  @override
  String get voiceListening => 'Listening... speak now';

  @override
  String get voiceDenied => 'Microphone access is needed for voice search.';

  @override
  String get catAll => 'All';

  @override
  String get catRoom => 'Rooms';

  @override
  String get catApartment => 'Apartments';

  @override
  String get catHouse => 'Houses';

  @override
  String get catOffice => 'Offices';

  @override
  String get catShop => 'Shops';
}
