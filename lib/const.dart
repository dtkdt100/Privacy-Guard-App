import 'package:flutter/material.dart';

///Name of the app
const String APP_TITLE = "Privacy Guard";

///Colors
const Color MAIN_APP_BLUE_COLOR = Colors.blue;

///App
const Duration CONTAINER_ANIMATION_DURATION = Duration(milliseconds: 300);

///Sentences
const Map<String, List<String>> SENTENCES_WITH_PROGRESS = {
  "0.0": [
    "Your data is not private! Click start to begin protecting it.",
    "Your data is not safe! To protect it, click start.",
    "Your data is in dangerous hands! Click start."
  ],
  "0.2": [
    "Your data is not private! Click start to begin protecting it.",
    "Your data is not safe! To protect it, click start.",
    "Your data is in dangerous hands! Click start."
  ],
  "0.4": [
    "Nice progress, but this is not enough.",
    "You have more to go!",
    "Your data is still not private."
  ],
  "0.6": [
    "You are in the right way!",
    "Woah, you are half way there.",
    "Great progress, but more to go."
  ],
  "0.8": [
    "You are almost there!",
    "Only one last thing left!",
    "Come on, you can do better!"
  ],
  "1.0": [
    "Perfect! Share the revolution with your friends.",
    "Awesome! Share the revolution with your friends.",
    "Amazing job! Share the revolution with your friends."
  ],
};

///JavaScript - design
const String JS_GOOGLE_PERSONALIZATION_DESIGN =
    "document.getElementsByClassName('gb_B gb_bd gb_h gb_Af')[0].style.display='none';"
    "document.getElementsByClassName('kGxjkb')[0].style.border = 'thick solid #0000FF';"
    "document.getElementsByClassName('VYPuyc vmi1sd')[0].style.display='none';"
    "document.getElementsByClassName('BXmVwd')[0].style.display='none';"
    "document.getElementsByClassName('r4e3h')[0].style.display='none';"
    "document.getElementsByClassName('goYA4')[0].style.display='none';"
    "document.getElementsByClassName('tnTMg')[0].style.display='none';"
    "document.getElementsByClassName('AhDyOb')[0].style.display='none';";

const String JS_ALL_ACTIVITY_DESIGN =
    "document.getElementsByClassName('wJCOBf')[0].style.display='none';"
    "document.getElementsByClassName('GsLA0b')[0].style.border = 'thick solid #0000FF';"
    "document.getElementsByClassName('h9NEMd')[0].style.display='none';"
    "document.getElementsByClassName('oR8HYe')[0].style.display='none';"
    "document.getElementsByClassName('gb_we gb_ue')[0].style.display='none';"
    "document.getElementsByClassName('gb_B gb_bd gb_h gb_Af')[0].style.display='none';";

const String JS_APP_ACCESSING_GOOGLE_DATA_DESIGN =
    "document.getElementsByClassName('DPvwYc sm8sCf ew338c')[0].style.display='none';"
    "document.getElementsByClassName('gb_B gb_bd gb_h gb_Af')[0].style.display='none';";

///JavaScript - actions for privacy score
const String JS_GOOGLE_PERSONALIZATION_ACTION =
    "document.getElementsByClassName('LsSwGf PciPcd vBNbwc')[0].ariaChecked;";

const String JS_ALL_ACTIVITY_ACTION =
    "document.getElementsByClassName('VfPpkd-e9dDuf-bMcfAe')[0].ariaChecked;";
