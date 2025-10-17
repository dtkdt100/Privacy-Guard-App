import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:privacy_guard/const.dart';
import 'package:privacy_guard/presentation/design/customIcons/icons.dart';
import 'package:privacy_guard/utilities/in_app_purchases_utilities.dart';
import 'package:privacy_guard/utilities/shared_preferences_utilities.dart';

abstract class Dialog {
  final BuildContext context;
  final Widget child;

  Dialog(this.context, this.child);

  Future<void> show() async {
    await showDialog<void>(context: context, builder: (context) => child);
  }

  Future<void> showWithAnimation() async {
    await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.ease)).animate(a1),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) => child,
    );
  }
}

class LaunchLinksWithBrowserDialog extends Dialog {
  LaunchLinksWithBrowserDialog(BuildContext context)
      : super(context, dialog(context));

  static Widget dialog(BuildContext context) => AlertDialog(
        title: Text('Launch links with Browser'),
        content: Text('You will lose most of app features. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('NO'),
          ),
          TextButton(
            onPressed: () {
              SharedPreferencesUtilities.setLaunchViaUrl(
                  !SharedPreferencesUtilities.launchViaUrl);

              Navigator.pop(context);
            },
            child: Text('YES'),
          ),
        ],
      );
}

class SignInWarningDialog extends Dialog {
  SignInWarningDialog(BuildContext context) : super(context, dialog(context));

  static Widget dialog(BuildContext context) => AlertDialog(
        title: Text('Sign in'),
        content: Text(
            'To continue, login with Google. \nYou can be sure that we don’t use this data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      );
}

class DonationDialog extends Dialog {
  DonationDialog(BuildContext context) : super(context, dialog(context));
  static int selected = 1;

  static Widget dialog(BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 25),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.transparent)),
        content: Container(
          width: 1500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              header(),
              donations(),
              buttons(context),
            ],
          ),
        ),
      );

  static Widget header() {
    final TextStyle titleStyle = TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    final TextStyle firstLineStyle = TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );

    return Container(
      height: 250,
      width: 1500,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orange, Colors.deepOrange])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "Donate $APP_TITLE",
            style: titleStyle,
          ),
          Spacer(
            flex: 2,
          ),
          Icon(
            CustomIcons.hand_holding_heart,
            size: 75,
            color: Colors.white,
          ),
          Spacer(
            flex: 2,
          ),
          Text(
            "We will use your money to improve",
            style: firstLineStyle,
          ),
          Spacer(),
        ],
      ),
    );
  }

  static Widget donations() {
    final TextStyle numberStyle = TextStyle(
      color: Colors.black,
      fontSize: 22,
    );

    final TextStyle timeStyle = TextStyle(color: Colors.grey, fontSize: 13);

    final List<String> namesToPrices = [
      "Big",
      "Huge",
      "Super",
    ];

    final List<ProductDetails> items = InAppPurchaseUtilities.products;

    return StatefulBuilder(builder: (context, setState) {
      return Row(
        children: List.generate(
            items.length,
            (index) => Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selected = index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: index == selected ? 4.0 : 0.2,
                        shadowColor:
                            index == selected ? Colors.blue : Colors.grey,
                        primary: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: index == selected
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2.0))),
                    child: Container(
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${items[index].price}",
                              style: numberStyle.copyWith(
                                  color: index == selected
                                      ? Colors.blue
                                      : numberStyle.color)),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            namesToPrices[index] + "\ndonation",
                            style: timeStyle.copyWith(
                                color: index == selected
                                    ? Colors.blue
                                    : timeStyle.color),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
      );
    });
  }

  static Widget buttons(BuildContext context) {
    final OutlinedBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(color: Colors.transparent));

    final EdgeInsets padding =
        EdgeInsets.symmetric(vertical: 10, horizontal: 50);

    final TextStyle style = TextStyle(letterSpacing: 1.3, color: Colors.white);

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            InAppPurchaseUtilities.purchase(InAppPurchaseUtilities.products[selected]);
          },
          style: ElevatedButton.styleFrom(
            shape: shape,
            elevation: 0.0,
            onPrimary: Colors.blue,
            padding: padding,
          ),
          child: Text("CONTINUE", style: style),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            shape: shape,
            elevation: 0.0,
            padding: padding,
            primary: Colors.white,
          ),
          child: Text("NO THANKS", style: style.copyWith(color: Colors.grey)),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
