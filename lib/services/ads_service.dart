import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/constants/ads_constants.dart';
import '../core/logger/app_logger.dart';

class AdsService {
  AdsService();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await MobileAds.instance.initialize();
    _initialized = true;
    AppLogger.info('AdsService initialized');
  }

  Future<bool> showRewardedAd() async {
    AppLogger.debug(
      'Rewarded ad placeholder (unit: ${AdsConstants.testRewardedAdUnitId})',
    );
    return true;
  }

  Future<void> showInterstitialAd() async {
    AppLogger.debug(
      'Interstitial ad placeholder (unit: ${AdsConstants.testInterstitialAdUnitId})',
    );
  }
}
