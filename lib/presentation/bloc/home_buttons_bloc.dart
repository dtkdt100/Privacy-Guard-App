import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privacy_guard/presentation/design/customIcons/icons.dart';
import 'package:privacy_guard/presentation/widgets/home_page_header.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';
import '../../utilities/privacy_item_info.dart';
import '../../const.dart';

class HomeButtonsBloc extends Cubit<List<PrivacyItemInfo>>{
  HomeButtonsBloc() : super(_buttons);

  static List<PrivacyItemInfo> _buttons = [
    PrivacyItemInfo(
      label: "Google personalization",
      icon: defaultPrivacyControlIcon(CustomIcons.google, size: 35),
      colors: [Colors.blue[500]!, Colors.lightBlue[500]!],
      url: "https://adssettings.google.com/authenticated",
      javaScriptDesign: JS_GOOGLE_PERSONALIZATION_DESIGN,
      javaScriptAction: JS_GOOGLE_PERSONALIZATION_ACTION,
    ),
    PrivacyItemInfo(
      label: "Location history",
      icon: defaultPrivacyControlIcon(Icons.location_history),
      colors: [Colors.purple[500]!, Colors.purpleAccent[700]!],
      url: "https://myactivity.google.com/activitycontrols?settings=location",
      showUrl: "https://www.google.com/maps/timeline",
      javaScriptDesign: JS_ALL_ACTIVITY_DESIGN,
      javaScriptAction: JS_ALL_ACTIVITY_ACTION,
    ),
    PrivacyItemInfo(
      icon: defaultPrivacyControlIcon(Icons.search),
      label: "Activity",
      colors: [Colors.teal[500]!, Colors.tealAccent[700]!],
      url: "https://myactivity.google.com/activitycontrols?settings=search",
      showUrl: "https://myactivity.google.com/activitycontrols/webandapp",
      javaScriptDesign: JS_ALL_ACTIVITY_DESIGN,
      javaScriptAction: JS_ALL_ACTIVITY_ACTION,
    ),
    PrivacyItemInfo(
      icon: defaultPrivacyControlIcon(CustomIcons.youtube_play, size: 35),
      label: "Youtube history",
      colors: [Colors.red[500]!, Colors.redAccent[700]!],
      url: "https://myactivity.google.com/activitycontrols?settings=youtube",
      showUrl: "https://myactivity.google.com/activitycontrols/youtube",
      javaScriptDesign: JS_ALL_ACTIVITY_DESIGN,
      javaScriptAction: JS_ALL_ACTIVITY_ACTION,
    ),
    PrivacyItemInfo(
      icon: defaultPrivacyControlIcon(Icons.apps),
      label: "Apps accessing Google data",
      colors: [Colors.blueGrey[500]!, Colors.blueGrey[600]!],
      url: "https://myaccount.google.com/permissions",
      javaScriptDesign: JS_APP_ACCESSING_GOOGLE_DATA_DESIGN,
    ),
  ];


  static Icon defaultPrivacyControlIcon(IconData iconData,
      {double size = 40, Color color = Colors.white}) =>
      Icon(
        iconData,
        size: size,
        color: color,
      );

  void changeState() => emit(List<PrivacyItemInfo>.from(state));

  void changeComplete(int index, {bool change = true}) {
    List<PrivacyItemInfo> newList = List.from(state);
    newList[index].active = change;
    SharedPreferencesUtilities.setButtons(newList);
    HomePageHeader.randomNumberForSentences = Random().nextInt(SENTENCES_WITH_PROGRESS["0.0"]!.length);
    return emit(newList);
  }

  void changeActivities(Map<String, bool> activities, {bool? change}) {
    List<PrivacyItemInfo> newList = List.from(state);
    activities.forEach((key, value) {
      newList[where(key)].active = change ?? value;
    });
    SharedPreferencesUtilities.setButtons(newList);
    return emit(newList);
  }

  static int where(String buttonName) =>
      _buttons.indexWhere((element) => element.label == buttonName);
}