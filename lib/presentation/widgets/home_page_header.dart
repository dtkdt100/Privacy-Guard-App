import 'dart:math';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:privacy_guard/presentation/design/animation/animated_button_open_container.dart';
import 'package:privacy_guard/presentation/design/animation/material_ink_splash.dart';
import 'package:privacy_guard/presentation/widgets/start_screen.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';
import '../bloc/home_buttons_bloc.dart';
import '../../utilities/privacy_item_info.dart';
import '../../const.dart';

class HomePageHeader extends StatelessWidget {
  final List<PrivacyItemInfo> buttons;
  final String featureId =
      SharedPreferencesUtilities.keyFeatureDiscoveryStartButton;

  HomePageHeader({
    required this.buttons,
  });

  static int randomNumberForSentences = -1;

  @override
  Widget build(BuildContext context) {

    SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
      if (SharedPreferencesUtilities.featureDiscoveryStartButton)
        FeatureDiscovery.discoverFeatures(
          context,
          <String>{
            featureId,
          },
        );
    });

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Protect Your Privacy",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                color: Colors.white),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            SENTENCES_WITH_PROGRESS[percentLinearPercentIndicator(buttons)
                .toString()]![HomePageHeader.randomNumberForSentences],
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Colors.white),
          ),
          SizedBox(
            height: 50,
          ),
          AnimatedButtonOpenContainer(
            onClosed: (o) {
              context.read<HomeButtonsBloc>().changeState();
            },
            openPage: BlocProvider(
              create: (_) => HomeButtonsBloc(),
              child: StartScreen(generateButtonsToIntroScreen(buttons)),
            ),
            child: (openContainer) =>
                describedFeature(startButton(openContainer, context), () async {
              FeatureDiscovery.completeCurrentStep(context);
              Future.delayed(Duration(milliseconds: 300), () {
                openContainer();
              });
              return true;
            }),
            border: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.transparent)),
            duration: CONTAINER_ANIMATION_DURATION,
          ),
          SizedBox(
            height: 25,
          ),
          LinearPercentIndicator(
            lineHeight: 14.0,
            percent: percentLinearPercentIndicator(buttons),
            animation: true,
            progressColor: Colors.white,
            animateFromLastPercent: true,
          ),
        ],
      ),
    );
  }

  List<PrivacyItemInfo> generateButtonsToIntroScreen(
      List<PrivacyItemInfo> buttons) {
    SharedPreferencesUtilities.setStartIntroPage();
    Widget childToIntro =  Container(
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 160),
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2,),
            Expanded(
              flex: 3,
              child: Image.asset('assets/Data_security.png', scale: 1.7,),
            ),
            Spacer(),
            Text(
              'Privacy Matters',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  letterSpacing: 0.7,
                  height: 1.7),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Review your privacy settings, disable what you don’t need. Click next.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.7, letterSpacing: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
    List<PrivacyItemInfo> newButtons = List.from(buttons);
    newButtons.insert(
        0,
        PrivacyItemInfo(
            label: "Intro",
            icon: Icon(Icons.add),
            url: "",
            child: childToIntro));
    return newButtons;
  }

  double percentLinearPercentIndicator(List<PrivacyItemInfo> buttons) {
    int countActive = 0;
    buttons.forEach((element) {
      countActive += element.active ? 1 : 0;
    });
    return countActive / buttons.length;
  }

  Widget describedFeature(Widget child, Future<bool> Function()? onComplete) =>
      DescribedFeatureOverlay(
        tapTarget: Text(
          "Start",
          style: TextStyle(
            //color: MAIN_APP_RED_COLOR,
            color: MAIN_APP_BLUE_COLOR,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text('Protect Your Privacy'),
        description:
            Text('Start by viewing and adjusting your privacy settings.\n'),
        overflowMode: OverflowMode.wrapBackground,
        backgroundColor: Colors.grey[900],
        featureId: featureId,
        onComplete: onComplete,
        onOpen: () async {
          SharedPreferencesUtilities.setFeatureDiscoveryStartButton();
          return true;
        },
        onDismiss: () async => true,
        child: child,
      );

  Widget startButton(VoidCallback onPressed, BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.grey,
            elevation: 0.9,
            splashFactory: MaterialInkSplash.splashFactory,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.transparent)),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 11)),
        child: Text(
          "Start",
          style: TextStyle(
            //color: MAIN_APP_RED_COLOR,
            color: MAIN_APP_BLUE_COLOR,
            fontSize: 19,
          ),
        ),
        onPressed: SharedPreferencesUtilities.launchViaUrl
            ? () => showBrowserModeSnackBar(context)
            : onPressed,
      );

  void showBrowserModeSnackBar(BuildContext context){
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Switch to Launch links in-app to get all features.'),
      action: SnackBarAction(
        label: 'Switch',
        onPressed: () {
          SharedPreferencesUtilities.setLaunchViaUrl(
              !SharedPreferencesUtilities.launchViaUrl);
          context.read<HomeButtonsBloc>().changeState();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
