// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get tagline => 'Gundua. Unganisha. Piga.';

  @override
  String get onboardingHeadline => 'Pata nyumba utapenda.';

  @override
  String get onboardingBody =>
      'Gundua mizigo iliyothibitishwa,unganishie moja kwa moja na wenyeji, na ufanye kupata nyumba yako ifuatae iwe rahisi.';

  @override
  String get onboardingVerifiedTitle => 'Mizigo iliyothibitishwa pekee';

  @override
  String get onboardingVerifiedBody =>
      'Kila mizigo hutathminiwa kabla ya kuonekana, ili kuepuka uongo na mashindano.';

  @override
  String get onboardingConnectTitle => 'Unganisha kwa bei ya chini';

  @override
  String get onboardingConnectBody =>
      'TSh 5,000 kwa mwezi inafungua mawasiliano hadi 5 na wenyeji.';

  @override
  String get getStarted => 'Anza Sasa';

  @override
  String get next => 'Endelea';

  @override
  String get skip => 'Ruka';

  @override
  String get login => 'Karibu Kazora';

  @override
  String get logout => 'Toka';

  @override
  String get search => 'Tafuta';

  @override
  String get favorites => 'Mpendwa';

  @override
  String get profile => 'Wasifu';

  @override
  String get subscribe => 'Jiandikishie';

  @override
  String get revealContact => 'Onyesha Mawasiliano';

  @override
  String get authSubtitle =>
      'Weka nambari yako ya simu ili kuanza. Tutakutumia msimbo wa uthibitisho.';

  @override
  String get phoneNumberLabel => 'Nambari ya simu';

  @override
  String get phoneNumberHint => '+255 7XX XXX XXX';

  @override
  String get otpLabel => 'Nywila ya mara moja';

  @override
  String get otpHint => 'Msimbo wa tarakimu 6';

  @override
  String get sendCode => 'Tuma Msimbo';

  @override
  String get verifyContinue => 'Thibitisha na Endelea';

  @override
  String get roleSelectionTitle => 'Wewe ni nani?';

  @override
  String get roleRenterTitle => 'Nataka kukodisha';

  @override
  String get roleRenterSubtitle =>
      'Vinjari nyumba zilizothibitishwa na uwasiliane na wenye nyumba.';

  @override
  String get roleLandlordTitle => 'Nina nyumba';

  @override
  String get roleLandlordSubtitle => 'Tangaza nyumba yako na udhibiti maombi.';

  @override
  String get phoneRequired => 'Weka nambari yako ya simu.';

  @override
  String get otpRequired => 'Weka msimbo uliopokea.';

  @override
  String get continueButton => 'Endelea';

  @override
  String get roleRequired => 'Tafadhali chagua aina ya akaunti kuendelea.';

  @override
  String get back => 'Rudi';

  @override
  String get resendCode => 'Tuma msimbo tena';

  @override
  String get codeResent => 'Msimbo mpya umetumwa.';

  @override
  String get phoneInvalid => 'Weka nambari sahihi ya simu.';

  @override
  String otpExpiresIn(String time) {
    return 'Msimbo unaisha baada ya $time';
  }

  @override
  String get otpExpired => 'Msimbo umeisha. Omba mpya hapo chini.';

  @override
  String get appName => 'Kazora';

  @override
  String get home => 'Nyumbani';

  @override
  String get messages => 'Ujumbe';

  @override
  String get homeGreeting => 'Karibu tena';

  @override
  String get homeSearchTitle => 'Tafuta makazi yako';

  @override
  String get homeSearchSubtitle => 'Tafuta nyumba zilizothibitishwa';

  @override
  String get featured => 'Zilizoangaziwa';

  @override
  String get latest => 'Mpya';

  @override
  String get seeAll => 'Ona zote';

  @override
  String get noFeatured => 'Hakuna nyumba zilizoangaziwa bado';

  @override
  String get noProperties => 'Hakuna nyumba zilizopatikana';

  @override
  String get adjustFilters => 'Rekebisha vichujio au rudi baadaye.';

  @override
  String get searchHint => 'Tafuta nyumba...';

  @override
  String get allRegions => 'Mikoa yote';

  @override
  String get verified => 'Imethibitishwa';

  @override
  String get description => 'Maelezo';

  @override
  String bedsCount(int count) {
    return '$count vitanda';
  }

  @override
  String bathsCount(int count) {
    return '$count mabafu';
  }

  @override
  String get furnished => 'Ina samani';

  @override
  String get videoTour => 'Video ya nyumba';

  @override
  String get contactSubscribeNotice =>
      'Mawasiliano yanapatikana baada ya kujiandikisha.';

  @override
  String get tryThis => 'Jaribu hizi';

  @override
  String get regionFilter => 'Mkoa';

  @override
  String get typeFilter => 'Aina';

  @override
  String get priceFilter => 'Bei';

  @override
  String get typeAny => 'Zote';

  @override
  String get typeResidential => 'Makaazi';

  @override
  String get typeCommercial => 'Biashara';

  @override
  String get priceAny => 'Bei yote';

  @override
  String get priceUnder200k => 'Chini ya 200K';

  @override
  String get price200to500k => '200K - 500K';

  @override
  String get price500kto1m => '500K - 1M';

  @override
  String get priceOver1m => 'Zaidi ya 1M';

  @override
  String get presetRoomsUnder200k => 'Vyumba chini ya 200K';

  @override
  String get preset2br => 'Nyumba za 2BR';

  @override
  String get presetOffices => 'Ofisi';

  @override
  String get presetShopsKariakoo => 'Maduka Kariakoo';

  @override
  String get recentSearches => 'Uliotafuta hivi karibuni';

  @override
  String get clear => 'Futa';

  @override
  String resultsCount(int count) {
    return 'Sehemu $count zimepatikana';
  }

  @override
  String get reset => 'Weka upya';

  @override
  String get noResults => 'Hakuna matokeo';

  @override
  String get differentTerm => 'Jaribu neno tofauti au vichujio vichache.';

  @override
  String get filters => 'Vichujio';

  @override
  String get apply => 'Tumia';

  @override
  String get sortNewest => 'Mpya zaidi';

  @override
  String get sortPriceAsc => 'Bei: ndogo kwanza';

  @override
  String get sortPriceDesc => 'Bei: kubwa kwanza';

  @override
  String get voiceListening => 'Ninaskiliza... ongea sasa';

  @override
  String get voiceDenied =>
      'Ruhusa ya kipaza sauti inahitajika kwa utafutaji wa sauti.';

  @override
  String get catAll => 'Zote';

  @override
  String get catRoom => 'Vyumba';

  @override
  String get catApartment => 'Apartamenti';

  @override
  String get catHouse => 'Nyumba';

  @override
  String get catOffice => 'Ofisi';

  @override
  String get catShop => 'Maduka';
}
