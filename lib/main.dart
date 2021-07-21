import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privacy_guard/presentation/design/animation/material_ink_splash.dart';
import 'package:privacy_guard/presentation/pages/home_page.dart';
import 'package:privacy_guard/presentation/pages/splash_screen.dart';
import 'package:privacy_guard/presentation/widgets/home_page_header.dart';
import 'package:privacy_guard/utilities/in_app_purchases_utilities.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';
import 'presentation/bloc/home_buttons_bloc.dart';
import 'const.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool doneLoadMemory = false;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
    getMemory();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery.withProvider(
      persistenceProvider: NoPersistenceProvider(),
      child: MaterialApp(
        title: APP_TITLE,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          splashFactory: MaterialInkSplash.splashFactory,
          textTheme: TextTheme(caption: TextStyle(color: MAIN_APP_BLUE_COLOR)),
          primaryTextTheme:
              TextTheme(caption: TextStyle(color: MAIN_APP_BLUE_COLOR)),
        ),
        debugShowCheckedModeBanner: false,
        home: doneLoadMemory ? BlocProvider(
          create: (_) => HomeButtonsBloc(),
          child: HomePage(),
        ) : SplashScreen()
      ),
    );
  }

  Future<void> getMemory() async {
    HomePageHeader.randomNumberForSentences =
        Random().nextInt(SENTENCES_WITH_PROGRESS["0.0"]!.length);
    await Future.delayed(Duration(milliseconds: 500));
    await SharedPreferencesUtilities.getAll();

    if (Platform.isAndroid)
      await InAppPurchaseUtilities.initStoreInfo();

    setState(() {
      doneLoadMemory = true;
    });
  }
}


