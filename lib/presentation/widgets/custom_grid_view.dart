import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:privacy_guard/const.dart';
import 'package:privacy_guard/presentation/pages/web_view_screen.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/home_buttons_bloc.dart';
import '../../utilities/privacy_item_info.dart';
import '../design/animation/animated_button_open_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../design/animation/material_ink_splash.dart';

class CustomGridView extends StatelessWidget {
  final List<PrivacyItemInfo> buttons;
  final int numOfColumns;
  final int numOfRows;
  final List<List<PrivacyItemInfo>> convertedButtons;
  final Duration duration;
  final VoidCallback? onClosed;

  CustomGridView({
    required this.buttons,
    this.numOfRows = 2,
    this.duration = const Duration(milliseconds: 1000),
    this.onClosed,
  })  : assert(buttons.length != 0),
        numOfColumns = (buttons.length / 2).ceil(),
        convertedButtons =
            convertList(buttons, (buttons.length / 2).ceil(), numOfRows);

  static List<List<PrivacyItemInfo>> convertList(
      List<PrivacyItemInfo> list, int numOfColumns, int numOfRows) {
    List<List<PrivacyItemInfo>> newList = [];
    int counter = 0;

    for (int i = 0; i < numOfColumns; i++) {
      newList.add([]);
      for (int j = 0; j < numOfRows; j++) {
        try {
          newList[i].add(list[counter]);
        } catch (e) {}
        counter++;
      }
    }
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: buildColumn(),
    );
  }

  Widget buildColumn() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children:
            List.generate(convertedButtons.length, (index) => buildRow(index)),
      );

  Widget buildRow(int columnIndex) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(convertedButtons[columnIndex].length,
            (index) => buildButton(convertedButtons[columnIndex][index])),
      );

  Widget buildButton(PrivacyItemInfo button) => Expanded(
        child: Container(
          margin: EdgeInsets.all(3),
          child: AnimatedButtonOpenContainer(
            duration: CONTAINER_ANIMATION_DURATION,
            onClosed: (o) {
              if (onClosed != null) onClosed!();
            },
            openPage: BlocProvider(
              create: (_) => HomeButtonsBloc(),
              child: WebViewScreen(
                privacyItemInfo: button,
              ),
            ),
            child: (openContainer) => Container(
              height: 105,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.grey,
                    elevation: 0.9,
                    splashFactory: MaterialInkSplash.splashFactory,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.transparent)),
                    padding: EdgeInsets.symmetric(horizontal: 25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadiantGradientMask(
                      child: button.icon,
                      colors: button.colors,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      button.label,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      button.active ? "Complete" : "Incomplete",
                      style: TextStyle(
                          fontSize: 8,
                          color: button.active ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onPressed: SharedPreferencesUtilities.launchViaUrl ? () => launch(button.url) : openContainer,
              ),
            ),
          ),
        ),
      );
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({
    required this.child,
    required this.colors,
  });

  final Widget child;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: colors,
      ).createShader(bounds),
      child: child,
    );
  }
}
