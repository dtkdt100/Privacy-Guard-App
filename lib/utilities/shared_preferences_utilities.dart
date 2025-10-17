import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'privacy_item_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtilities {
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static String keyNameButtons = "buttons";
  static String keyNameSignInToGoogle = "SignIn";
  static String keyLaunchViaUrl = "launchViaUrl";
  static String keyFeatureDiscoveryStartButton = "startButton";
  static String keyStartIntroPage = "StartIntroPage";

  //static bool signInToGoogle = false;
  static bool launchViaUrl = false;
  static bool featureDiscoveryStartButton = false;
  static bool startIntroPage = true;

  ///Get all
  static Future<void> getAll() async {
    await getFeatureDiscoveryStartButton();
    await getLaunchViaUrl();
    await getStartIntroPage();
  }

  ///Clear all - for tests
  static Future<void> clearAllPreferences() async {
    (await prefs).clear();
  }

  ///Main Buttons of the app - complete / InComplete
  static Future<void> setButtons(List<PrivacyItemInfo> buttons) async {
    (await prefs).setString(keyNameButtons, convertListToMap(buttons));
  }

  static Future<Map<String, bool>?> getButtons() async {
    String? buttons = (await prefs).getString(keyNameButtons);
    if (buttons == null) return null;
    return decode(buttons);
  }

  ///Launch with browser - Yes / No
  static Future<void> setLaunchViaUrl(bool launchUrl) async {
    launchViaUrl = launchUrl;
    Fluttertoast.showToast(msg: 'Switched');
    (await prefs).setBool(keyLaunchViaUrl, launchUrl);
  }

  static Future<bool> getLaunchViaUrl() async {
    bool? launchUrl = (await prefs).getBool(keyLaunchViaUrl);
    launchViaUrl = launchUrl ?? false;
    return launchViaUrl;
  }

  ///Intro page in the start button - Should show it or not
  static Future<void> setStartIntroPage({bool startIntro = false}) async {
    startIntroPage = startIntro;
    (await prefs).setBool(keyStartIntroPage, startIntro);
  }

  static Future<bool> getStartIntroPage() async {
    bool? startIntro = (await prefs).getBool(keyStartIntroPage);
    startIntroPage = startIntro ?? true;
    return startIntroPage;
  }

  ///Feature discovery on the start button - Should show it or not
  static Future<void> setFeatureDiscoveryStartButton({bool complete = false}) async {
    featureDiscoveryStartButton = complete;
    (await prefs).setBool(keyFeatureDiscoveryStartButton, complete);
  }

  static Future<bool> getFeatureDiscoveryStartButton() async {
    bool? complete = (await prefs).getBool(keyFeatureDiscoveryStartButton);
    featureDiscoveryStartButton = complete ?? true;
    return featureDiscoveryStartButton;
  }


  // static Future<void> setSignIntoGoogle(bool isSign) async {
  //   signInToGoogle = isSign;
  //   (await prefs).setBool(keyNameSignInToGoogle, isSign);
  // }
  //
  // static Future<bool> getSignIntoGoogle() async {
  //   bool? signIn = (await prefs).getBool(keyNameSignInToGoogle);
  //   signInToGoogle = signIn != null;
  //   return signInToGoogle;
  // }

  static String convertListToMap(List<PrivacyItemInfo> buttons) {
    Map<String, bool> map = {};
    for (var button in buttons) {
      map[button.label] = button.active;
    }
    return encode(map);
  }

  static String encode(Map<String, bool> map) => json.encode(map);

  static Map<String, bool> decode(String map) =>
      Map<String, bool>.from(json.decode(map));
}