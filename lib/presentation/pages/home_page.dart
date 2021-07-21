import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privacy_guard/presentation/design/circles_background/three_circles_builder.dart';
import 'package:privacy_guard/presentation/design/customIcons/icons.dart';
import 'package:privacy_guard/presentation/widgets/dialogs.dart';
import 'package:privacy_guard/presentation/widgets/home_page_header.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';
import '../bloc/home_buttons_bloc.dart';
import '../../utilities/privacy_item_info.dart';
import '../../const.dart';
import '../widgets/custom_grid_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getActivities(context);
    return Scaffold(
      body: ThreeCirclesBackground(
        sizeOfScreen: MediaQuery.of(context).size,
        gradientColor: GradientColor.Blue,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              Platform.isAndroid ?  IconButton(
                onPressed: () => DonationDialog(context).showWithAnimation(),
                icon: Icon(CustomIcons.hand_holding_heart, size: 20,),
              ) : SizedBox(),
              PopupMenuButton<String>(
                onSelected: (i) async {
                  if (!SharedPreferencesUtilities.launchViaUrl) {
                    await LaunchLinksWithBrowserDialog(context).show();
                  } else {
                    SharedPreferencesUtilities.setLaunchViaUrl(
                        !SharedPreferencesUtilities.launchViaUrl);
                  }
                  context.read<HomeButtonsBloc>().changeState();
                },
                itemBuilder: (BuildContext context) {
                  return {
                    'Launch links ${SharedPreferencesUtilities.launchViaUrl ? 'in-app' : 'with Browser'}'
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: BlocBuilder<HomeButtonsBloc, List<PrivacyItemInfo>>(
            builder: (context, buttons) => Column(
              children: [
                HomePageHeader(
                  buttons: buttons,
                ),
                Expanded(
                  //flex: 6,
                  child: Center(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: HomePageMainButtons(buttons),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getActivities(BuildContext context) async {
    Map<String, bool>? activities =
        await SharedPreferencesUtilities.getButtons();
    if (activities != null)
      context.read<HomeButtonsBloc>().changeActivities(activities);
  }
}

class HomePageMainButtons extends StatelessWidget {
  final List<PrivacyItemInfo> buttons;

  HomePageMainButtons(this.buttons);

  @override
  Widget build(BuildContext context) {
    return CustomGridView(
      buttons: buttons,
      duration: CONTAINER_ANIMATION_DURATION,
      onClosed: () => context.read<HomeButtonsBloc>().changeState(),
    );
  }
}
